◊(local-require "../util-date.rkt")
◊(define (print-if thing fmt)
   (if thing (format fmt thing) ""))
\documentclass[12pt]{article}

\usepackage{amssymb,amsmath}

\usepackage[T1]{fontenc}
%\usepackage[utf8]{inputenc}

\usepackage{eurosym}
\usepackage{fancyvrb}
\usepackage{longtable,booktabs}
\usepackage{attrib}
\usepackage{graphicx}
\usepackage{mathspec}
\usepackage{xltxtra,xunicode}
\usepackage{xspace}

\defaultfontfeatures{Scale=MatchLowercase}

\usepackage{microtype}
\usepackage{fontspec}

%% Typography defaults
\newfontfamily\linenumberfont[Mapping=tex-text]{Fira Mono OT}

\setsansfont[
    ItalicFont     = HelveticaNeue-Italic,
    BoldFont       = HelveticaNeue-Bold,
    BoldItalicFont = HelveticaNeue-BoldItalic]{HelveticaNeue}
\setmainfont[Mapping=tex-text,SmallCapsFeatures={LetterSpace=5.5}]{Source Sans Pro}
\setmonofont{Triplicate T4c}
\newfontfamily\NHLight[
   ItalicFont     = HelveticaNeue-LightItalic,
   BoldFont       = HelveticaNeue-UltraLight,
   BoldItalicFont = HelveticaNeue-UltraLightItalic]{HelveticaNeue-Light}

\usepackage{xcolor}
\definecolor{mygray}{rgb}{0.7,0.7,0.7}
\definecolor{light-gray}{gray}{0.95}
\definecolor{tweet-cyan}{RGB}{154,228,232}

\usepackage[framemethod=PSTricks]{mdframed}  % used for embedding tweets
\global\mdfdefinestyle{tweet}{% 
    linecolor=tweet-cyan,middlelinewidth=6pt,%
    leftmargin=2.5cm,rightmargin=2.5cm,roundcorner=10
}

\usepackage{textcomp}
\usepackage{upquote}
\usepackage{listings}
\lstset{
    basicstyle=\footnotesize\ttfamily,
    columns=flexible,
    breaklines=true,
    numbers=left,
    upquote=true,
    backgroundcolor=\color{light-gray},
    numbersep=5pt,
    xleftmargin=.25in,
    xrightmargin=.25in,
    framexleftmargin=.25in,
    numberstyle=\footnotesize\color{mygray}\linenumberfont
}

\makeatletter
\def\maxwidth{\ifdim\Gin@nat@width>\linewidth\linewidth\else\Gin@nat@width\fi}
\def\maxheight{\ifdim\Gin@nat@height>\textheight\textheight\else\Gin@nat@height\fi}
\makeatother

% Scale images if necessary, so that they will not overflow the page
% margins by default, and it is still possible to overwrite the defaults
% using explicit options in \includegraphics[width, height, ...]{}
\setkeys{Gin}{width=\maxwidth,height=\maxheight,keepaspectratio}

  \usepackage[setpagesize=false, % page size defined by xetex
              unicode=false, % unicode breaks when used with xetex
              xetex]{hyperref}

\hypersetup{breaklinks=true,
            bookmarks=true,
            pdfauthor={◊(print-if (select-from-metas 'author metas) "~a")},
            pdftitle={◊when/splice[(select-from-metas 'title metas)]{◊(ltx-escape-str (select-from-metas 'title metas))}},
            colorlinks=true,
            citecolor=blue,
            urlcolor=blue,
            linkcolor=magenta,
            pdfborder={0 0 0}}
\urlstyle{same}  % don't use monospace font for urls

% Make links footnotes instead of hotlinks:
\renewcommand{\href}[2]{#2\footnote{\url{#1}}}

% Make margin notes (from Tufte-LaTeX) into regular footnotes
\newcommand{\marginnote}[1]{\footnote{#1}}
\newcommand{\smallcaps}[1]{\textsc{#1}}

\setlength{\parindent}{0pt}
\setlength{\parskip}{6pt plus 2pt minus 1pt}
\setlength{\emergencystretch}{3em}  % prevent overfull lines

\setcounter{secnumdepth}{0}

\VerbatimFootnotes % allows verbatim text in footnotes

%% Titling package allows for macros \thetitle \theauthor, etc
\usepackage{titling}

\title{◊when/splice[(select-from-metas 'title metas)]{◊(ltx-escape-str (select-from-metas 'title metas))}}
◊(print-if (select-from-metas 'author metas) "\\author{~a}")
\date{◊(unless (not (select-from-metas 'published metas)) (pubdate->english (select-from-metas 'published metas)))}

%% Reduced margins
%\usepackage[margin=1.2in]{geometry}

%% Paragraph and line spacing
%\linespread{1.05} % a bit more vertical space
%\setlength{\parskip}{\baselineskip} % space between paragraphs spacing is one baseline unit

%% Sections headings spacing: one baseline unit before, none after
\usepackage{titlesec}
\titlespacing{\section}{0pt}{\baselineskip}{0pt}
\titlespacing{\subsection}{0pt}{\baselineskip}{0pt}
\titlespacing{\subsubsection}{0pt}{\baselineskip}{0pt}

% Customize footnotes so that, within the footnote, the footnote number is
% the same size as the footnote text (per Bringhurst).
%
\usepackage[splitrule,multiple,hang]{footmisc}
\makeatletter
\renewcommand\@makefntext[1]{\parindent 1em%
    \noindent
    \hb@xt@0em{\hss\normalfont\@thefnmark.} #1}
\def\splitfootnoterule{\kern-3\p@ \hrule width 1in \kern2.6\p@}
\makeatother
\renewcommand\footnotesize{\fontsize{10}{12} \selectfont}
\renewcommand{\thefootnote}{\arabic{footnote}}

%% Main doc
\begin{document}

\begingroup  
  \centering
  {\LARGE\bf \thetitle}\\[1em]
  \normalsize\sc \thedate\\[1.5em]
  \par
\endgroup

◊(local-require racket/list)
◊(apply string-append (filter string? (flatten doc)))

\end{document}
