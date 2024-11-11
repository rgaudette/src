#include <windows.h>

static LPCTSTR szAppName = "Hi!";

HBRUSH		hBlueBrush;
HBRUSH		hRedBrush;

LRESULT CALLBACK WndProc(	HWND	hWnd,
							UINT	message,
							WPARAM	wParam,
							LPARAM	lParam);

int APIENTRY WinMain(	HINSTANCE	hInstance,
						HINSTANCE	hPrevInstance,
						LPSTR		lpCmdLine,
						int			nCmdShow) {

	MSG			msg;
	WNDCLASS	wc;
	HWND		hWnd;
	
	hBlueBrush = CreateSolidBrush(RGB(0, 0, 255));
	hRedBrush = CreateSolidBrush(RGB(255, 0, 0));

	//
	//	Register the window style
	//
	wc.style			= CS_HREDRAW | CS_VREDRAW;
	wc.lpfnWndProc		= (WNDPROC) WndProc;
	wc.cbClsExtra		= 0;
	wc.cbWndExtra		= 0;
	wc.hInstance		= hInstance;
	wc.hIcon			= NULL;
	wc.hCursor			= LoadCursor(NULL, IDC_ARROW);
	wc.hbrBackground	= hBkgBrush;
	wc.lpszMenuName		= NULL;
	wc.lpszClassName	= szAppName;


	//	Register the windows class
	//
	if(RegisterClass(&wc) == 0)
		return FALSE;

	hWnd = CreateWindow(szAppName, szAppName, WS_OVERLAPPEDWINDOW,
		100, 100, 250, 250,
		NULL, NULL, hInstance, NULL);

	if (!hWnd) {
		return (FALSE);
	}
	//
	//	Check to see if window was created
	//
	if(hWnd == NULL){
		return FALSE;
	}
	//
	//	Show and Update window
	//
	ShowWindow(hWnd, SW_SHOW);
	UpdateWindow(hWnd);

	//
	//  Process the message strem
	while( GetMessage(&msg, NULL, 0, 0)) {
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

	return msg.wParam;
}

LRESULT CALLBACK WndProc(	HWND	hWnd,
							UINT	message,
							WPARAM	wParam,
							LPARAM	lParam) {
	static HDC hDC;

	switch (message) {
	case WM_CREATE:
		hDC = GetDC(hWnd);
		break;

	case WM_DESTROY:
		ReleaseDC(hWnd, hDC);
		PostQuitMessage(0);
		break;
	
	default:
	    return (DefWindowProc(hWnd, message, wParam, lParam));
	}
	return (0L);
}

