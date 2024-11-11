# Microsoft Developer Studio Generated NMAKE File, Format Version 40001
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Application" 0x0101

!IF "$(CFG)" == ""
CFG=DiffEq1D - Win32 Debug
!MESSAGE No configuration specified.  Defaulting to DiffEq1D - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "DiffEq1D - Win32 Release" && "$(CFG)" !=\
 "DiffEq1D - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "DiffEq1D.mak" CFG="DiffEq1D - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "DiffEq1D - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "DiffEq1D - Win32 Debug" (based on "Win32 (x86) Application")
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
# PROP Target_Last_Scanned "DiffEq1D - Win32 Debug"
CPP=cl.exe
RSC=rc.exe
MTL=mktyplib.exe

!IF  "$(CFG)" == "DiffEq1D - Win32 Release"

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

ALL : "$(OUTDIR)\DiffEq1D.exe"

CLEAN : 
	-@erase ".\Release\DiffEq1D.exe"
	-@erase ".\Release\DiffEq1D.obj"
	-@erase ".\Release\DiffEq1D.pch"
	-@erase ".\Release\DiffEq1DView.obj"
	-@erase ".\Release\MainFrm.obj"
	-@erase ".\Release\DiffEq1DDoc.obj"
	-@erase ".\Release\StdAfx.obj"
	-@erase ".\Release\DiffEq1D.res"
	-@erase ".\Release\GLPlot.obj"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /c
# ADD CPP /nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /c
CPP_PROJ=/nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D\
 "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)/DiffEq1D.pch" /Yu"stdafx.h" /Fo"$(INTDIR)/"\
 /c 
CPP_OBJS=.\Release/
CPP_SBRS=
# ADD BASE MTL /nologo /D "NDEBUG" /win32
# ADD MTL /nologo /D "NDEBUG" /win32
MTL_PROJ=/nologo /D "NDEBUG" /win32 
# ADD BASE RSC /l 0x409 /d "NDEBUG" /d "_AFXDLL"
# ADD RSC /l 0x409 /d "NDEBUG" /d "_AFXDLL"
RSC_PROJ=/l 0x409 /fo"$(INTDIR)/DiffEq1D.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/DiffEq1D.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 /nologo /subsystem:windows /machine:I386
# ADD LINK32 opengl32.lib glu32.lib /nologo /subsystem:windows /machine:I386
LINK32_FLAGS=opengl32.lib glu32.lib /nologo /subsystem:windows /incremental:no\
 /pdb:"$(OUTDIR)/DiffEq1D.pdb" /machine:I386 /out:"$(OUTDIR)/DiffEq1D.exe" 
LINK32_OBJS= \
	"$(INTDIR)/DiffEq1D.obj" \
	"$(INTDIR)/DiffEq1DView.obj" \
	"$(INTDIR)/MainFrm.obj" \
	"$(INTDIR)/DiffEq1DDoc.obj" \
	"$(INTDIR)/StdAfx.obj" \
	"$(INTDIR)/GLPlot.obj" \
	"$(INTDIR)/DiffEq1D.res"

"$(OUTDIR)\DiffEq1D.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "DiffEq1D - Win32 Debug"

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

ALL : "$(OUTDIR)\DiffEq1D.exe"

CLEAN : 
	-@erase ".\Debug\vc40.pdb"
	-@erase ".\Debug\DiffEq1D.pch"
	-@erase ".\Debug\vc40.idb"
	-@erase ".\Debug\DiffEq1D.exe"
	-@erase ".\Debug\StdAfx.obj"
	-@erase ".\Debug\DiffEq1DView.obj"
	-@erase ".\Debug\DiffEq1DDoc.obj"
	-@erase ".\Debug\DiffEq1D.obj"
	-@erase ".\Debug\MainFrm.obj"
	-@erase ".\Debug\DiffEq1D.res"
	-@erase ".\Debug\GLPlot.obj"
	-@erase ".\Debug\DiffEq1D.ilk"
	-@erase ".\Debug\DiffEq1D.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /MDd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /c
# ADD CPP /nologo /MDd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /c
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS"\
 /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)/DiffEq1D.pch" /Yu"stdafx.h"\
 /Fo"$(INTDIR)/" /Fd"$(INTDIR)/" /c 
CPP_OBJS=.\Debug/
CPP_SBRS=
# ADD BASE MTL /nologo /D "_DEBUG" /win32
# ADD MTL /nologo /D "_DEBUG" /win32
MTL_PROJ=/nologo /D "_DEBUG" /win32 
# ADD BASE RSC /l 0x409 /d "_DEBUG" /d "_AFXDLL"
# ADD RSC /l 0x409 /d "_DEBUG" /d "_AFXDLL"
RSC_PROJ=/l 0x409 /fo"$(INTDIR)/DiffEq1D.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/DiffEq1D.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 /nologo /subsystem:windows /debug /machine:I386
# ADD LINK32 opengl32.lib glu32.lib /nologo /subsystem:windows /debug /machine:I386
LINK32_FLAGS=opengl32.lib glu32.lib /nologo /subsystem:windows /incremental:yes\
 /pdb:"$(OUTDIR)/DiffEq1D.pdb" /debug /machine:I386\
 /out:"$(OUTDIR)/DiffEq1D.exe" 
LINK32_OBJS= \
	"$(INTDIR)/StdAfx.obj" \
	"$(INTDIR)/DiffEq1DView.obj" \
	"$(INTDIR)/DiffEq1DDoc.obj" \
	"$(INTDIR)/DiffEq1D.obj" \
	"$(INTDIR)/MainFrm.obj" \
	"$(INTDIR)/GLPlot.obj" \
	"$(INTDIR)/DiffEq1D.res"

"$(OUTDIR)\DiffEq1D.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
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

# Name "DiffEq1D - Win32 Release"
# Name "DiffEq1D - Win32 Debug"

!IF  "$(CFG)" == "DiffEq1D - Win32 Release"

!ELSEIF  "$(CFG)" == "DiffEq1D - Win32 Debug"

!ENDIF 

################################################################################
# Begin Source File

SOURCE=.\ReadMe.txt

!IF  "$(CFG)" == "DiffEq1D - Win32 Release"

!ELSEIF  "$(CFG)" == "DiffEq1D - Win32 Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\DiffEq1D.cpp
DEP_CPP_DIFFE=\
	".\StdAfx.h"\
	".\DiffEq1D.h"\
	".\MainFrm.h"\
	".\DiffEq1DDoc.h"\
	".\DiffEq1DView.h"\
	

"$(INTDIR)\DiffEq1D.obj" : $(SOURCE) $(DEP_CPP_DIFFE) "$(INTDIR)"\
 "$(INTDIR)\DiffEq1D.pch"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\StdAfx.cpp
DEP_CPP_STDAF=\
	".\StdAfx.h"\
	

!IF  "$(CFG)" == "DiffEq1D - Win32 Release"

# ADD CPP /Yc"stdafx.h"

BuildCmds= \
	$(CPP) /nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D\
 "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)/DiffEq1D.pch" /Yc"stdafx.h" /Fo"$(INTDIR)/"\
 /c $(SOURCE) \
	

"$(INTDIR)\StdAfx.obj" : $(SOURCE) $(DEP_CPP_STDAF) "$(INTDIR)"
   $(BuildCmds)

"$(INTDIR)\DiffEq1D.pch" : $(SOURCE) $(DEP_CPP_STDAF) "$(INTDIR)"
   $(BuildCmds)

!ELSEIF  "$(CFG)" == "DiffEq1D - Win32 Debug"

# ADD CPP /Yc"stdafx.h"

BuildCmds= \
	$(CPP) /nologo /MDd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS"\
 /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)/DiffEq1D.pch" /Yc"stdafx.h"\
 /Fo"$(INTDIR)/" /Fd"$(INTDIR)/" /c $(SOURCE) \
	

"$(INTDIR)\StdAfx.obj" : $(SOURCE) $(DEP_CPP_STDAF) "$(INTDIR)"
   $(BuildCmds)

"$(INTDIR)\DiffEq1D.pch" : $(SOURCE) $(DEP_CPP_STDAF) "$(INTDIR)"
   $(BuildCmds)

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\MainFrm.cpp
DEP_CPP_MAINF=\
	".\StdAfx.h"\
	".\DiffEq1D.h"\
	".\MainFrm.h"\
	

"$(INTDIR)\MainFrm.obj" : $(SOURCE) $(DEP_CPP_MAINF) "$(INTDIR)"\
 "$(INTDIR)\DiffEq1D.pch"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\DiffEq1DDoc.cpp
DEP_CPP_DIFFEQ=\
	".\StdAfx.h"\
	".\DiffEq1D.h"\
	".\DiffEq1DDoc.h"\
	

"$(INTDIR)\DiffEq1DDoc.obj" : $(SOURCE) $(DEP_CPP_DIFFEQ) "$(INTDIR)"\
 "$(INTDIR)\DiffEq1D.pch"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\DiffEq1DView.cpp
DEP_CPP_DIFFEQ1=\
	".\StdAfx.h"\
	".\DiffEq1D.h"\
	".\DiffEq1DDoc.h"\
	".\DiffEq1DView.h"\
	

"$(INTDIR)\DiffEq1DView.obj" : $(SOURCE) $(DEP_CPP_DIFFEQ1) "$(INTDIR)"\
 "$(INTDIR)\DiffEq1D.pch"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\DiffEq1D.rc
DEP_RSC_DIFFEQ1D=\
	".\res\DiffEq1D.ico"\
	".\res\DiffEq1DDoc.ico"\
	".\res\DiffEq1D.rc2"\
	

"$(INTDIR)\DiffEq1D.res" : $(SOURCE) $(DEP_RSC_DIFFEQ1D) "$(INTDIR)"
   $(RSC) $(RSC_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=.\GLPlot.cpp
DEP_CPP_GLPLO=\
	".\StdAfx.h"\
	".\GLPlot.h"\
	

"$(INTDIR)\GLPlot.obj" : $(SOURCE) $(DEP_CPP_GLPLO) "$(INTDIR)"\
 "$(INTDIR)\DiffEq1D.pch"


# End Source File
# End Target
# End Project
################################################################################
################################################################################
# Section DiffEq1D : {FA93AA50-68E9-11D1-B059-00006E247F28}
# 	1:17:CG_IDS_DISK_SPACE:103
# 	1:19:CG_IDS_PHYSICAL_MEM:102
# 	1:25:CG_IDS_DISK_SPACE_UNAVAIL:104
# 	2:10:SysInfoKey:1234
# End Section
################################################################################
