# Microsoft Developer Studio Generated NMAKE File, Format Version 40001
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

!IF "$(CFG)" == ""
CFG=PActVel - Win32 Debug
!MESSAGE No configuration specified.  Defaulting to PActVel - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "PActVel - Win32 Release" && "$(CFG)" !=\
 "PActVel - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "PActVel.mak" CFG="PActVel - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "PActVel - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "PActVel - Win32 Debug" (based on "Win32 (x86) Console Application")
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
# PROP Target_Last_Scanned "PActVel - Win32 Debug"
RSC=rc.exe
CPP=cl.exe

!IF  "$(CFG)" == "PActVel - Win32 Release"

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

ALL : "$(OUTDIR)\PActVel.exe"

CLEAN : 
	-@erase ".\Release\PActVel.exe"
	-@erase ".\Release\PActVel.obj"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /YX /c
# ADD CPP /nologo /W3 /GX /O2 /I "C:\Program Files\winmpich\include" /I " C:\Src\Projects\Matlib" /I " C:\Src\Projects\MFUtils" /D "NDEBUG" /D "WIN32" /D "_CONSOLE" /D " MYDEBUG" /c
# SUBTRACT CPP /YX
CPP_PROJ=/nologo /ML /W3 /GX /O2 /I "C:\Program Files\winmpich\include" /I\
 " C:\Src\Projects\Matlib" /I " C:\Src\Projects\MFUtils" /D "NDEBUG" /D "WIN32"\
 /D "_CONSOLE" /D " MYDEBUG" /Fo"$(INTDIR)/" /c 
CPP_OBJS=.\Release/
CPP_SBRS=
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/PActVel.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib "C:\Program Files\winmpich\lib\winmpich.lib" "C:\Src\Projects\Matlib\Debug\matlib.lib" "C:\Program Files\Matlab5\extern\lib\libmat.lib" "C:\Program Files\Matlab5\extern\lib\libmx.lib" "C:\Src\Projects\MFUtils\Debug\mfutils.lib" /nologo /subsystem:console /machine:I386
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib "C:\Program Files\winmpich\lib\winmpich.lib"\
 "C:\Src\Projects\Matlib\Debug\matlib.lib"\
 "C:\Program Files\Matlab5\extern\lib\libmat.lib"\
 "C:\Program Files\Matlab5\extern\lib\libmx.lib"\
 "C:\Src\Projects\MFUtils\Debug\mfutils.lib" /nologo /subsystem:console\
 /incremental:no /pdb:"$(OUTDIR)/PActVel.pdb" /machine:I386\
 /out:"$(OUTDIR)/PActVel.exe" 
LINK32_OBJS= \
	"$(INTDIR)/PActVel.obj"

"$(OUTDIR)\PActVel.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "PActVel - Win32 Debug"

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

ALL : "$(OUTDIR)\PActVel.exe" "$(OUTDIR)\PActVel.bsc"

CLEAN : 
	-@erase ".\Debug\vc40.pdb"
	-@erase ".\Debug\vc40.idb"
	-@erase ".\Debug\PActVel.bsc"
	-@erase ".\Debug\PActVel.sbr"
	-@erase ".\Debug\PActVel.exe"
	-@erase ".\Debug\PActVel.obj"
	-@erase ".\Debug\PActVel.ilk"
	-@erase ".\Debug\PActVel.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /YX /c
# ADD CPP /nologo /W3 /Gm /GX /Zi /Od /I "C:\Program Files\winmpich\include" /I " C:\Src\Projects\Matlib" /I " C:\Src\Projects\MFUtils" /D "_DEBUG" /D "WIN32" /D "_CONSOLE" /D " MYDEBUG" /FR /c
# SUBTRACT CPP /YX
CPP_PROJ=/nologo /MLd /W3 /Gm /GX /Zi /Od /I\
 "C:\Program Files\winmpich\include" /I " C:\Src\Projects\Matlib" /I\
 " C:\Src\Projects\MFUtils" /D "_DEBUG" /D "WIN32" /D "_CONSOLE" /D " MYDEBUG"\
 /FR"$(INTDIR)/" /Fo"$(INTDIR)/" /Fd"$(INTDIR)/" /c 
CPP_OBJS=.\Debug/
CPP_SBRS=.\Debug/
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/PActVel.bsc" 
BSC32_SBRS= \
	"$(INTDIR)/PActVel.sbr"

"$(OUTDIR)\PActVel.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib /nologo /subsystem:console /debug /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib "C:\Program Files\winmpich\lib\winmpich.lib" "C:\Src\Projects\Matlib\Debug\matlib.lib" "C:\Program Files\Matlab5\extern\lib\libmat.lib" "C:\Program Files\Matlab5\extern\lib\libmx.lib" "C:\Src\Projects\MFUtils\Debug\mfutils.lib" /nologo /subsystem:console /debug /machine:I386
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib "C:\Program Files\winmpich\lib\winmpich.lib"\
 "C:\Src\Projects\Matlib\Debug\matlib.lib"\
 "C:\Program Files\Matlab5\extern\lib\libmat.lib"\
 "C:\Program Files\Matlab5\extern\lib\libmx.lib"\
 "C:\Src\Projects\MFUtils\Debug\mfutils.lib" /nologo /subsystem:console\
 /incremental:yes /pdb:"$(OUTDIR)/PActVel.pdb" /debug /machine:I386\
 /out:"$(OUTDIR)/PActVel.exe" 
LINK32_OBJS= \
	"$(INTDIR)/PActVel.obj"

"$(OUTDIR)\PActVel.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
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

# Name "PActVel - Win32 Release"
# Name "PActVel - Win32 Debug"

!IF  "$(CFG)" == "PActVel - Win32 Release"

!ELSEIF  "$(CFG)" == "PActVel - Win32 Debug"

!ENDIF 

################################################################################
# Begin Source File

SOURCE=.\PActVel.c
DEP_CPP_PACTV=\
	"\Program Files\winmpich\include\mpi.h"\
	"\Src\Projects\Matlib\Matlib.h"\
	"\Src\Projects\MFUtils\mfutils.h"\
	".\PActVel.h"\
	".\..\..\..\Program Files\winmpich\include\mpi_errno.h"\
	".\..\..\..\Program Files\winmpich\include\binding.h"\
	

!IF  "$(CFG)" == "PActVel - Win32 Release"


"$(INTDIR)\PActVel.obj" : $(SOURCE) $(DEP_CPP_PACTV) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "PActVel - Win32 Debug"


"$(INTDIR)\PActVel.obj" : $(SOURCE) $(DEP_CPP_PACTV) "$(INTDIR)"

"$(INTDIR)\PActVel.sbr" : $(SOURCE) $(DEP_CPP_PACTV) "$(INTDIR)"


!ENDIF 

# End Source File
# End Target
# End Project
################################################################################
