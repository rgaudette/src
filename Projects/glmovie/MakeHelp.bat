@echo off
REM -- First make map file from Microsoft Visual C++ generated resource.h
echo // MAKEHELP.BAT generated Help Map file.  Used by GLMOVIE.HPJ. >"hlp\glmovie.hm"
echo. >>"hlp\glmovie.hm"
echo // Commands (ID_* and IDM_*) >>"hlp\glmovie.hm"
makehm ID_,HID_,0x10000 IDM_,HIDM_,0x10000 resource.h >>"hlp\glmovie.hm"
echo. >>"hlp\glmovie.hm"
echo // Prompts (IDP_*) >>"hlp\glmovie.hm"
makehm IDP_,HIDP_,0x30000 resource.h >>"hlp\glmovie.hm"
echo. >>"hlp\glmovie.hm"
echo // Resources (IDR_*) >>"hlp\glmovie.hm"
makehm IDR_,HIDR_,0x20000 resource.h >>"hlp\glmovie.hm"
echo. >>"hlp\glmovie.hm"
echo // Dialogs (IDD_*) >>"hlp\glmovie.hm"
makehm IDD_,HIDD_,0x20000 resource.h >>"hlp\glmovie.hm"
echo. >>"hlp\glmovie.hm"
echo // Frame Controls (IDW_*) >>"hlp\glmovie.hm"
makehm IDW_,HIDW_,0x50000 resource.h >>"hlp\glmovie.hm"
REM -- Make help for Project GLMOVIE


echo Building Win32 Help files
start /wait hcrtf -x "hlp\glmovie.hpj"
echo.
if exist Debug\nul copy "hlp\glmovie.hlp" Debug
if exist Debug\nul copy "hlp\glmovie.cnt" Debug
if exist Release\nul copy "hlp\glmovie.hlp" Release
if exist Release\nul copy "hlp\glmovie.cnt" Release
echo.


