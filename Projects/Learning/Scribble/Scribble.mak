# Microsoft Developer Studio Generated NMAKE File, Format Version 40001
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Application" 0x0101

!IF "$(CFG)" == ""
CFG=Scribble - Win32 Debug
!MESSAGE No configuration specified.  Defaulting to Scribble - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "Scribble - Win32 Release" && "$(CFG)" !=\
 "Scribble - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "Scribble.mak" CFG="Scribble - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Scribble - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "Scribble - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 
################################################################################
# Begin Project
CPP=cl.exe
RSC=rc.exe
MTL=mktyplib.exe

!IF  "$(CFG)" == "Scribble - Win32 Release"

# PROP BASE Use_MFC 6
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 6
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Target_Dir ""
OUTDIR=.\Release
INTDIR=.\Release

ALL : "$(OUTDIR)\Scribble.exe"

CLEAN : 
	-@erase ".\Release\Scribble.exe"
	-@erase ".\Release\Scribble.obj"
	-@erase ".\Release\Scribble.pch"
	-@erase ".\Release\StdAfx.obj"
	-@erase ".\Release\MainFrm.obj"
	-@erase ".\Release\ChildFrm.obj"
	-@erase ".\Release\ScribbleDoc.obj"
	-@erase ".\Release\ScribbleView.obj"
	-@erase ".\Release\Scribble.res"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /c
# ADD CPP /nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /c
CPP_PROJ=/nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D\
 "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)/Scribble.pch" /Yu"stdafx.h" /Fo"$(INTDIR)/"\
 /c 
CPP_OBJS=.\Release/
CPP_SBRS=
# ADD BASE MTL /nologo /D "NDEBUG" /win32
# ADD MTL /nologo /D "NDEBUG" /win32
MTL_PROJ=/nologo /D "NDEBUG" /win32 
# ADD BASE RSC /l 0x409 /d "NDEBUG" /d "_AFXDLL"
# ADD RSC /l 0x409 /d "NDEBUG" /d "_AFXDLL"
RSC_PROJ=/l 0x409 /fo"$(INTDIR)/Scribble.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/Scribble.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 /nologo /subsystem:windows /machine:I386
# ADD LINK32 /nologo /subsystem:windows /machine:I386
LINK32_FLAGS=/nologo /subsystem:windows /incremental:no\
 /pdb:"$(OUTDIR)/Scribble.pdb" /machine:I386 /out:"$(OUTDIR)/Scribble.exe" 
LINK32_OBJS= \
	"$(INTDIR)/Scribble.obj" \
	"$(INTDIR)/StdAfx.obj" \
	"$(INTDIR)/MainFrm.obj" \
	"$(INTDIR)/ChildFrm.obj" \
	"$(INTDIR)/ScribbleDoc.obj" \
	"$(INTDIR)/ScribbleView.obj" \
	"$(INTDIR)/Scribble.res"

"$(OUTDIR)\Scribble.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "Scribble - Win32 Debug"

# PROP BASE Use_MFC 6
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 6
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""
OUTDIR=.\Debug
INTDIR=.\Debug

ALL : "$(OUTDIR)\Scribble.exe"

CLEAN : 
	-@erase ".\Debug\Scribble.exe"
	-@erase ".\Debug\Scribble.obj"
	-@erase ".\Debug\Scribble.pch"
	-@erase ".\Debug\StdAfx.obj"
	-@erase ".\Debug\MainFrm.obj"
	-@erase ".\Debug\ChildFrm.obj"
	-@erase ".\Debug\ScribbleDoc.obj"
	-@erase ".\Debug\ScribbleView.obj"
	-@erase ".\Debug\Scribble.res"
	-@erase ".\Debug\Scribble.ilk"
	-@erase ".\Debug\Scribble.pdb"
	-@erase ".\Debug\vc40.pdb"
	-@erase ".\Debug\vc40.idb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /MDd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /c
# ADD CPP /nologo /MDd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /c
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS"\
 /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)/Scribble.pch" /Yu"stdafx.h"\
 /Fo"$(INTDIR)/" /Fd"$(INTDIR)/" /c 
CPP_OBJS=.\Debug/
CPP_SBRS=
# ADD BASE MTL /nologo /D "_DEBUG" /win32
# ADD MTL /nologo /D "_DEBUG" /win32
MTL_PROJ=/nologo /D "_DEBUG" /win32 
# ADD BASE RSC /l 0x409 /d "_DEBUG" /d "_AFXDLL"
# ADD RSC /l 0x409 /d "_DEBUG" /d "_AFXDLL"
RSC_PROJ=/l 0x409 /fo"$(INTDIR)/Scribble.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/Scribble.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 /nologo /subsystem:windows /debug /machine:I386
# ADD LINK32 /nologo /subsystem:windows /debug /machine:I386
LINK32_FLAGS=/nologo /subsystem:windows /incremental:yes\
 /pdb:"$(OUTDIR)/Scribble.pdb" /debug /machine:I386\
 /out:"$(OUTDIR)/Scribble.exe" 
LINK32_OBJS= \
	"$(INTDIR)/Scribble.obj" \
	"$(INTDIR)/StdAfx.obj" \
	"$(INTDIR)/MainFrm.obj" \
	"$(INTDIR)/ChildFrm.obj" \
	"$(INTDIR)/ScribbleDoc.obj" \
	"$(INTDIR)/ScribbleView.obj" \
	"$(INTDIR)/Scribble.res"

"$(OUTDIR)\Scribble.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 

.c{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.cpp{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.cxx{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.c{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  

.cpp{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  

.cxx{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  

################################################################################
# Begin Target

# Name "Scribble - Win32 Release"
# Name "Scribble - Win32 Debug"

!IF  "$(CFG)" == "Scribble - Win32 Release"

!ELSEIF  "$(CFG)" == "Scribble - Win32 Debug"

!ENDIF 

################################################################################
# Begin Source File

SOURCE=.\ReadMe.txt

!IF  "$(CFG)" == "Scribble - Win32 Release"

!ELSEIF  "$(CFG)" == "Scribble - Win32 Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\Scribble.cpp
DEP_CPP_SCRIB=\
	".\StdAfx.h"\
	".\Scribble.h"\
	".\MainFrm.h"\
	".\ChildFrm.h"\
	".\ScribbleDoc.h"\
	".\ScribbleView.h"\
	

"$(INTDIR)\Scribble.obj" : $(SOURCE) $(DEP_CPP_SCRIB) "$(INTDIR)"\
 "$(INTDIR)\Scribble.pch"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\StdAfx.cpp
DEP_CPP_STDAF=\
	".\StdAfx.h"\
	

!IF  "$(CFG)" == "Scribble - Win32 Release"

# ADD CPP /Yc"stdafx.h"

BuildCmds= \
	$(CPP) /nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D\
 "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)/Scribble.pch" /Yc"stdafx.h" /Fo"$(INTDIR)/"\
 /c $(SOURCE) \
	

"$(INTDIR)\StdAfx.obj" : $(SOURCE) $(DEP_CPP_STDAF) "$(INTDIR)"
   $(BuildCmds)

"$(INTDIR)\Scribble.pch" : $(SOURCE) $(DEP_CPP_STDAF) "$(INTDIR)"
   $(BuildCmds)

!ELSEIF  "$(CFG)" == "Scribble - Win32 Debug"

# ADD CPP /Yc"stdafx.h"

BuildCmds= \
	$(CPP) /nologo /MDd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS"\
 /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)/Scribble.pch" /Yc"stdafx.h"\
 /Fo"$(INTDIR)/" /Fd"$(INTDIR)/" /c $(SOURCE) \
	

"$(INTDIR)\StdAfx.obj" : $(SOURCE) $(DEP_CPP_STDAF) "$(INTDIR)"
   $(BuildCmds)

"$(INTDIR)\Scribble.pch" : $(SOURCE) $(DEP_CPP_STDAF) "$(INTDIR)"
   $(BuildCmds)

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\MainFrm.cpp
DEP_CPP_MAINF=\
	".\StdAfx.h"\
	".\Scribble.h"\
	".\MainFrm.h"\
	

"$(INTDIR)\MainFrm.obj" : $(SOURCE) $(DEP_CPP_MAINF) "$(INTDIR)"\
 "$(INTDIR)\Scribble.pch"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\ChildFrm.cpp
DEP_CPP_CHILD=\
	".\StdAfx.h"\
	".\Scribble.h"\
	".\ChildFrm.h"\
	

"$(INTDIR)\ChildFrm.obj" : $(SOURCE) $(DEP_CPP_CHILD) "$(INTDIR)"\
 "$(INTDIR)\Scribble.pch"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\ScribbleDoc.cpp

!IF  "$(CFG)" == "Scribble - Win32 Release"

DEP_CPP_SCRIBB=\
	".\StdAfx.h"\
	".\Scribble.h"\
	".\ScribbleDoc.h"\
	
NODEP_CPP_SCRIBB=\
	".\CScribbleDoc"\
	

"$(INTDIR)\ScribbleDoc.obj" : $(SOURCE) $(DEP_CPP_SCRIBB) "$(INTDIR)"\
 "$(INTDIR)\Scribble.pch"


!ELSEIF  "$(CFG)" == "Scribble - Win32 Debug"

DEP_CPP_SCRIBB=\
	".\StdAfx.h"\
	".\Scribble.h"\
	".\ScribbleDoc.h"\
	

"$(INTDIR)\ScribbleDoc.obj" : $(SOURCE) $(DEP_CPP_SCRIBB) "$(INTDIR)"\
 "$(INTDIR)\Scribble.pch"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\ScribbleView.cpp
DEP_CPP_SCRIBBL=\
	".\StdAfx.h"\
	".\Scribble.h"\
	".\ScribbleDoc.h"\
	".\ScribbleView.h"\
	

"$(INTDIR)\ScribbleView.obj" : $(SOURCE) $(DEP_CPP_SCRIBBL) "$(INTDIR)"\
 "$(INTDIR)\Scribble.pch"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\Scribble.rc
DEP_RSC_SCRIBBLE=\
	".\res\Scribble.ico"\
	".\res\ScribbleDoc.ico"\
	".\res\Toolbar.bmp"\
	".\res\Scribble.rc2"\
	

"$(INTDIR)\Scribble.res" : $(SOURCE) $(DEP_RSC_SCRIBBLE) "$(INTDIR)"
   $(RSC) $(RSC_PROJ) $(SOURCE)


# End Source File
# End Target
# End Project
################################################################################
