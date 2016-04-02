#!/usr/local/bin/python3

import re
import os
import sys
import shutil
import urllib
import codecs
import datetime
import requests
import rfc3339
import subprocess
from lxml import etree
from bs4 import BeautifulSoup
from collections import namedtuple

namespaces = {
    'atom': 'http://www.w3.org/2005/Atom',
    'app': 'http://purl.org/atom/app#',
    'thr': 'http://purl.org/syndication/thread/1.0'
    }

kind_post    = 'http://schemas.google.com/blogger/2008/kind#post'
kind_comment = 'http://schemas.google.com/blogger/2008/kind#comment'

BlogPost = namedtuple('BlogPost', ['slug', 'title', 'date', 'tags', 'text'])
BlogComment = namedtuple('BlogComment', ['slug', 'date', 'author', 'uri', 'text'])

def markdownify(html):
	p = subprocess.Popen(['pandoc', '--normalize', '--smart',
		'--wrap=none', '-f', 'html', '-t', 'markdown_strict+footnotes', '-'],
		stdin=subprocess.PIPE,
		stdout=subprocess.PIPE)
	stdout, stderr = p.communicate(input=html.encode('utf-8'))

	return stdout.decode('utf-8')

def process_post(entry):
	"""
	Parses an <entry> element from a Blogger-exported XML file into a
	BlogPost named tuple.

	Returns a dictionary item with the url slug as the key, or
	None if this entry is marked as a draft, or has no title.
	"""

	if entry.xpath('app:control', namespaces=namespaces):
		stat('draft found!')
		return

	x_title = entry.xpath('atom:title[@type="text"]', namespaces=namespaces)[0].text
	if x_title is None: return

	x_pubdate = rfc3339.parse_datetime(
		entry.xpath('atom:published', namespaces=namespaces)[0].text)

	x_tags = entry.xpath('atom:category[@scheme="http://www.blogger.com/atom/ns#"]',
		namespaces=namespaces)

	x_tags = ','.join([ x.get('term') for x in x_tags ])

	try:
		x_url_slug = entry.xpath('atom:link[@rel="alternate" and @type="text/html"]',
			namespaces=namespaces)[0].get('href')
	except IndexError:
		stat('No link!')
		return

	x_url_slug = re.search('[^/]+(?=\.html)', x_url_slug).group(0)
	x_text = entry.xpath('atom:content', namespaces=namespaces)[0].text

	return {x_url_slug:BlogPost(
		slug = x_url_slug,
		date = x_pubdate,
		title= x_title,
		tags = x_tags,
		text = x_text)}

def process_comment(entry):
	"""
	Parses an <entry> element from a Blogger-exported XML file into a
	BlogComment named tuple.

	Returns the tuple or None if the comment's parent article cannot
	be identified.
	"""

	x_pubdate = rfc3339.parse_datetime(
		entry.xpath('atom:published', namespaces=namespaces)[0].text)

	x_author =    entry.xpath('atom:author', namespaces=namespaces)[0]
	x_uri    = x_author.xpath('atom:uri', namespaces=namespaces)[0].text
	x_author = x_author.xpath('atom:name', namespaces=namespaces)[0].text
	x_text   =    entry.xpath('atom:content', namespaces=namespaces)[0].text

	try:
		x_url_slug = entry.xpath(
			'thr:in-reply-to', namespaces=namespaces)[0].get('href')
	except IndexError:
		stat("no link for comment by %s" % x_author)
		return

	x_url_slug = re.search('[^/]+(?=\.html)', x_url_slug).group(0)

	return BlogComment(
		slug = x_url_slug,
		date = x_pubdate,
		author = x_author,
		uri = x_uri,
		text = x_text)

def import_blogger_xml(doc):
	posts = {}
	comments = []

	# Sort out the posts and comments
	for entry in doc.xpath('//atom:entry', namespaces=namespaces):
		entry_type = entry.xpath(
            'atom:category[@scheme="http://schemas.google.com/g/2005#kind"]',
            namespaces=namespaces)[0].get('term')

		if entry_type == kind_post:
			p = process_post(entry)
			if p: posts.update(p)
		elif entry_type == kind_comment:
			c = process_comment(entry)
			if c: comments.append(c)

	return (posts, comments)

def build_comment_footers(comments):
	comment_footers = {}

	for comment in comments:
		if not comment.slug in comment_footers:
			this_footer = u"\n## Comments\n\n"
		else:
			this_footer = comment_footers[comment.slug]

		this_footer += u"### [%s](%s) said:\n\n%s\n\n(Comment posted %s)\n\n" % (
			comment.author,
			comment.uri,
			markdownify(comment.text),
			comment.date.strftime("%B %d, %Y"))

		comment_footers[comment.slug] = this_footer

	return comment_footers

def download_image(image_url, foldername):
	"""
	Downloads an image over HTTP and saves it in the specified folder
	Ensures that the local filename is unique within the folder by
	padding it with two-digit numbers.

	Returns the filename of the saved image file.
	"""

	stat("Downloading image: %s" % image_url)
	response = requests.get(image_url, stream=True)

	if response.status_code == 200:
		m = re.search('[^/]+\.(png|jpg|gif|jpeg|bmp|tiff)$',image_url,
			re.IGNORECASE)
		if m is None:
			stat("(BAD LINK, no extension: %s )" % image_url)
			return "BAD LINK:"+image_url

		filename = urllib.parse.unquote(m.group(0)).lower()
		filename = filename.split('.')[0] + "." + filename.split('.')[-1]
		filename = re.sub(r'[^a-zA-Z0-9\.]','', filename)

		temp_filename = filename
		x = 2
		while os.path.isfile(os.path.join(foldername,temp_filename)):
			file_parts = filename.split('.')
			temp_filename = file_parts[0] + ("%02d" % x) + "." + file_parts[-1]
			x += 1

		filename = temp_filename

		stat("(Response GOOD, image has filename: %s )" % filename)

		with open(os.path.join(foldername,filename), 'wb') as out_file:
			shutil.copyfileobj(response.raw, out_file)
	else:
		filename = "BAD HTTP response: "+image_url
		stat(filename)

	del response
	return filename


def write_output(posts, comment_footers):
	for slug, article in posts.items():
		stat("Processing article: %s" % slug)
		foldername = "out/"
		txtfilename = os.path.join(foldername, ("%04d%02d%02d-%s.md" % (article.date.year,
		article.date.month,
			article.date.day,
			slug)))

		if not os.path.exists(foldername):
			stat("Creating folder: %s" % foldername)
			os.makedirs(foldername)

		soup = BeautifulSoup(article.text, "lxml")
		for image in soup.findAll("img"):
			if image["src"].find('assoc-amazon') != -1: continue

			filename = download_image(image["src"], foldername)
			newimg = soup.new_tag("img")
			newimg["src"] = "img/%s" % filename
			image.replace_with(newimg)

		stat("Opening file: %s" % txtfilename)
		with codecs.open(txtfilename,
			'w', encoding='utf-8') as fd:
			fd.write('---\ntitle: \'%s\'\n' % article.title)
			fd.write('published: %04d-%02d-%02d\n' % (article.date.year,
				article.date.month, article.date.day))
			if article.tags: fd.write('tags: %s\n' % article.tags)
			fd.write('---\n\n%s' % markdownify(soup))

			if slug in comment_footers:
				fd.write(comment_footers[slug])

def stat(str):
	print ("[%s] %s" % (
		datetime.datetime.now().strftime("%X"),
		str))

def main():
	with open('blog.xml') as fd:
		doc = etree.parse(fd)

	stat("parsing XML")
	articles, comments = import_blogger_xml(doc)

	stat("Building comment footers")
	comment_footers = build_comment_footers(comments)

	stat("=== BEGINNING FILE OUTPUT ===")
	write_output(articles, comment_footers)


if __name__ == '__main__':
    main()
