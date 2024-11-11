#include<windows.h>
#include<gl\gl.h>
#include<gl\glaux.h>

void CALLBACK RenderScene(void);

void main(void) {

	//
	//  Initialize the OpenGL window
	//
	auxInitDisplayMode(AUX_SINGLE | AUX_RGBA);
	auxInitPosition(100, 100, 250, 250);
	auxInitWindow("Moveable OpenGL Window");

	//
	//  OpenGL message loop
	//
	auxMainLoop(RenderScene);

}


void CALLBACK RenderScene(void) {
	
	//  Set background color to dark red
	glClearColor(0.5f, 0.0f, 0.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT);
	
	glColor3f(0.0f, 0.0f, 0.5f);
	glRectf(100.0f, 150.0f, 150.0f, 100.0f);

	glFlush();
}
