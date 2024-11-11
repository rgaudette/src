#include <windows.h>
#include <gl\gl.h>
#include <gl\glaux.h>

//  Initial square position

GLfloat x1 = 100.0f;
GLfloat y1 = 150.0f;
GLsizei rsize = 50;

GLfloat xstep = 1.0f;
GLfloat ystep = 1.0f;

GLfloat windowWidth;
GLfloat windowHeight;

void CALLBACK ChangeSize(GLsizei w, GLsizei h) {

	if(h == 0) h = 1;

	glViewport(0, 0, w, h);
	glLoadIdentity();

	if(w <= h) {
		windowHeight = 250.0f * h / w;
		windowWidth = 250.0f;
	}
	else {
		windowWidth = 250.0f * w / h;
		windowHeight = 250.0f;
	}

	glOrtho(0.0f, windowWidth, 0.0f, windowHeight, 1.0f, -1.0f);
}


void CALLBACK RenderScene(void) {
	
	glClearColor(0.0f, 0.0f, 1.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT);
	glColor3f(1.0f, 0.0f, 0.0f);
	glRectf(x1, y1, x1+rsize, y1+rsize);

	glFlush();
	auxSwapBuffers();

}

void CALLBACK IdleFunction(void) {
	
	if(x1 > windowWidth-rsize || x1 < 0)
		xstep = -xstep;
	
	if(y1 > windowHeight-rsize || y1 < 0)
		ystep = -ystep;

	if(x1 > windowWidth-rsize)
		x1 = windowWidth-rsize-1;

	if(y1 > windowHeight-rsize)
		y1 = windowHeight-rsize-1;

	x1 += xstep;
	y1 += ystep;

	RenderScene();
}

void main(void) {

	auxInitDisplayMode(AUX_DOUBLE | AUX_RGBA);
	auxInitPosition(100, 100, 250, 250);
	auxInitWindow("Simple 2D Animation");

	auxReshapeFunc(ChangeSize);
	auxIdleFunc(IdleFunction);
	auxMainLoop(RenderScene);
}