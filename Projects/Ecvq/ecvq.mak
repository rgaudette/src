# Microsoft Developer Studio Generated NMAKE File, Format Version 40001
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

!IF "$(CFG)" == ""
CFG=Ecvq - Win32 Debug
!MESSAGE No configuration specified.  Defaulting to Ecvq - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "Ecvq - Win32 Release" && "$(CFG)" != "Ecvq - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "Ecvq.mak" CFG="Ecvq - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Ecvq - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "Ecvq - Win32 Debug" (based on "Win32 (x86) Console Application")
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
RSC=rc.exe
CPP=cl.exe

!IF  "$(CFG)" == "Ecvq - Win32 Release"

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

ALL : "$(OUTDIR)\Ecvq.exe"

CLEAN : 
	-@erase ".\Release\Ecvq.exe"
	-@erase ".\Release\Ecvq.obj"
	-@erase ".\Release\Vquant.obj"
	-@erase ".\Release\Mfutils.obj"
	-@erase ".\Release\Matlib.obj"
	-@erase ".\Release\Vecsort.obj"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /YX /c
# ADD CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /YX /c
CPP_PROJ=/nologo /ML /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE"\
 /Fp"$(INTDIR)/Ecvq.pch" /YX /Fo"$(INTDIR)/" /c 
CPP_OBJS=.\Release/
CPP_SBRS=
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/Ecvq.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib\
 odbccp32.lib /nologo /subsystem:console /incremental:no\
 /pdb:"$(OUTDIR)/Ecvq.pdb" /machine:I386 /out:"$(OUTDIR)/Ecvq.exe" 
LINK32_OBJS= \
	".\Release\Ecvq.obj" \
	".\Release\Vquant.obj" \
	".\Release\Mfutils.obj" \
	".\Release\Matlib.obj" \
	".\Release\Vecsort.obj"

"$(OUTDIR)\Ecvq.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "Ecvq - Win32 Debug"

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

ALL : "$(OUTDIR)\Ecvq.exe"

CLEAN : 
	-@erase ".\Debug\Ecvq.exe"
	-@erase ".\Debug\Ecvq.obj"
	-@erase ".\Debug\Vquant.obj"
	-@erase ".\Debug\Mfutils.obj"
	-@erase ".\Debug\Matlib.obj"
	-@erase ".\Debug\Vecsort.obj"
	-@erase ".\Debug\Ecvq.ilk"
	-@erase ".\Debug\Ecvq.pdb"
	-@erase ".\Debug\vc40.pdb"
	-@erase ".\Debug\vc40.idb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /YX /c
# ADD CPP /nologo /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /YX /c
CPP_PROJ=/nologo /MLd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE"\
 /Fp"$(INTDIR)/Ecvq.pch" /YX /Fo"$(INTDIR)/" /Fd"$(INTDIR)/" /c 
CPP_OBJS=.\Debug/
CPP_SBRS=
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/Ecvq.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib\
 odbccp32.lib /nologo /subsystem:console /incremental:yes\
 /pdb:"$(OUTDIR)/Ecvq.pdb" /debug /machine:I386 /out:"$(OUTDIR)/Ecvq.exe" 
LINK32_OBJS= \
	".\Debug\Ecvq.obj" \
	".\Debug\Vquant.obj" \
	".\Debug\Mfutils.obj" \
	".\Debug\Matlib.obj" \
	".\Debug\Vecsort.obj"

"$(OUTDIR)\Ecvq.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
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

# Name "Ecvq - Win32 Release"
# Name "Ecvq - Win32 Debug"

!IF  "$(CFG)" == "Ecvq - Win32 Release"

!ELSEIF  "$(CFG)" == "Ecvq - Win32 Debug"

!ENDIF 

################################################################################
# Begin Source File

SOURCE=.\Ecvq.c
DEP_CPP_ECVQ_=\
	".\matlib.h"\
	".\vquant.h"\
	".\mfutils.h"\
	
NODEP_CPP_ECVQ_=\
	"..\..\Matlib\matlib.h"\
	

"$(INTDIR)\Ecvq.obj" : $(SOURCE) $(DEP_CPP_ECVQ_) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\Vquant.c
DEP_CPP_VQUAN=\
	".\vquant.h"\
	".\matlib.h"\
	

"$(INTDIR)\Vquant.obj" : $(SOURCE) $(DEP_CPP_VQUAN) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\Mfutils.c
DEP_CPP_MFUTI=\
	{$(INCLUDE)}"\sys\types.h"\
	{$(INCLUDE)}"\sys\stat.h"\
	".\matlib.h"\
	".\mfutils.h"\
	

"$(INTDIR)\Mfutils.obj" : $(SOURCE) $(DEP_CPP_MFUTI) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\Matlib.c
DEP_CPP_MATLI=\
	".\matlib.h"\
	

"$(INTDIR)\Matlib.obj" : $(SOURCE) $(DEP_CPP_MATLI) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\Vecsort.c

"$(INTDIR)\Vecsort.obj" : $(SOURCE) "$(INTDIR)"


# End Source File
# End Target
# End Project
################################################################################
