# Microsoft Developer Studio Generated NMAKE File, Format Version 40001
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Application" 0x0101

!IF "$(CFG)" == ""
CFG=Simple - Win32 Debug
!MESSAGE No configuration specified.  Defaulting to Simple - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "Simple - Win32 Release" && "$(CFG)" != "Simple - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "Simple.mak" CFG="Simple - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Simple - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "Simple - Win32 Debug" (based on "Win32 (x86) Application")
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
# PROP Target_Last_Scanned "Simple - Win32 Debug"
CPP=cl.exe
RSC=rc.exe
MTL=mktyplib.exe

!IF  "$(CFG)" == "Simple - Win32 Release"

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

ALL : "$(OUTDIR)\Simple.exe"

CLEAN : 
	-@erase ".\Release\Simple.exe"
	-@erase ".\Release\Simple.obj"
	-@erase ".\Release\Simple.pch"
	-@erase ".\Release\StdAfx.obj"
	-@erase ".\Release\MainFrm.obj"
	-@erase ".\Release\SimpleDoc.obj"
	-@erase ".\Release\SimpleView.obj"
	-@erase ".\Release\Simple.res"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /c
# ADD CPP /nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /c
CPP_PROJ=/nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D\
 "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)/Simple.pch" /Yu"stdafx.h" /Fo"$(INTDIR)/" /c\
 
CPP_OBJS=.\Release/
CPP_SBRS=
# ADD BASE MTL /nologo /D "NDEBUG" /win32
# ADD MTL /nologo /D "NDEBUG" /win32
MTL_PROJ=/nologo /D "NDEBUG" /win32 
# ADD BASE RSC /l 0x409 /d "NDEBUG" /d "_AFXDLL"
# ADD RSC /l 0x409 /d "NDEBUG" /d "_AFXDLL"
RSC_PROJ=/l 0x409 /fo"$(INTDIR)/Simple.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo /o"Simple.bsc"
BSC32_FLAGS=/nologo /o"Simple.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 /nologo /subsystem:windows /machine:I386
# ADD LINK32 /nologo /subsystem:windows /machine:I386
LINK32_FLAGS=/nologo /subsystem:windows /incremental:no\
 /pdb:"$(OUTDIR)/Simple.pdb" /machine:I386 /out:"$(OUTDIR)/Simple.exe" 
LINK32_OBJS= \
	"$(INTDIR)/Simple.obj" \
	"$(INTDIR)/StdAfx.obj" \
	"$(INTDIR)/MainFrm.obj" \
	"$(INTDIR)/SimpleDoc.obj" \
	"$(INTDIR)/SimpleView.obj" \
	"$(INTDIR)/Simple.res"

"$(OUTDIR)\Simple.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "Simple - Win32 Debug"

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

ALL : "$(OUTDIR)\Simple.exe" ".\Simple.bsc"

CLEAN : 
	-@erase ".\Debug\Simple.exe"
	-@erase ".\Debug\Simple.obj"
	-@erase ".\Debug\Simple.pch"
	-@erase ".\Debug\StdAfx.obj"
	-@erase ".\Debug\MainFrm.obj"
	-@erase ".\Debug\SimpleDoc.obj"
	-@erase ".\Debug\SimpleView.obj"
	-@erase ".\Debug\Simple.res"
	-@erase ".\Debug\Simple.ilk"
	-@erase ".\Debug\Simple.pdb"
	-@erase ".\Debug\vc40.pdb"
	-@erase ".\Debug\vc40.idb"
	-@erase ".\Simple.bsc"
	-@erase ".\Debug\Simple.sbr"
	-@erase ".\Debug\StdAfx.sbr"
	-@erase ".\Debug\MainFrm.sbr"
	-@erase ".\Debug\SimpleDoc.sbr"
	-@erase ".\Debug\SimpleView.sbr"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /MDd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /c
# ADD CPP /nologo /MDd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR /Yu"stdafx.h" /c
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS"\
 /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)/" /Fp"$(INTDIR)/Simple.pch" /Yu"stdafx.h"\
 /Fo"$(INTDIR)/" /Fd"$(INTDIR)/" /c 
CPP_OBJS=.\Debug/
CPP_SBRS=.\Debug/
# ADD BASE MTL /nologo /D "_DEBUG" /win32
# ADD MTL /nologo /D "_DEBUG" /win32
MTL_PROJ=/nologo /D "_DEBUG" /win32 
# ADD BASE RSC /l 0x409 /d "_DEBUG" /d "_AFXDLL"
# ADD RSC /l 0x409 /d "_DEBUG" /d "_AFXDLL"
RSC_PROJ=/l 0x409 /fo"$(INTDIR)/Simple.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo /o"Simple.bsc"
BSC32_FLAGS=/nologo /o"Simple.bsc" 
BSC32_SBRS= \
	"$(INTDIR)/Simple.sbr" \
	"$(INTDIR)/StdAfx.sbr" \
	"$(INTDIR)/MainFrm.sbr" \
	"$(INTDIR)/SimpleDoc.sbr" \
	"$(INTDIR)/SimpleView.sbr"

".\Simple.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
# ADD BASE LINK32 /nologo /subsystem:windows /debug /machine:I386
# ADD LINK32 /nologo /subsystem:windows /debug /machine:I386
LINK32_FLAGS=/nologo /subsystem:windows /incremental:yes\
 /pdb:"$(OUTDIR)/Simple.pdb" /debug /machine:I386 /out:"$(OUTDIR)/Simple.exe" 
LINK32_OBJS= \
	"$(INTDIR)/Simple.obj" \
	"$(INTDIR)/StdAfx.obj" \
	"$(INTDIR)/MainFrm.obj" \
	"$(INTDIR)/SimpleDoc.obj" \
	"$(INTDIR)/SimpleView.obj" \
	"$(INTDIR)/Simple.res"

"$(OUTDIR)\Simple.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
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

# Name "Simple - Win32 Release"
# Name "Simple - Win32 Debug"

!IF  "$(CFG)" == "Simple - Win32 Release"

!ELSEIF  "$(CFG)" == "Simple - Win32 Debug"

!ENDIF 

################################################################################
# Begin Source File

SOURCE=.\ReadMe.txt

!IF  "$(CFG)" == "Simple - Win32 Release"

!ELSEIF  "$(CFG)" == "Simple - Win32 Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\Simple.cpp
DEP_CPP_SIMPL=\
	".\StdAfx.h"\
	".\Simple.h"\
	".\MainFrm.h"\
	".\SimpleDoc.h"\
	".\SimpleView.h"\
	

!IF  "$(CFG)" == "Simple - Win32 Release"


"$(INTDIR)\Simple.obj" : $(SOURCE) $(DEP_CPP_SIMPL) "$(INTDIR)"\
 "$(INTDIR)\Simple.pch"


!ELSEIF  "$(CFG)" == "Simple - Win32 Debug"


"$(INTDIR)\Simple.obj" : $(SOURCE) $(DEP_CPP_SIMPL) "$(INTDIR)"\
 "$(INTDIR)\Simple.pch"

"$(INTDIR)\Simple.sbr" : $(SOURCE) $(DEP_CPP_SIMPL) "$(INTDIR)"\
 "$(INTDIR)\Simple.pch"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\StdAfx.cpp
DEP_CPP_STDAF=\
	".\StdAfx.h"\
	

!IF  "$(CFG)" == "Simple - Win32 Release"

# ADD CPP /Yc"stdafx.h"

BuildCmds= \
	$(CPP) /nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D\
 "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)/Simple.pch" /Yc"stdafx.h" /Fo"$(INTDIR)/" /c\
 $(SOURCE) \
	

"$(INTDIR)\StdAfx.obj" : $(SOURCE) $(DEP_CPP_STDAF) "$(INTDIR)"
   $(BuildCmds)

"$(INTDIR)\Simple.pch" : $(SOURCE) $(DEP_CPP_STDAF) "$(INTDIR)"
   $(BuildCmds)

!ELSEIF  "$(CFG)" == "Simple - Win32 Debug"

# ADD CPP /Yc"stdafx.h"

BuildCmds= \
	$(CPP) /nologo /MDd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS"\
 /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)/" /Fp"$(INTDIR)/Simple.pch" /Yc"stdafx.h"\
 /Fo"$(INTDIR)/" /Fd"$(INTDIR)/" /c $(SOURCE) \
	

"$(INTDIR)\StdAfx.obj" : $(SOURCE) $(DEP_CPP_STDAF) "$(INTDIR)"
   $(BuildCmds)

"$(INTDIR)\StdAfx.sbr" : $(SOURCE) $(DEP_CPP_STDAF) "$(INTDIR)"
   $(BuildCmds)

"$(INTDIR)\Simple.pch" : $(SOURCE) $(DEP_CPP_STDAF) "$(INTDIR)"
   $(BuildCmds)

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\MainFrm.cpp
DEP_CPP_MAINF=\
	".\StdAfx.h"\
	".\Simple.h"\
	".\MainFrm.h"\
	

!IF  "$(CFG)" == "Simple - Win32 Release"


"$(INTDIR)\MainFrm.obj" : $(SOURCE) $(DEP_CPP_MAINF) "$(INTDIR)"\
 "$(INTDIR)\Simple.pch"


!ELSEIF  "$(CFG)" == "Simple - Win32 Debug"


"$(INTDIR)\MainFrm.obj" : $(SOURCE) $(DEP_CPP_MAINF) "$(INTDIR)"\
 "$(INTDIR)\Simple.pch"

"$(INTDIR)\MainFrm.sbr" : $(SOURCE) $(DEP_CPP_MAINF) "$(INTDIR)"\
 "$(INTDIR)\Simple.pch"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\SimpleDoc.cpp
DEP_CPP_SIMPLE=\
	".\StdAfx.h"\
	".\Simple.h"\
	".\SimpleDoc.h"\
	

!IF  "$(CFG)" == "Simple - Win32 Release"


"$(INTDIR)\SimpleDoc.obj" : $(SOURCE) $(DEP_CPP_SIMPLE) "$(INTDIR)"\
 "$(INTDIR)\Simple.pch"


!ELSEIF  "$(CFG)" == "Simple - Win32 Debug"


"$(INTDIR)\SimpleDoc.obj" : $(SOURCE) $(DEP_CPP_SIMPLE) "$(INTDIR)"\
 "$(INTDIR)\Simple.pch"

"$(INTDIR)\SimpleDoc.sbr" : $(SOURCE) $(DEP_CPP_SIMPLE) "$(INTDIR)"\
 "$(INTDIR)\Simple.pch"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\SimpleView.cpp
DEP_CPP_SIMPLEV=\
	".\StdAfx.h"\
	".\Simple.h"\
	".\SimpleDoc.h"\
	".\SimpleView.h"\
	

!IF  "$(CFG)" == "Simple - Win32 Release"


"$(INTDIR)\SimpleView.obj" : $(SOURCE) $(DEP_CPP_SIMPLEV) "$(INTDIR)"\
 "$(INTDIR)\Simple.pch"


!ELSEIF  "$(CFG)" == "Simple - Win32 Debug"


"$(INTDIR)\SimpleView.obj" : $(SOURCE) $(DEP_CPP_SIMPLEV) "$(INTDIR)"\
 "$(INTDIR)\Simple.pch"

"$(INTDIR)\SimpleView.sbr" : $(SOURCE) $(DEP_CPP_SIMPLEV) "$(INTDIR)"\
 "$(INTDIR)\Simple.pch"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\Simple.rc
DEP_RSC_SIMPLE_=\
	".\res\Simple.ico"\
	".\res\SimpleDoc.ico"\
	".\res\Toolbar.bmp"\
	".\res\Simple.rc2"\
	

"$(INTDIR)\Simple.res" : $(SOURCE) $(DEP_RSC_SIMPLE_) "$(INTDIR)"
   $(RSC) $(RSC_PROJ) $(SOURCE)


# End Source File
# End Target
# End Project
################################################################################
