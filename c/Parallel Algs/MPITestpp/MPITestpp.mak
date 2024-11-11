# Microsoft Developer Studio Generated NMAKE File, Format Version 40001
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

!IF "$(CFG)" == ""
CFG=MPITestpp - Win32 Debug
!MESSAGE No configuration specified.  Defaulting to MPITestpp - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "MPITestpp - Win32 Release" && "$(CFG)" !=\
 "MPITestpp - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "MPITestpp.mak" CFG="MPITestpp - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "MPITestpp - Win32 Release" (based on\
 "Win32 (x86) Console Application")
!MESSAGE "MPITestpp - Win32 Debug" (based on "Win32 (x86) Console Application")
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
# PROP Target_Last_Scanned "MPITestpp - Win32 Debug"
RSC=rc.exe
CPP=cl.exe

!IF  "$(CFG)" == "MPITestpp - Win32 Release"

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

ALL : "$(OUTDIR)\MPITestpp.exe"

CLEAN : 
	-@erase ".\Release\MPITestpp.exe"
	-@erase ".\Release\mpitest.obj"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /YX /c
# ADD CPP /nologo /G5 /W3 /GX /O2 /I "\Progra~1\winmpich\include" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /c
# SUBTRACT CPP /YX
CPP_PROJ=/nologo /G5 /ML /W3 /GX /O2 /I "\Progra~1\winmpich\include" /D "WIN32"\
 /D "NDEBUG" /D "_CONSOLE" /Fo"$(INTDIR)/" /c 
CPP_OBJS=.\Release/
CPP_SBRS=
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/MPITestpp.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib \progra~1\winmpich\lib\winmpich.lib /nologo /subsystem:console /machine:I386
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib\
 \progra~1\winmpich\lib\winmpich.lib /nologo /subsystem:console /incremental:no\
 /pdb:"$(OUTDIR)/MPITestpp.pdb" /machine:I386 /out:"$(OUTDIR)/MPITestpp.exe" 
LINK32_OBJS= \
	"$(INTDIR)/mpitest.obj"

"$(OUTDIR)\MPITestpp.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "MPITestpp - Win32 Debug"

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

ALL : "$(OUTDIR)\MPITestpp.exe"

CLEAN : 
	-@erase ".\Debug\vc40.pdb"
	-@erase ".\Debug\vc40.idb"
	-@erase ".\Debug\MPITestpp.exe"
	-@erase ".\Debug\mpitest.obj"
	-@erase ".\Debug\MPITestpp.ilk"
	-@erase ".\Debug\MPITestpp.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /YX /c
# ADD CPP /nologo /G5 /W3 /Gm /GX /Zi /Od /I "\Progra~1\winmpich\include" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /c
# SUBTRACT CPP /YX
CPP_PROJ=/nologo /G5 /MLd /W3 /Gm /GX /Zi /Od /I "\Progra~1\winmpich\include"\
 /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /Fo"$(INTDIR)/" /Fd"$(INTDIR)/" /c 
CPP_OBJS=.\Debug/
CPP_SBRS=
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/MPITestpp.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib /nologo /subsystem:console /debug /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib \progra~1\winmpich\lib\winmpich.lib /nologo /subsystem:console /debug /machine:I386
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib\
 \progra~1\winmpich\lib\winmpich.lib /nologo /subsystem:console /incremental:yes\
 /pdb:"$(OUTDIR)/MPITestpp.pdb" /debug /machine:I386\
 /out:"$(OUTDIR)/MPITestpp.exe" 
LINK32_OBJS= \
	"$(INTDIR)/mpitest.obj"

"$(OUTDIR)\MPITestpp.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
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

# Name "MPITestpp - Win32 Release"
# Name "MPITestpp - Win32 Debug"

!IF  "$(CFG)" == "MPITestpp - Win32 Release"

!ELSEIF  "$(CFG)" == "MPITestpp - Win32 Debug"

!ENDIF 

################################################################################
# Begin Source File

SOURCE=.\mpitest.cpp
DEP_CPP_MPITE=\
	"\Progra~1\winmpich\include\mpi.h"\
	"..\..\..\Progra~1\winmpich\include\mpi_errno.h"\
	"..\..\..\Progra~1\winmpich\include\binding.h"\
	

"$(INTDIR)\mpitest.obj" : $(SOURCE) $(DEP_CPP_MPITE) "$(INTDIR)"


# End Source File
# End Target
# End Project
################################################################################
