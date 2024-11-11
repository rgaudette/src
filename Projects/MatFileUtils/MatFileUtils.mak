# Microsoft Developer Studio Generated NMAKE File, Format Version 40001
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

!IF "$(CFG)" == ""
CFG=MatFileUtils - Win32 Debug
!MESSAGE No configuration specified.  Defaulting to MatFileUtils - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "MatFileUtils - Win32 Release" && "$(CFG)" !=\
 "MatFileUtils - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "MatFileUtils.mak" CFG="MatFileUtils - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "MatFileUtils - Win32 Release" (based on\
 "Win32 (x86) Console Application")
!MESSAGE "MatFileUtils - Win32 Debug" (based on\
 "Win32 (x86) Console Application")
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
# PROP Target_Last_Scanned "MatFileUtils - Win32 Debug"
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "MatFileUtils - Win32 Release"

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

ALL : "$(OUTDIR)\MatFileUtils.exe"

CLEAN : 
	-@erase ".\Release\MatFileUtils.exe"
	-@erase ".\Release\MatFileUtils.obj"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /YX /c
# ADD CPP /nologo /W3 /GX /O2 /I "C:\Program Files\matlab5\extern\include" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /YX /c
CPP_PROJ=/nologo /ML /W3 /GX /O2 /I "C:\Program Files\matlab5\extern\include"\
 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /Fp"$(INTDIR)/MatFileUtils.pch" /YX\
 /Fo"$(INTDIR)/" /c 
CPP_OBJS=.\Release/
CPP_SBRS=
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/MatFileUtils.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 "c:\Program Files\matlab5\extern\include\matlab.lib" kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib "C:\program Files\matlab5\extern\include\libmat.lib" "C:\program Files\matlab5\extern\include\libmx.lib" /nologo /subsystem:console /machine:I386
LINK32_FLAGS="c:\Program Files\matlab5\extern\include\matlab.lib" kernel32.lib\
 user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib\
 "C:\program Files\matlab5\extern\include\libmat.lib"\
 "C:\program Files\matlab5\extern\include\libmx.lib" /nologo /subsystem:console\
 /incremental:no /pdb:"$(OUTDIR)/MatFileUtils.pdb" /machine:I386\
 /out:"$(OUTDIR)/MatFileUtils.exe" 
LINK32_OBJS= \
	".\Release\MatFileUtils.obj"

"$(OUTDIR)\MatFileUtils.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "MatFileUtils - Win32 Debug"

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

ALL : "$(OUTDIR)\MatFileUtils.exe"

CLEAN : 
	-@erase ".\Debug\vc40.pdb"
	-@erase ".\Debug\vc40.idb"
	-@erase ".\Debug\MatFileUtils.exe"
	-@erase ".\Debug\MatFileUtils.obj"
	-@erase ".\Debug\MatFileUtils.ilk"
	-@erase ".\Debug\MatFileUtils.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /YX /c
# ADD CPP /nologo /W3 /Gm /GX /Zi /Od /I "C:\Program Files\matlab5\extern\include" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /YX /c
CPP_PROJ=/nologo /MLd /W3 /Gm /GX /Zi /Od /I\
 "C:\Program Files\matlab5\extern\include" /D "WIN32" /D "_DEBUG" /D "_CONSOLE"\
 /Fp"$(INTDIR)/MatFileUtils.pch" /YX /Fo"$(INTDIR)/" /Fd"$(INTDIR)/" /c 
CPP_OBJS=.\Debug/
CPP_SBRS=
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/MatFileUtils.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib /nologo /subsystem:console /debug /machine:I386
# ADD LINK32 "C:\program Files\matlab5\extern\include\libmat.lib" "C:\program Files\matlab5\extern\include\libmx.lib" kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib /nologo /subsystem:console /debug /machine:I386
LINK32_FLAGS="C:\program Files\matlab5\extern\include\libmat.lib"\
 "C:\program Files\matlab5\extern\include\libmx.lib" kernel32.lib user32.lib\
 gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib /nologo\
 /subsystem:console /incremental:yes /pdb:"$(OUTDIR)/MatFileUtils.pdb" /debug\
 /machine:I386 /out:"$(OUTDIR)/MatFileUtils.exe" 
LINK32_OBJS= \
	".\Debug\MatFileUtils.obj"

"$(OUTDIR)\MatFileUtils.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
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

# Name "MatFileUtils - Win32 Release"
# Name "MatFileUtils - Win32 Debug"

!IF  "$(CFG)" == "MatFileUtils - Win32 Release"

!ELSEIF  "$(CFG)" == "MatFileUtils - Win32 Debug"

!ENDIF 

################################################################################
# Begin Source File

SOURCE=.\MatFileUtils.c

!IF  "$(CFG)" == "MatFileUtils - Win32 Release"

DEP_CPP_MATFI=\
	"\Program Files\matlab5\extern\include\mat.h"\
	"..\..\..\Program Files\matlab5\extern\include\matrix.h"\
	"..\..\..\Program Files\matlab5\extern\include\mwdebug.h"\
	"..\..\..\Program Files\matlab5\extern\include\tmwtypes.h"\
	

"$(INTDIR)\MatFileUtils.obj" : $(SOURCE) $(DEP_CPP_MATFI) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "MatFileUtils - Win32 Debug"

DEP_CPP_MATFI=\
	"\Program Files\matlab5\extern\include\mat.h"\
	"..\..\..\Program Files\matlab5\extern\include\matrix.h"\
	"..\..\..\Program Files\matlab5\extern\include\mwdebug.h"\
	"..\..\..\Program Files\matlab5\extern\include\tmwtypes.h"\
	
NODEP_CPP_MATFI=\
	".\Directory"\
	

"$(INTDIR)\MatFileUtils.obj" : $(SOURCE) $(DEP_CPP_MATFI) "$(INTDIR)"


!ENDIF 

# End Source File
# End Target
# End Project
################################################################################
