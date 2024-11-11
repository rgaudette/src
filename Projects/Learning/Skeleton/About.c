#include "StdSdk.h"
#include "About.h"

#include "resource.h"


void onAbout(HWND hWnd) {
    
    HINSTANCE hInst = GetWindowInstance(hWnd);

    DialogBox(hInst, MAKEINTRESOURCE(IDD_ABOUTBOX), hWnd, (DLGPROC) aboutDlgProc);
}

BOOL CALLBACK aboutDlgProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam) {

    switch (msg) {
    
    case WM_COMMAND:
        return HANDLE_WM_COMMAND(hWnd, wParam, lParam, aboutDlg_OnCommand);

    case WM_INITDIALOG:
        return HANDLE_WM_INITDIALOG(hWnd, wParam, lParam, aboutDlg_OnInitDialog);
    }

    return FALSE;
}

static BOOL aboutDlg_OnInitDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam) {
    return TRUE;
}

static void aboutDlg_OnCommand(HWND hWnd, int id, HWND hWndCtl, UINT codeNotify) {

    switch (id) {
    case IDOK:
    case IDCANCEL:
        EndDialog(hWnd, TRUE);
        break;
    }
}

        