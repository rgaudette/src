#include "StdSdk.h"
#include "Initialize.h"

#include "MainWindow.h"
#include "resource.h"


#define DIM(X) (sizeof(X)/sizeof(X[0]))

BOOL initInstance(HINSTANCE hInst, UINT resPoolID, int nCmdShow) {
    
    HWND hWnd;
    TCHAR ClassName [MAX_RESOURCESTRING + 1];

    //
    //  Load in the window class name
    //
    LoadString (hInst, resPoolID, ClassName, DIM(ClassName));

    //
    //  Check to see if this app is already running
    //
    hWnd = FindWindow(ClassName, NULL);
    if (hWnd) {

        //
        //  If the window is iconified, show window
        //
        if (IsIconic(hWnd))
            ShowWindow(hWnd, SW_RESTORE);

        //
        //  Bring window to the foreground
        //
        SetForegroundWindow(hWnd);

        //
        //  Send necessary messages to application
        //

        //
        //  Exit this instance
        //
        return FALSE;
    }

    //
    //  Register the window class(es)
    //
    if (!registerWindowClasses(hInst, resPoolID)) {
        return FALSE;
    }

    //
    //  Initialize the common controls DLL
    //
    //InitCommonControls();

    //
    //  Create application main frame window
    //
    if (!createMainFrameWindow(hInst, nCmdShow)) {
        return FALSE;
    }

    return TRUE;
}

static BOOL registerWindowClasses(HINSTANCE hInst, UINT resPoolID) {

    TCHAR       ClassName[MAX_RESOURCESTRING + 1];
    WNDCLASSEX  wcex;

    LoadString(hInst, resPoolID, ClassName, DIM(ClassName));

    //
    //  Create the window class structure
    //
    wcex.cbSize         = sizeof(WNDCLASSEX);
    wcex.style          = CS_HREDRAW | CS_VREDRAW | CS_DBLCLKS;
    wcex.lpfnWndProc    = mainFrameWndProc;
    wcex.cbClsExtra     = 0;
    wcex.cbWndExtra     = 0;
    wcex.hInstance      = hInst;
    wcex.hIcon          = LoadIcon(hInst, MAKEINTRESOURCE(resPoolID));
    wcex.hCursor        = LoadCursor(NULL, IDC_ARROW);
    wcex.hbrBackground  = (HBRUSH) (COLOR_WINDOW+1);    
    wcex.lpszMenuName       =  MAKEINTRESOURCE(resPoolID);
    wcex.lpszClassName  = ClassName;
    wcex.hIconSm        = LoadImage(hInst,
                                    MAKEINTRESOURCE(resPoolID),
                                    IMAGE_ICON,
                                    GetSystemMetrics(SM_CXSMICON),
                                    GetSystemMetrics(SM_CYSMICON),
                                    LR_SHARED);
    //
    //  Register the window class
    //  - note that this will not run on pre 4.0 Win32
    //
    return RegisterClassEx(&wcex);
}

static HWND createMainFrameWindow(HINSTANCE hInst, int nCmdShow) {
    
    HWND    hWnd;
    TCHAR   ClassName[MAX_RESOURCESTRING + 1];
    TCHAR   Title[MAX_RESOURCESTRING + 1];

    LoadString(hInst, IDR_MAINFRAME, ClassName, DIM(ClassName));
    LoadString(hInst, IDS_APP_TITLE, Title, DIM(Title));

    hWnd = CreateWindowEx(0,
                          ClassName,
                          Title,
                          WS_OVERLAPPEDWINDOW,
                          CW_USEDEFAULT,
                          0,
                          CW_USEDEFAULT,
                          0,
                          NULL,
                          NULL,
                          hInst,
                          NULL);

    //
    //  Check to see that a window was actually created
    //
    //ASSERT(NULL != hWnd);
    if (hWnd == NULL)
        return NULL;

    //
    //  Show the window
    //
    ShowWindow(hWnd, nCmdShow);

    //
    //  Send a paint message to the window procedure
    //
    UpdateWindow(hWnd);

    return hWnd;
}