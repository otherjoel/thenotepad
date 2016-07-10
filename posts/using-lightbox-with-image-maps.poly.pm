#lang pollen

◊(define-meta title "Using LightBox with Image Maps")
◊(define-meta published "2009-08-01")
◊(define-meta topics "JavaScript")

I ran across this while assembling the website for my brothers’ new film ◊emph{The Little Red Plane}. Don’t ask why I needed to do use image maps in this day and age. But I did.

I decided to use the fairly awesome ◊link["http://www.lokeshdhakar.com/projects/lightbox2/"]{LightBox} script (version 2.04) for certain aspects of the site, but the links that would trigger it were in an image map, which uses ◊code{<area>} tags instead of ◊code{<a>} tags. When I clicked on the links, the page would go dark but no image overlay was displayed.

The solution was found ◊link["http://www.dynamicdrive.com/forums/archive/index.php/t-20154.html"]{here}. Apparently 2.03 worked fine with image maps but 2.04 has this regression.

To fix, open ◊code{lightbox.js} in a text editor, scroll down to the ◊code{start()} function and insert the line highlighted below:

◊blockcode{//
//  start()
//  Display overlay and lightbox. If image is part of a set, add siblings to imageArray.
//
start: function(imageLink) {
   $$('select', 'object', 'embed').each(function(node){ node.style.visibility = 'hidden' });

   // stretch overlay to fill page and fade in
   var arrayPageSize = this.getPageSize();
   $('overlay').setStyle({ width: arrayPageSize[0] + 'px', height: arrayPageSize[1] + 'px' });

   new Effect.Appear(this.overlay, { duration: this.overlayDuration, from: 0.0, to: LightboxOptions.overlayOpacity });

   this.imageArray = [];
   var imageNum = 0;

   imageLink.rel = imageLink.getAttribute('rel');

   if ((imageLink.rel == 'lightbox')){
      // if image is NOT part of a set, add single image to imageArray
      this.imageArray.push([imageLink.href, imageLink.title]);
   } else {
      // if image is part of a set..
      this.imageArray =
         $$(imageLink.tagName + '[href][rel="' + imageLink.rel + '"]').
         collect(function(anchor){ return [anchor.href, anchor.title]; }).
         uniq();

      while (this.imageArray[imageNum][0] != imageLink.href) { imageNum++; }
   }
}}

Save the file. Now all you have to do is add ◊code{rel="lightbox"} to your ◊code{<area>} tags, just as you would with normal links.

◊comment[#:author "Jean"
         #:datetime "April 30, 2011"
         #:authorlink "http://deepthoughtsbyjean.wordpress.com/"]{Thanks for this! Exactly what I was looking for. I’m using v2.05 of the script.}

◊comment[#:author "Baeta"
         #:datetime "November 21, 2011"
         #:authorlink "https://www.blogger.com/profile/11334348926905674777"]{Thanks man. Simple and work perfectly!}

◊comment[#:author "LeE"
         #:datetime "February 04, 2012"
         #:authorlink "https://www.blogger.com/profile/09716083308964829701"]{Thank you very much! I was also looking for this. Solved my problem easily!}

◊comment[#:author "hiram"
         #:datetime "March 18, 2012"
         #:authorlink "https://www.blogger.com/profile/05790412345718286045"]{I am currently working with lightbox2.05 and image map and your 1 line addition worked to link them up. Thank you. I also found a way to pin the image container more or less where I wanted it.

Now I would like to have the NEXT and PREV tabs appear in the box with CloseX in the same manner without the rollover needed. I found 1 hint about changing 15% in a line in the css style file, but that did not move it down to the box with CloseX, only to the bottom of the image frame.
Does anyone have any ideas?
Thank you
Hiram Levy}

◊comment[#:author "Meldraw"
         #:datetime "March 22, 2012"
         #:authorlink "https://www.blogger.com/profile/01484364710815612789"]{Perfect. Exactly what I needed, and a simple fix. THANK YOU!}

◊comment[#:author "h_charles67"
         #:datetime "November 11, 2012"
         #:authorlink "https://www.blogger.com/profile/10807685903622185588"]{This fix didn’t work for version 2.51. The solution was to find line 286: ◊code{var anchors = document.getElementsByTagName("a");} and change ◊code{a} to ◊code{area}. That will, of course, stop lightbox from working with ordinary ‘a’ tags.}
