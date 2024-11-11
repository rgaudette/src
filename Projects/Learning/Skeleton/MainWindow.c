#include "StdSdk.h"
#include "MainWindow.h"

#include "About.h"
#include "resource.h"

LRESULT CALLBACK 
mainFrameWndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam) {

    switch (msg) {
        HANDLE_MSG(hWnd, WM_COMMAND, onCommand);
		HANDLE_MSG(hWnd, WM_DESTROY, onDestroy);

    default:
        return (DefWindowProc(hWnd, msg, wParam, lParam));
    }
}

void onDestroy(HWND hWnd) {

    PostQuitMessage(0);
}


void onCommand(HWND hWnd, int CmdID, HWND hWndCtl, UINT codeNotify) {

    switch (CmdID) {
    
    case ID_HELP_ABOUT:
        onAbout(hWnd);
        return;

    case ID_FILE_SAVEAS:
        onSaveAs(hWnd);
        return
    
    case ID_FILE_EXIT:
        DestroyWindow(hWnd);
        return;

    default:
        FORWARD_WM_COMMAND(hWnd, CmdID, hWndCtl, codeNotify, DefWindowProc);
    }
}

