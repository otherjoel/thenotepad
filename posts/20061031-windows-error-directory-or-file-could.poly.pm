#lang pollen

◊(define-meta title "Windows error: Directory or File could not be created")
◊(define-meta published "2006-10-31")
◊(define-meta topics "Filesystem")

I once helped a guy out with a wierd problem: he was trying to save an Excel Spreadsheet to a USB flash drive, and kept coming up with this error:

◊blockquote{
◊code{The file or directory could not be created.}
}

We tried dragging and dropping the file – same error. There was plenty of space available on the USB drive, and fragmentation was not an issue.

I finally figured out that the problem was that the flash drive’s root directory (where we were trying to save the file) had too many files with really long filenames. The FAT filesystem has a limit on the number of filename ◊emph{characters} that can be used in the root directory. From ◊link["http://www.microsoft.com/technet/archive/winntas/tips/techrep/filesyst.mspx?mfr=true"]{MS TechNet} :

◊blockquote{
“An interesting side effect results from the way VFAT stores its long filenames. When you create a long filename with VFAT, it uses one directory entry for the MS-DOS alias and another entry for every 13 characters of the long filename. In theory, a single long filename could occupy up to 21 directory entries. The root directory has a limit of 512 files, but if you were to use the maximum length long filenames in the root directory, you could cut this limit to a mere 24 files. Therefore, you should use long filenames very sparingly in the root directory. Other directories aren’t affected by this limit.”
}

This drive’s root directory had a lot of files with ◊emph{very} long filenames, so that although there was plenty of physical space available for storage, the limitations of the filesystem itself prevented the addition of another file with more than ten or so characters in the filename.

This was confirmed when we renamed the file ◊code{test.xls} (fewer letters) and were able to copy it to the flash drive successfully.

The solution, as you might suspect, is better organization. Rather than storing all your files in the root directory, create some folders and store your files inside those.

Most USB drives are formatted as FAT for compatibility between various platforms and I suggest you leave it that way.
