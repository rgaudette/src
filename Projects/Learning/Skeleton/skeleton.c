#include "StdSdk.h"
#include "Initialize.h"
#include "MainWindow.h"
#include "resource.h"

//
//  Entry point from windows
//
int WINAPI WinMain( HINSTANCE hInst,        // handle to current instance
                    HINSTANCE hPrevInst,	// handle to previous instance
                    LPSTR lpCmdLine,	    // pointer to command line
                    int nCmdShow)
{
    MSG   msg;
    HACCEL  haccel;
    
    //
    //  Initialize ths instance
    //  Registering all classes if necessary
    //
    if (!initInstance(hInst, IDR_MAINFRAME, nCmdShow)) {
        return FALSE;
    }
    
    //
    // Load accelerator table for the main window
    //
    haccel = LoadAccelerators (hInst, MAKEINTRESOURCE (IDR_MAINFRAME)) ;
    
    //
    //  Message loop
    //
    while (GetMessage(&msg, NULL, 0, 0) ){

        //
        //  Translate accelerator into message, else dispatch message
        //
        if (!TranslateAccelerator(msg.hwnd, haccel, &msg)){
            //
            //  Translate the message, handling any menu, or strings
            //
            TranslateMessage(&msg);

            //
            //  Dispatch the message to the window function
            //
            DispatchMessage(&msg);
        }
    }
    
    return TRUE;
}
