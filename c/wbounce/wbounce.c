//  There are two primary functions needed for all Win32 programs.
//	WinMain which is called upon startup and WndProc which handles
//	messages passed to the window

#include <windows.h>

char lpszAppName[] = "Hi!";

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

	//
	//	Register the window style
	//
	wc.style		= CS_HREDRAW | CS_VREDRAW;
	wc.lpfnWndProc	= (WNDPROC) WndProc;
	wc.cbClsExtra	= 0;
	wc.cbWndExtra	= 0;
	wc.hInstance	= hInstance;
	wc.hIcon		= NULL;
	wc.hCursor		= LoadCursor(NULL, IDC_ARROW);

	wc.hbrBackground	= NULL;
	wc.hbrBackground = (HBRUSH)(COLOR_WINDOW+1);;
	wc.lpszMenuName		= lpszAppName;

	//
	//	Register the windows class
	//
	if(RegisterClass(&wc) == 0)
		return FALSE;

	//
	//	Create the main window
	//
	hWnd = CreateWindow(
		lpszAppName, lpszAppName,
		WS_OVERLAPPEDWINDOW |WS_CLIPCHILDREN |WS_CLIPSIBLINGS,
		100, 100, 250, 250,
		NULL, NULL, hInstance, NULL);

	//
	//	Check to see if window was created
	//
	if(hWnd == NULL)
		return FALSE;

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
	}
	return (0L);
}

