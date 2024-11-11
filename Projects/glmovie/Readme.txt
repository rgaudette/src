TODO:
 - position control window correctly

 - add controls to go to a specifiec time instant

 - status bar should be hidden by default, until something is in there

MATLAB file opening
 - BUG: can not open the same file mutlple times in a row,
   need to open another file first.

GL Code
 - Fix rendering so that it is accurate on screen and set appropriate viewports for
 - optimizations
   * only draw triangles that are necessary
   * display list the grid, colorbar and text if constant

 - make sure that all of the document info is in the document class and
   that GL class only has pointers to appropriate data
 
 - add labels to the display and colorbar

 - add the ability to open other windows with specific lead plots
 
 - add text labels to the colorbar and title (frame number)

 - add the ability to overlay color velocity vectors over optical map
   intensity data in black & white

========================================================================
       MICROSOFT FOUNDATION CLASS LIBRARY : glmovie
========================================================================


AppWizard has created this glmovie application for you.  This application
not only demonstrates the basics of using the Microsoft Foundation classes
but is also a starting point for writing your application.

This file contains a summary of what you will find in each of the files that
make up your glmovie application.

glmovie.h
    This is the main header file for the application.  It includes other
    project specific headers (including Resource.h) and declares the
    CGlmovieApp application class.

glmovie.cpp
    This is the main application source file that contains the application
    class CGlmovieApp.

glmovie.rc
    This is a listing of all of the Microsoft Windows resources that the
    program uses.  It includes the icons, bitmaps, and cursors that are stored
    in the RES subdirectory.  This file can be directly edited in Microsoft
	Developer Studio.

res\glmovie.ico
    This is an icon file, which is used as the application's icon.  This
    icon is included by the main resource file glmovie.rc.

res\glmovie.rc2
    This file contains resources that are not edited by Microsoft 
	Developer Studio.  You should place all resources not
	editable by the resource editor in this file.

glmovie.clw
    This file contains information used by ClassWizard to edit existing
    classes or add new classes.  ClassWizard also uses this file to store
    information needed to create and edit message maps and dialog data
    maps and to create prototype member functions.

/////////////////////////////////////////////////////////////////////////////

For the main frame window:

MainFrm.h, MainFrm.cpp
    These files contain the frame class CMainFrame, which is derived from
    CFrameWnd and controls all SDI frame features.

res\Toolbar.bmp
    This bitmap file is used to create tiled images for the toolbar.
    The initial toolbar and status bar are constructed in the
    CMainFrame class.  Edit this toolbar bitmap along with the
    array in MainFrm.cpp to add more toolbar buttons.

/////////////////////////////////////////////////////////////////////////////

AppWizard creates one document type and one view:

glmovieDoc.h, glmovieDoc.cpp - the document
    These files contain your CGlmovieDoc class.  Edit these files to
    add your special document data and to implement file saving and loading
    (via CGlmovieDoc::Serialize).

glmovieView.h, glmovieView.cpp - the view of the document
    These files contain your CGlmovieView class.
    CGlmovieView objects are used to view CGlmovieDoc objects.


/////////////////////////////////////////////////////////////////////////////

Help Support:

MakeHelp.bat
    Use this batch file to create your application's Help file, glmovie.hLP.

glmovie.hpj
    This file is the Help Project file used by the Help compiler to create
    your application's Help file.

hlp\*.bmp
    These are bitmap files required by the standard Help file topics for
    Microsoft Foundation Class Library standard commands.

hlp\*.rtf
    This file contains the standard help topics for standard MFC
    commands and screen objects.

/////////////////////////////////////////////////////////////////////////////
Other standard files:

StdAfx.h, StdAfx.cpp
    These files are used to build a precompiled header (PCH) file
    named glmovie.pch and a precompiled types file named StdAfx.obj.

Resource.h
    This is the standard header file, which defines new resource IDs.
    Microsoft Developer Studio reads and updates this file.

/////////////////////////////////////////////////////////////////////////////
Other notes:

AppWizard uses "TODO:" to indicate parts of the source code you
should add to or customize.

If your application uses MFC in a shared DLL, and your application is 
in a language other than the operating system's current language, you
will need to copy the corresponding localized resources MFC40XXX.DLL
from the Microsoft Visual C++ CD-ROM onto the system or system32 directory,
and rename it to be MFCLOC.DLL.  ("XXX" stands for the language abbreviation.
For example, MFC40DEU.DLL contains resources translated to German.)  If you
don't do this, some of the UI elements of your application will remain in the
language of the operating system.

/////////////////////////////////////////////////////////////////////////////
