# Microsoft Developer Studio Generated NMAKE File, Format Version 40001
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Application" 0x0101

!IF "$(CFG)" == ""
CFG=Skeleton - Win32 Debug
!MESSAGE No configuration specified.  Defaulting to Skeleton - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "Skeleton - Win32 Release" && "$(CFG)" !=\
 "Skeleton - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "Skeleton.mak" CFG="Skeleton - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Skeleton - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "Skeleton - Win32 Debug" (based on "Win32 (x86) Application")
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
# PROP Target_Last_Scanned "Skeleton - Win32 Debug"
CPP=cl.exe
RSC=rc.exe
MTL=mktyplib.exe

!IF  "$(CFG)" == "Skeleton - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Target_Dir ""
OUTDIR=.\Release
INTDIR=.\Release

ALL : "$(OUTDIR)\Skeleton.exe"

CLEAN : 
	-@erase ".\Release\Skeleton.exe"
	-@erase ".\Release\MainWindow.obj"
	-@erase ".\Release\Initialize.obj"
	-@erase ".\Release\About.obj"
	-@erase ".\Release\skeleton.obj"
	-@erase ".\Release\Skeleton.res"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX /c
# ADD CPP /nologo /G5 /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX"StdSdk.h" /c
CPP_PROJ=/nologo /G5 /ML /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS"\
 /Fp"$(INTDIR)/Skeleton.pch" /YX"StdSdk.h" /Fo"$(INTDIR)/" /c 
CPP_OBJS=.\Release/
CPP_SBRS=
# ADD BASE MTL /nologo /D "NDEBUG" /win32
# ADD MTL /nologo /D "NDEBUG" /win32
MTL_PROJ=/nologo /D "NDEBUG" /win32 
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
RSC_PROJ=/l 0x409 /fo"$(INTDIR)/Skeleton.res" /d "NDEBUG" 
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/Skeleton.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib /nologo /subsystem:windows /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib /nologo /subsystem:windows /machine:I386
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib /nologo\
 /subsystem:windows /incremental:no /pdb:"$(OUTDIR)/Skeleton.pdb" /machine:I386\
 /out:"$(OUTDIR)/Skeleton.exe" 
LINK32_OBJS= \
	"$(INTDIR)/MainWindow.obj" \
	"$(INTDIR)/Initialize.obj" \
	"$(INTDIR)/About.obj" \
	"$(INTDIR)/skeleton.obj" \
	"$(INTDIR)/Skeleton.res"

"$(OUTDIR)\Skeleton.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "Skeleton - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""
OUTDIR=.\Debug
INTDIR=.\Debug

ALL : "$(OUTDIR)\Skeleton.exe"

CLEAN : 
	-@erase ".\Debug\vc40.pdb"
	-@erase ".\Debug\vc40.idb"
	-@erase ".\Debug\Skeleton.exe"
	-@erase ".\Debug\skeleton.obj"
	-@erase ".\Debug\About.obj"
	-@erase ".\Debug\MainWindow.obj"
	-@erase ".\Debug\Initialize.obj"
	-@erase ".\Debug\Skeleton.res"
	-@erase ".\Debug\Skeleton.ilk"
	-@erase ".\Debug\Skeleton.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX /c
# ADD CPP /nologo /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX"StdSdk.h" /c
CPP_PROJ=/nologo /MLd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS"\
 /Fp"$(INTDIR)/Skeleton.pch" /YX"StdSdk.h" /Fo"$(INTDIR)/" /Fd"$(INTDIR)/" /c 
CPP_OBJS=.\Debug/
CPP_SBRS=
# ADD BASE MTL /nologo /D "_DEBUG" /win32
# ADD MTL /nologo /D "_DEBUG" /win32
MTL_PROJ=/nologo /D "_DEBUG" /win32 
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
RSC_PROJ=/l 0x409 /fo"$(INTDIR)/Skeleton.res" /d "_DEBUG" 
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/Skeleton.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib /nologo /subsystem:windows /debug /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib /nologo /subsystem:windows /debug /machine:I386
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib /nologo\
 /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)/Skeleton.pdb" /debug\
 /machine:I386 /out:"$(OUTDIR)/Skeleton.exe" 
LINK32_OBJS= \
	"$(INTDIR)/skeleton.obj" \
	"$(INTDIR)/About.obj" \
	"$(INTDIR)/MainWindow.obj" \
	"$(INTDIR)/Initialize.obj" \
	"$(INTDIR)/Skeleton.res"

"$(OUTDIR)\Skeleton.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
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

# Name "Skeleton - Win32 Release"
# Name "Skeleton - Win32 Debug"

!IF  "$(CFG)" == "Skeleton - Win32 Release"

!ELSEIF  "$(CFG)" == "Skeleton - Win32 Debug"

!ENDIF 

################################################################################
# Begin Source File

SOURCE=.\skeleton.c
DEP_CPP_SKELE=\
	".\StdSdk.h"\
	".\Initialize.h"\
	".\MainWindow.h"\
	

"$(INTDIR)\skeleton.obj" : $(SOURCE) $(DEP_CPP_SKELE) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\Skeleton.rc
DEP_RSC_SKELET=\
	".\icon1.ico"\
	

"$(INTDIR)\Skeleton.res" : $(SOURCE) $(DEP_RSC_SKELET) "$(INTDIR)"
   $(RSC) $(RSC_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=.\Initialize.c
DEP_CPP_INITI=\
	".\StdSdk.h"\
	".\Initialize.h"\
	".\MainWindow.h"\
	

"$(INTDIR)\Initialize.obj" : $(SOURCE) $(DEP_CPP_INITI) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\MainWindow.c
DEP_CPP_MAINW=\
	".\StdSdk.h"\
	".\MainWindow.h"\
	".\About.h"\
	

"$(INTDIR)\MainWindow.obj" : $(SOURCE) $(DEP_CPP_MAINW) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\About.c

!IF  "$(CFG)" == "Skeleton - Win32 Release"

DEP_CPP_ABOUT=\
	".\StdSdk.h"\
	".\About.h"\
	
NODEP_CPP_ABOUT=\
	".\HINSTANCE"\
	".\hInst"\
	".\GetWindowInstance"\
	

"$(INTDIR)\About.obj" : $(SOURCE) $(DEP_CPP_ABOUT) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Skeleton - Win32 Debug"

DEP_CPP_ABOUT=\
	".\StdSdk.h"\
	".\About.h"\
	

"$(INTDIR)\About.obj" : $(SOURCE) $(DEP_CPP_ABOUT) "$(INTDIR)"


!ENDIF 

# End Source File
# End Target
# End Project
################################################################################
