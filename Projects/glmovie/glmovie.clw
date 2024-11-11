; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=DlgControl
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "glmovie.h"
LastPage=0

ClassCount=8
Class1=CGlmovieApp
Class2=CGlmovieDoc
Class3=CGlmovieView
Class4=CMainFrame

ResourceCount=6
Resource1=IDD_GETARRAYSIZE
Resource2=IDD_ABOUTBOX
Class5=CAboutDlg
Class6=DlgControl
Resource3=IDR_MAINFRAME
Resource4=IDD_DIALOG1
Class7=MatVarDir
Resource5=IDD_MATFILEDIR
Class8=DlgGetArraySize
Resource6=IDD_DLGCONTROL

[CLS:CGlmovieApp]
Type=0
HeaderFile=glmovie.h
ImplementationFile=glmovie.cpp
Filter=N

[CLS:CGlmovieDoc]
Type=0
HeaderFile=glmovieDoc.h
ImplementationFile=glmovieDoc.cpp
Filter=N
LastObject=CGlmovieDoc

[CLS:CGlmovieView]
Type=0
HeaderFile=glmovieView.h
ImplementationFile=glmovieView.cpp
Filter=C
BaseClass=CView
VirtualFilter=VWC
LastObject=CGlmovieView

[CLS:CMainFrame]
Type=0
HeaderFile=MainFrm.h
ImplementationFile=MainFrm.cpp
Filter=T
LastObject=CMainFrame
BaseClass=CFrameWnd
VirtualFilter=fWC



[CLS:CAboutDlg]
Type=0
HeaderFile=glmovie.cpp
ImplementationFile=glmovie.cpp
Filter=D
BaseClass=CDialog
VirtualFilter=dWC
LastObject=CAboutDlg

[DLG:IDD_ABOUTBOX]
Type=1
Class=CAboutDlg
ControlCount=18
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889
Control5=IDC_STATIC,static,1342308352
Control6=IDC_STATIC,button,1342177287
Control7=IDC_STATIC,static,1342308352
Control8=IDC_STATIC,static,1342308352
Control9=IDC_STATIC,static,1342308352
Control10=IDC_STATIC,button,1342177287
Control11=IDC_VENDORSTR,static,1342308352
Control12=IDC_RENDERSTR,static,1342308352
Control13=IDC_VERSIONSTR,static,1342308352
Control14=IDC_EXTENSIONSTR,static,1342308352
Control15=IDC_GLUEXTENSIONS,static,1342308352
Control16=IDC_GLUVERSION,static,1342308352
Control17=IDC_STATIC,static,1342308352
Control18=IDC_STATIC,static,1342308352

[MNU:IDR_MAINFRAME]
Type=1
Class=CMainFrame
Command1=ID_FILE_NEW
Command2=ID_FILE_OPEN
Command3=ID_FILE_SAVE
Command4=ID_FILE_SAVE_AS
Command5=ID_FILE_PRINT
Command6=ID_FILE_PRINT_PREVIEW
Command7=ID_FILE_PRINT_SETUP
Command8=ID_FILE_MRU_FILE1
Command9=ID_APP_EXIT
Command10=ID_EDIT_UNDO
Command11=ID_EDIT_CUT
Command12=ID_EDIT_COPY
Command13=ID_EDIT_PASTE
Command14=ID_VIEW_TOOLBAR
Command15=ID_VIEW_STATUS_BAR
Command16=ID_HELP_FINDER
Command17=ID_APP_ABOUT
CommandCount=17

[ACL:IDR_MAINFRAME]
Type=1
Class=CMainFrame
Command1=ID_FILE_NEW
Command2=ID_FILE_OPEN
Command3=ID_FILE_SAVE
Command4=ID_FILE_PRINT
Command5=ID_EDIT_UNDO
Command6=ID_EDIT_CUT
Command7=ID_EDIT_COPY
Command8=ID_EDIT_PASTE
Command9=ID_EDIT_UNDO
Command10=ID_EDIT_CUT
Command11=ID_EDIT_COPY
Command12=ID_EDIT_PASTE
Command13=ID_NEXT_PANE
Command14=ID_PREV_PANE
Command15=ID_CONTEXT_HELP
Command16=ID_HELP
CommandCount=16

[TB:IDR_MAINFRAME]
Type=1
Class=?
Command1=ID_FILE_NEW
Command2=ID_FILE_OPEN
Command3=ID_FILE_SAVE
Command4=ID_EDIT_CUT
Command5=ID_EDIT_COPY
Command6=ID_EDIT_PASTE
Command7=ID_FILE_PRINT
Command8=ID_APP_ABOUT
Command9=ID_CONTEXT_HELP
CommandCount=9

[CLS:DlgControl]
Type=0
HeaderFile=DlgControl.h
ImplementationFile=DlgControl.cpp
BaseClass=CDialog
Filter=D
LastObject=DlgControl
VirtualFilter=dWC

[DLG:IDD_DLGCONTROL]
Type=1
Class=DlgControl
ControlCount=32
Control1=IDC_FRAMERATE,edit,1350631552
Control2=IDC_STEPSIZE,edit,1350631552
Control3=IDC_COLORMIN,edit,1350631552
Control4=IDC_COLORMAX,edit,1350631552
Control5=IDC_PLOTSTYLE,button,1342242823
Control6=IDC_COLORMAP,button,1342324745
Control7=IDC_MESH,button,1476411401
Control8=IDC_SURFACE,button,1476411401
Control9=IDC_ARROWS,button,1342193673
Control10=IDC_NFRAMES,static,1342308352
Control11=IDC_MINMAG,static,1342308352
Control12=IDC_MAXMAG,static,1342308352
Control13=IDC_APPLY,button,1342373888
Control14=IDC_REVERSE,button,1342242816
Control15=IDC_BKWDSTEP,button,1342242816
Control16=IDC_RESET,button,1342242816
Control17=IDC_STOP,button,1342242816
Control18=IDC_SINGLESTEP,button,1342242817
Control19=IDC_PLAY,button,1342242816
Control20=IDC_STFR,static,1342308352
Control21=IDC_STATIC,static,1342308352
Control22=IDC_STATIC,static,1342308352
Control23=IDC_STFR2,static,1342308352
Control24=IDC_CURRFRAME,static,1342308352
Control25=IDC_COLORMAPPING,button,1342242823
Control26=IDC_BGYOR,button,1342308361
Control27=IDC_GREYSCALE,button,1342177289
Control28=IDC_GRID,button,1342242819
Control29=IDC_COLORBAR,button,1342242819
Control30=IDC_COORDS,button,1342242823
Control31=IDC_ORTHO,button,1342308361
Control32=IDC_FILL,button,1342177289

[DLG:IDD_DIALOG1]
Type=1
ControlCount=2
Control1=IDOK,button,1342242817
Control2=IDCANCEL,button,1342242816

[DLG:IDD_MATFILEDIR]
Type=1
Class=MatVarDir
ControlCount=7
Control1=IDOK,button,1342242817
Control2=IDCANCEL,button,1342242816
Control3=IDC_MATVARLIST,listbox,1352728963
Control4=IDC_STATIC,static,1342308352
Control5=IDC_STATIC,static,1342308352
Control6=IDC_STATIC,static,1342308352
Control7=IDC_STATIC,static,1342308352

[CLS:MatVarDir]
Type=0
HeaderFile=MatVarDir.h
ImplementationFile=MatVarDir.cpp
BaseClass=CDialog
Filter=D
LastObject=IDC_MATVARLIST
VirtualFilter=dWC

[DLG:IDD_GETARRAYSIZE]
Type=1
Class=DlgGetArraySize
ControlCount=8
Control1=IDC_NROWS,edit,1350631552
Control2=IDC_NCOLS,edit,1350631552
Control3=IDOK,button,1342242817
Control4=IDCANCEL,button,1342242816
Control5=IDC_NELEMS,static,1342308352
Control6=IDC_STATIC,static,1342308352
Control7=IDC_STATIC,static,1342308352
Control8=IDC_STATIC,static,1342308352

[CLS:DlgGetArraySize]
Type=0
HeaderFile=DlgGetArraySize.h
ImplementationFile=DlgGetArraySize.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC
LastObject=DlgGetArraySize

