#lang pollen

◊(define-meta title "Fix severe delays when loading Excel 2003 files from network drives")
◊(define-meta published "2012-06-01")
◊(define-meta topics "Excel,AutoCAD")

I was recently made aware of a problem where Excel 2003 would take several minutes to load a spreadsheet from a network drive. What made it even worse was that several of these sheets were referenced inside a CAD drawing (meaning AutoCAD would open Excel in the background for each spreadsheet referenced), and the load delay for each individual spreadsheet made it was near-impossible for the drawing to ◊emph{ever} finish loading.

I found three possible solutions to the problem.

The first (which I used) was to create or modify the following registry key using ◊code{regedit}:

◊blockcode{[HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Excel\Security\FileValidation]
"EnableOnLoad"=dword:00000000}

The second option is to uninstall the Microsoft Office File Validation Add-in from the Control Panel.

The third is to upgrade to Excel 2007 or later.
