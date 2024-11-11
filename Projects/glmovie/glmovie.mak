# Microsoft Developer Studio Generated NMAKE File, Format Version 40001
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Application" 0x0101

!IF "$(CFG)" == ""
CFG=glmovie - Win32 Debug
!MESSAGE No configuration specified.  Defaulting to glmovie - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "glmovie - Win32 Release" && "$(CFG)" !=\
 "glmovie - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "glmovie.mak" CFG="glmovie - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "glmovie - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "glmovie - Win32 Debug" (based on "Win32 (x86) Application")
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
# PROP Target_Last_Scanned "glmovie - Win32 Debug"
CPP=cl.exe
RSC=rc.exe
MTL=mktyplib.exe

!IF  "$(CFG)" == "glmovie - Win32 Release"

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

ALL : "$(OUTDIR)\glmovie.exe" "$(OUTDIR)\glmovie.hlp"

CLEAN : 
	-@erase ".\Release\glmovie.exe"
	-@erase ".\Release\DlgControl.obj"
	-@erase ".\Release\glmovie.pch"
	-@erase ".\Release\DlgGetArraySize.obj"
	-@erase ".\Release\glmovieDoc.obj"
	-@erase ".\Release\glmovie.obj"
	-@erase ".\Release\StdAfx.obj"
	-@erase ".\Release\MatVarDir.obj"
	-@erase ".\Release\MainFrm.obj"
	-@erase ".\Release\glmovieView.obj"
	-@erase ".\Release\glmovie.res"
	-@erase ".\Release\GLSeq2D.obj"
	-@erase ".\Release\glmovie.hlp"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /c
# ADD CPP /nologo /G5 /MD /W3 /GX /O2 /Ob2 /I "c:\Program Files\matlab5\extern\include" /I "C:\Program Files\Matlab5\extern\include" /D "NDEBUG" /D "WIN32" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /D "NO_BUILT_IN_SUPPORT_FOR_BOOL" /Yu"stdafx.h" /c
CPP_PROJ=/nologo /G5 /MD /W3 /GX /O2 /Ob2 /I\
 "c:\Program Files\matlab5\extern\include" /I\
 "C:\Program Files\Matlab5\extern\include" /D "NDEBUG" /D "WIN32" /D "_WINDOWS"\
 /D "_AFXDLL" /D "_MBCS" /D "NO_BUILT_IN_SUPPORT_FOR_BOOL"\
 /Fp"$(INTDIR)/glmovie.pch" /Yu"stdafx.h" /Fo"$(INTDIR)/" /c 
CPP_OBJS=.\Release/
CPP_SBRS=
# ADD BASE MTL /nologo /D "NDEBUG" /win32
# ADD MTL /nologo /D "NDEBUG" /win32
MTL_PROJ=/nologo /D "NDEBUG" /win32 
# ADD BASE RSC /l 0x409 /d "NDEBUG" /d "_AFXDLL"
# ADD RSC /l 0x409 /d "NDEBUG" /d "_AFXDLL"
RSC_PROJ=/l 0x409 /fo"$(INTDIR)/glmovie.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/glmovie.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 /nologo /subsystem:windows /machine:I386
# ADD LINK32 opengl32.lib glu32.lib "C:\Program Files\matlab5\extern\lib\libmat.lib" "C:\Program Files\matlab5\extern\lib\libmx.lib" /nologo /subsystem:windows /machine:I386
LINK32_FLAGS=opengl32.lib glu32.lib\
 "C:\Program Files\matlab5\extern\lib\libmat.lib"\
 "C:\Program Files\matlab5\extern\lib\libmx.lib" /nologo /subsystem:windows\
 /incremental:no /pdb:"$(OUTDIR)/glmovie.pdb" /machine:I386\
 /out:"$(OUTDIR)/glmovie.exe" 
LINK32_OBJS= \
	"$(INTDIR)/DlgControl.obj" \
	"$(INTDIR)/DlgGetArraySize.obj" \
	"$(INTDIR)/glmovieDoc.obj" \
	"$(INTDIR)/glmovie.obj" \
	"$(INTDIR)/StdAfx.obj" \
	"$(INTDIR)/MatVarDir.obj" \
	"$(INTDIR)/MainFrm.obj" \
	"$(INTDIR)/glmovieView.obj" \
	"$(INTDIR)/GLSeq2D.obj" \
	"$(INTDIR)/glmovie.res"

"$(OUTDIR)\glmovie.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "glmovie - Win32 Debug"

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

ALL : "$(OUTDIR)\glmovie.exe" "$(OUTDIR)\glmovie.bsc" "$(OUTDIR)\glmovie.hlp"

CLEAN : 
	-@erase ".\Debug\vc40.pdb"
	-@erase ".\Debug\glmovie.pch"
	-@erase ".\Debug\vc40.idb"
	-@erase ".\Debug\glmovie.bsc"
	-@erase ".\Debug\DlgGetArraySize.sbr"
	-@erase ".\Debug\DlgControl.sbr"
	-@erase ".\Debug\glmovieDoc.sbr"
	-@erase ".\Debug\MainFrm.sbr"
	-@erase ".\Debug\MatVarDir.sbr"
	-@erase ".\Debug\StdAfx.sbr"
	-@erase ".\Debug\glmovie.sbr"
	-@erase ".\Debug\glmovieView.sbr"
	-@erase ".\Debug\GLSeq2D.sbr"
	-@erase ".\Debug\glmovie.exe"
	-@erase ".\Debug\glmovieView.obj"
	-@erase ".\Debug\DlgGetArraySize.obj"
	-@erase ".\Debug\DlgControl.obj"
	-@erase ".\Debug\glmovieDoc.obj"
	-@erase ".\Debug\MainFrm.obj"
	-@erase ".\Debug\MatVarDir.obj"
	-@erase ".\Debug\StdAfx.obj"
	-@erase ".\Debug\glmovie.obj"
	-@erase ".\Debug\glmovie.res"
	-@erase ".\Debug\GLSeq2D.obj"
	-@erase ".\Debug\glmovie.ilk"
	-@erase ".\Debug\glmovie.pdb"
	-@erase ".\Debug\glmovie.hlp"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /MDd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /c
# ADD CPP /nologo /G5 /MDd /W3 /Gm /GX /Zi /Od /I "C:\Program Files\Matlab5\extern\include" /D "_DEBUG" /D "WIN32" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /D "NO_BUILT_IN_SUPPORT_FOR_BOOL" /FR /Yu"stdafx.h" /c
CPP_PROJ=/nologo /G5 /MDd /W3 /Gm /GX /Zi /Od /I\
 "C:\Program Files\Matlab5\extern\include" /D "_DEBUG" /D "WIN32" /D "_WINDOWS"\
 /D "_AFXDLL" /D "_MBCS" /D "NO_BUILT_IN_SUPPORT_FOR_BOOL" /FR"$(INTDIR)/"\
 /Fp"$(INTDIR)/glmovie.pch" /Yu"stdafx.h" /Fo"$(INTDIR)/" /Fd"$(INTDIR)/" /c 
CPP_OBJS=.\Debug/
CPP_SBRS=.\Debug/
# ADD BASE MTL /nologo /D "_DEBUG" /win32
# ADD MTL /nologo /D "_DEBUG" /win32
MTL_PROJ=/nologo /D "_DEBUG" /win32 
# ADD BASE RSC /l 0x409 /d "_DEBUG" /d "_AFXDLL"
# ADD RSC /l 0x409 /d "_DEBUG" /d "_AFXDLL"
RSC_PROJ=/l 0x409 /fo"$(INTDIR)/glmovie.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/glmovie.bsc" 
BSC32_SBRS= \
	"$(INTDIR)/DlgGetArraySize.sbr" \
	"$(INTDIR)/DlgControl.sbr" \
	"$(INTDIR)/glmovieDoc.sbr" \
	"$(INTDIR)/MainFrm.sbr" \
	"$(INTDIR)/MatVarDir.sbr" \
	"$(INTDIR)/StdAfx.sbr" \
	"$(INTDIR)/glmovie.sbr" \
	"$(INTDIR)/glmovieView.sbr" \
	"$(INTDIR)/GLSeq2D.sbr"

"$(OUTDIR)\glmovie.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
# ADD BASE LINK32 /nologo /subsystem:windows /debug /machine:I386
# ADD LINK32 opengl32.lib glu32.lib "C:\Program Files\matlab5\extern\lib\libmat.lib" "C:\Program Files\matlab5\extern\lib\libmx.lib" /nologo /subsystem:windows /debug /machine:I386
LINK32_FLAGS=opengl32.lib glu32.lib\
 "C:\Program Files\matlab5\extern\lib\libmat.lib"\
 "C:\Program Files\matlab5\extern\lib\libmx.lib" /nologo /subsystem:windows\
 /incremental:yes /pdb:"$(OUTDIR)/glmovie.pdb" /debug /machine:I386\
 /out:"$(OUTDIR)/glmovie.exe" 
LINK32_OBJS= \
	"$(INTDIR)/glmovieView.obj" \
	"$(INTDIR)/DlgGetArraySize.obj" \
	"$(INTDIR)/DlgControl.obj" \
	"$(INTDIR)/glmovieDoc.obj" \
	"$(INTDIR)/MainFrm.obj" \
	"$(INTDIR)/MatVarDir.obj" \
	"$(INTDIR)/StdAfx.obj" \
	"$(INTDIR)/glmovie.obj" \
	"$(INTDIR)/GLSeq2D.obj" \
	"$(INTDIR)/glmovie.res"

"$(OUTDIR)\glmovie.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
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

# Name "glmovie - Win32 Release"
# Name "glmovie - Win32 Debug"

!IF  "$(CFG)" == "glmovie - Win32 Release"

!ELSEIF  "$(CFG)" == "glmovie - Win32 Debug"

!ENDIF 

################################################################################
# Begin Source File

SOURCE=.\ReadMe.txt

!IF  "$(CFG)" == "glmovie - Win32 Release"

!ELSEIF  "$(CFG)" == "glmovie - Win32 Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\glmovie.cpp
DEP_CPP_GLMOV=\
	".\StdAfx.h"\
	".\glmovie.h"\
	".\MainFrm.h"\
	".\glmovieDoc.h"\
	".\glmovieView.h"\
	".\GLSeq2D.h"\
	".\DlgControl.h"\
	

!IF  "$(CFG)" == "glmovie - Win32 Release"


"$(INTDIR)\glmovie.obj" : $(SOURCE) $(DEP_CPP_GLMOV) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"


!ELSEIF  "$(CFG)" == "glmovie - Win32 Debug"


"$(INTDIR)\glmovie.obj" : $(SOURCE) $(DEP_CPP_GLMOV) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"

"$(INTDIR)\glmovie.sbr" : $(SOURCE) $(DEP_CPP_GLMOV) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\StdAfx.cpp
DEP_CPP_STDAF=\
	".\StdAfx.h"\
	

!IF  "$(CFG)" == "glmovie - Win32 Release"

# ADD CPP /Yc"stdafx.h"

BuildCmds= \
	$(CPP) /nologo /G5 /MD /W3 /GX /O2 /Ob2 /I\
 "c:\Program Files\matlab5\extern\include" /I\
 "C:\Program Files\Matlab5\extern\include" /D "NDEBUG" /D "WIN32" /D "_WINDOWS"\
 /D "_AFXDLL" /D "_MBCS" /D "NO_BUILT_IN_SUPPORT_FOR_BOOL"\
 /Fp"$(INTDIR)/glmovie.pch" /Yc"stdafx.h" /Fo"$(INTDIR)/" /c $(SOURCE) \
	

"$(INTDIR)\StdAfx.obj" : $(SOURCE) $(DEP_CPP_STDAF) "$(INTDIR)"
   $(BuildCmds)

"$(INTDIR)\glmovie.pch" : $(SOURCE) $(DEP_CPP_STDAF) "$(INTDIR)"
   $(BuildCmds)

!ELSEIF  "$(CFG)" == "glmovie - Win32 Debug"

# ADD CPP /Yc"stdafx.h"

BuildCmds= \
	$(CPP) /nologo /G5 /MDd /W3 /Gm /GX /Zi /Od /I\
 "C:\Program Files\Matlab5\extern\include" /D "_DEBUG" /D "WIN32" /D "_WINDOWS"\
 /D "_AFXDLL" /D "_MBCS" /D "NO_BUILT_IN_SUPPORT_FOR_BOOL" /FR"$(INTDIR)/"\
 /Fp"$(INTDIR)/glmovie.pch" /Yc"stdafx.h" /Fo"$(INTDIR)/" /Fd"$(INTDIR)/" /c\
 $(SOURCE) \
	

"$(INTDIR)\StdAfx.obj" : $(SOURCE) $(DEP_CPP_STDAF) "$(INTDIR)"
   $(BuildCmds)

"$(INTDIR)\StdAfx.sbr" : $(SOURCE) $(DEP_CPP_STDAF) "$(INTDIR)"
   $(BuildCmds)

"$(INTDIR)\glmovie.pch" : $(SOURCE) $(DEP_CPP_STDAF) "$(INTDIR)"
   $(BuildCmds)

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\MainFrm.cpp
DEP_CPP_MAINF=\
	".\StdAfx.h"\
	".\glmovie.h"\
	".\MainFrm.h"\
	".\glmovieDoc.h"\
	".\glmovieView.h"\
	".\DlgControl.h"\
	

!IF  "$(CFG)" == "glmovie - Win32 Release"


"$(INTDIR)\MainFrm.obj" : $(SOURCE) $(DEP_CPP_MAINF) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"


!ELSEIF  "$(CFG)" == "glmovie - Win32 Debug"


"$(INTDIR)\MainFrm.obj" : $(SOURCE) $(DEP_CPP_MAINF) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"

"$(INTDIR)\MainFrm.sbr" : $(SOURCE) $(DEP_CPP_MAINF) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\glmovieDoc.cpp
DEP_CPP_GLMOVI=\
	".\StdAfx.h"\
	".\glmovie.h"\
	".\glmovieDoc.h"\
	".\MatVarDir.h"\
	".\DlgGetArraySize.h"\
	".\DlgControl.h"\
	".\GLSeq2D.h"\
	"c:\Program Files\matlab5\extern\include\mat.h"\
	".\..\..\..\Program Files\matlab5\extern\include\matrix.h"\
	".\..\..\..\Program Files\matlab5\extern\include\mwdebug.h"\
	".\..\..\..\Program Files\matlab5\extern\include\tmwtypes.h"\
	

!IF  "$(CFG)" == "glmovie - Win32 Release"


"$(INTDIR)\glmovieDoc.obj" : $(SOURCE) $(DEP_CPP_GLMOVI) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"


!ELSEIF  "$(CFG)" == "glmovie - Win32 Debug"


"$(INTDIR)\glmovieDoc.obj" : $(SOURCE) $(DEP_CPP_GLMOVI) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"

"$(INTDIR)\glmovieDoc.sbr" : $(SOURCE) $(DEP_CPP_GLMOVI) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\glmovieView.cpp
DEP_CPP_GLMOVIE=\
	".\StdAfx.h"\
	".\glmovie.h"\
	".\glmovieDoc.h"\
	".\glmovieView.h"\
	".\GLSeq2D.h"\
	

!IF  "$(CFG)" == "glmovie - Win32 Release"


"$(INTDIR)\glmovieView.obj" : $(SOURCE) $(DEP_CPP_GLMOVIE) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"


!ELSEIF  "$(CFG)" == "glmovie - Win32 Debug"


"$(INTDIR)\glmovieView.obj" : $(SOURCE) $(DEP_CPP_GLMOVIE) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"

"$(INTDIR)\glmovieView.sbr" : $(SOURCE) $(DEP_CPP_GLMOVIE) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\glmovie.rc
DEP_RSC_GLMOVIE_=\
	".\res\glmovie.ico"\
	".\res\glmovieDoc.ico"\
	".\res\Toolbar.bmp"\
	".\res\glmovie.rc2"\
	

"$(INTDIR)\glmovie.res" : $(SOURCE) $(DEP_RSC_GLMOVIE_) "$(INTDIR)"
   $(RSC) $(RSC_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=.\hlp\glmovie.hpj

!IF  "$(CFG)" == "glmovie - Win32 Release"

# Begin Custom Build - Making help file...
OutDir=.\Release
ProjDir=.
TargetName=glmovie
InputPath=.\hlp\glmovie.hpj

"$(OutDir)\$(TargetName).hlp" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
   "$(ProjDir)\makehelp.bat"

# End Custom Build

!ELSEIF  "$(CFG)" == "glmovie - Win32 Debug"

# Begin Custom Build - Making help file...
OutDir=.\Debug
ProjDir=.
TargetName=glmovie
InputPath=.\hlp\glmovie.hpj

"$(OutDir)\$(TargetName).hlp" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
   "$(ProjDir)\makehelp.bat"

# End Custom Build

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\DlgControl.cpp
DEP_CPP_DLGCO=\
	".\StdAfx.h"\
	".\glmovie.h"\
	".\glmovieDoc.h"\
	".\glmovieView.h"\
	".\DlgControl.h"\
	".\GLSeq2D.h"\
	

!IF  "$(CFG)" == "glmovie - Win32 Release"


"$(INTDIR)\DlgControl.obj" : $(SOURCE) $(DEP_CPP_DLGCO) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"


!ELSEIF  "$(CFG)" == "glmovie - Win32 Debug"


"$(INTDIR)\DlgControl.obj" : $(SOURCE) $(DEP_CPP_DLGCO) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"

"$(INTDIR)\DlgControl.sbr" : $(SOURCE) $(DEP_CPP_DLGCO) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\MatVarDir.cpp
DEP_CPP_MATVA=\
	".\StdAfx.h"\
	".\glmovie.h"\
	".\MatVarDir.h"\
	"c:\Program Files\matlab5\extern\include\mat.h"\
	".\..\..\..\Program Files\matlab5\extern\include\matrix.h"\
	".\..\..\..\Program Files\matlab5\extern\include\mwdebug.h"\
	".\..\..\..\Program Files\matlab5\extern\include\tmwtypes.h"\
	

!IF  "$(CFG)" == "glmovie - Win32 Release"


"$(INTDIR)\MatVarDir.obj" : $(SOURCE) $(DEP_CPP_MATVA) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"


!ELSEIF  "$(CFG)" == "glmovie - Win32 Debug"


"$(INTDIR)\MatVarDir.obj" : $(SOURCE) $(DEP_CPP_MATVA) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"

"$(INTDIR)\MatVarDir.sbr" : $(SOURCE) $(DEP_CPP_MATVA) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\DlgGetArraySize.cpp
DEP_CPP_DLGGE=\
	".\StdAfx.h"\
	".\glmovie.h"\
	".\DlgGetArraySize.h"\
	

!IF  "$(CFG)" == "glmovie - Win32 Release"


"$(INTDIR)\DlgGetArraySize.obj" : $(SOURCE) $(DEP_CPP_DLGGE) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"


!ELSEIF  "$(CFG)" == "glmovie - Win32 Debug"


"$(INTDIR)\DlgGetArraySize.obj" : $(SOURCE) $(DEP_CPP_DLGGE) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"

"$(INTDIR)\DlgGetArraySize.sbr" : $(SOURCE) $(DEP_CPP_DLGGE) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\GLSeq2D.cpp
DEP_CPP_GLSEQ=\
	".\StdAfx.h"\
	".\GLSeq2D.h"\
	

!IF  "$(CFG)" == "glmovie - Win32 Release"


"$(INTDIR)\GLSeq2D.obj" : $(SOURCE) $(DEP_CPP_GLSEQ) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"


!ELSEIF  "$(CFG)" == "glmovie - Win32 Debug"


"$(INTDIR)\GLSeq2D.obj" : $(SOURCE) $(DEP_CPP_GLSEQ) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"

"$(INTDIR)\GLSeq2D.sbr" : $(SOURCE) $(DEP_CPP_GLSEQ) "$(INTDIR)"\
 "$(INTDIR)\glmovie.pch"


!ENDIF 

# End Source File
# End Target
# End Project
################################################################################
