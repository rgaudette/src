#include <windows.h>
#include <conio.h>
#include <gl\gl.h>
#include <gl\glaux.h>


void main(void) {

	//
	//  set up the graphics window
	//
	auxInitDisplayMode(AUX_SINGLE | AUX_RGBA);
	auxInitPosition(100, 100, 250, 250);
	auxInitWindow("OpenGL on NT/95");

	//
	//  set the clear color for the window
	//
	glClearColor(0.0f, 0.0f, 1.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT);

	glFlush();

	//
	//  Wait for a key to exit
	//
	cprintf("Press any key to exit");
	getch();

}

