//Arrows	plot arrows representing a complex field
//

//
//  Functions necessary:
//	read in a Matlab file with the appropriate
//
#include <windows.h>
#include <gl\gl.h>
#include <gl\glaux.h>
#include <math.h>
#include <stdio.h>
#include <malloc.h>
#include <stdlib.h>

#include <matlib.h>

//
//  Globals
//
GLfloat	*rCMap;
GLfloat *gCMap;
GLfloat *bCMap;
int		nColors;

GLfloat	*xTriangles;
GLfloat	*yTriangles;
int		nTriangles;
int		*idxColor;
int		nRows, nCols;

GLfloat wndWidth;
GLfloat wndHeight;

//
//  Standard rendering context 
//					
void InitializeRenderingContext(int nCols, int nRows) {

	auxInitDisplayMode(AUX_SINGLE | AUX_RGBA);
	auxInitPosition(0, 0, 600, 400);
	auxInitWindow("Complex Field");
	
}

//
//  Draw the colorbar
//
void ColorBar(void) {

	int iColor;

	glPushMatrix();

	glViewport((GLint)(0.8*wndWidth), (GLint)(0.1*wndHeight),
		(GLsizei)(0.1*wndWidth), (GLsizei)(0.8*wndHeight));
	glLoadIdentity();
	glOrtho(0.0f, 1.0f, 0.0f, 1.0f, 1.0f, -1.0f);
	
	glBegin(GL_QUAD_STRIP);
		glVertex2f(0.0f, 0.0f);
		glVertex2f(1.0f, 0.0f);
		for(iColor=0; iColor < nColors; iColor++) {
			glColor3f(rCMap[iColor], gCMap[iColor], bCMap[iColor]);
	
			glVertex2f(0.0f, iColor/(nColors + 1.0f));
			glVertex2f(1.0f, iColor/(nColors + 1.0f));
		}

	glEnd();

	glFlush();
	glPopMatrix();
}

void Triangles(void) {
	
	int iTri;

	//
	//  Setup the appropriate viewing region for the field display
	glViewport(0, 0, (GLsizei) (0.8*wndWidth), (GLsizei) wndHeight);
	glLoadIdentity();
	if(wndWidth <= wndHeight)
		glOrtho(0, nCols + 1.0f, 0, (nRows + 1.0f) * wndHeight / wndWidth, 1.0f, -1.0f);
	else
		glOrtho(0, (nCols + 1.0f) * wndWidth / wndHeight, 0, nRows + 1.0f, 1.0f, -1.0f);

	glBegin(GL_TRIANGLES);

		for(iTri=0; iTri < nTriangles; iTri++){

			glColor3f(rCMap[idxColor[iTri]], gCMap[idxColor[iTri]], 
				bCMap[idxColor[iTri]]);
			
			glVertex2f(xTriangles[3*iTri], yTriangles[3*iTri]);
			glVertex2f(xTriangles[3*iTri+1], yTriangles[3*iTri+1]);
			glVertex2f(xTriangles[3*iTri+2], yTriangles[3*iTri+2]);
		
		}

	glEnd();
		
	glFlush();
}

void CALLBACK RenderScene(void) {
		
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT| GL_DEPTH_BUFFER_BIT);
	
	Triangles();	
	ColorBar();
}

void CALLBACK ChangeSize(GLsizei w, GLsizei h) {

	if(h == 0) h = 1;
	
	wndHeight = (float) h;
	wndWidth = (float) w;
	
	//glViewport(0, 0, 250, 250);
	//glMatrixMode(GL_PROJECTION);
	//glLoadIdentity();
	//glOrtho(0.0, 50.0f, 0.0, 50.0f, -1.0f, 1.0f);
	//glLoadIdentity();
	//glMatrixMode(GL_MODELVIEW);
	//glLoadIdentity();
}

//
//	CalcTriangleVertices
//
void CalcTriangleVertices(double real[], double imag[], int nRows, int nCols){
	int iRow, iCol;
	float *Mag, normReal, normImag, maxMag;
	
	Mag = (float *) malloc(sizeof(float) * nRows * nCols);
	if(Mag == NULL){
		fprintf(stderr, "Out of memory");
		exit(-1);
	}
	
	//
	//  Calculate the magnitude of each vector
	//
	maxMag = 0.0f;
	for(iRow=0; iRow < nRows; iRow++){
		for(iCol=0; iCol < nCols; iCol++){
			Mag[iRow + iCol * nRows] = (float)sqrt(
				real[iRow + iCol * nRows] * real[iRow + iCol * nRows] + 
				imag[iRow + iCol * nRows] * imag[iRow + iCol * nRows] );
			if(Mag[iRow + iCol * nRows] > maxMag)
				maxMag = Mag[iRow + iCol * nRows];
		}
	}
	
	//
	//	Calculate x and y positions of each vertex
	//
	for(iRow=0; iRow < nRows; iRow++){
		for(iCol=0; iCol < nCols; iCol++){
			
			normReal = ((float)real[iRow + iCol * nRows]) / 
				Mag[iRow + iCol * nRows];
			normImag = ((float)imag[iRow + iCol * nRows]) / 
				Mag[iRow + iCol * nRows];
			
			xTriangles[3 * (iRow + iCol * nRows)] = 
				(normReal * -0.5f + normImag * -0.25f + iCol + 1.0f);
			xTriangles[3 * (iRow + iCol * nRows) + 1] = 
				(normReal * 0.5f + iCol + 1.0f);
			xTriangles[3 * (iRow + iCol * nRows) + 2] = 
				(normReal * -0.5f + normImag * 0.25f + iCol + 1.0f);
			
			yTriangles[3 * (iRow + iCol * nRows)] = 
				(normImag * 0.5f + normReal * -0.25f + iRow + 1);
			yTriangles[3 * (iRow + iCol * nRows) + 1] = 
				(normImag * -0.5f + iRow + 1);
			yTriangles[3 * (iRow + iCol * nRows) + 2] = 
				(normImag * 0.5f + normReal * 0.25f + iRow + 1);
							
			idxColor[iRow + iCol * nRows] = (int)
				floor(Mag[iRow + iCol * nRows] / maxMag * nColors + 0.5);
			if(idxColor[iRow + iCol * nRows] > (nColors - 1))
				idxColor[iRow + iCol * nRows] = (nColors - 1);
			if(idxColor[iRow + iCol * nRows] < 0)
				idxColor[iRow + iCol * nRows] = 0;
		}
	}

			
	free(Mag);
}


//
//  Create the colormap arrays
//
void CMap_bgyor(void) {
	int iColor;
	rCMap = (float *) malloc(sizeof(float) * nColors);
	if(rCMap == NULL){
		fprintf(stderr, "Out of memory");
		exit(-1);
	}
	gCMap = (float *) malloc(sizeof(float) * nColors);
	if(gCMap == NULL){
		fprintf(stderr, "Out of memory");
		exit(-1);
	}	
	bCMap = (float *) malloc(sizeof(float) * nColors);
	if(rCMap == NULL){
		fprintf(stderr, "Out of memory");
		exit(-1);
	}
	
	idxColor = (int *) malloc(sizeof(int) * nTriangles);
	if(idxColor == NULL){
		fprintf(stderr, "Out of memory");
		exit(-1);
	}

	for(iColor=0; iColor < nColors/4; iColor++) {
		rCMap[iColor] = 0.0f;
		gCMap[iColor] = iColor / (nColors/4.0f);
		bCMap[iColor] = 1.0f;
	}
	for(iColor=nColors/4; iColor < nColors/2; iColor++) {
		rCMap[iColor] = 0.0f;
		gCMap[iColor] = 1.0f;;
		bCMap[iColor] = (nColors/2.0f - iColor) / (nColors/4.0f);
	}
	for(iColor=nColors/2; iColor < 3*nColors/4; iColor++) {
		rCMap[iColor] = (iColor - nColors/2.0f) / (nColors/4.0f);
		gCMap[iColor] = 1.0f;;
		bCMap[iColor] = 0.0f;
	}
	for(iColor=3*nColors/4; iColor < nColors; iColor++) {
		rCMap[iColor] = 1.0f;
		gCMap[iColor] = (nColors - iColor) / (nColors/4.0f);
		bCMap[iColor] = 0.0f;
	}
}

int main(int argc, char *argv[]) {
	int iRow, iCol, result;
	double *real, *imag;
	
    Matrix Field, Size;


    //
    //  Read in the field matrix in the matlab file
    //
    result = MatlabLoad(argv[1], argv[2], &Field);
    //
    //  Read in the size vector in the data file
    //
    result = MatlabLoad(argv[3], argv[4], &Size);
    
    //
    //  Copy
	nRows = (int) Size.array[0][0];
	nCols = (int) Size.array[0][1];
	nColors = 128;
	//
	//	Allocate memory for triangles
	//
	nTriangles = nRows * nCols;

	xTriangles = (GLfloat *) malloc(sizeof(GLfloat) * nTriangles * 3);
	if(xTriangles == NULL){
		fprintf(stderr, "Out of memory");
		exit(-1);
	}

	yTriangles = (GLfloat *) malloc(sizeof(GLfloat) * nTriangles * 3);
	if(yTriangles == NULL){
		fprintf(stderr, "Out of memory");
		exit(-1);
	}

	//
	//	Allocate memory for random test matrix
	//
	real = (double *) malloc(sizeof(double) * nTriangles);
	if(real == NULL){
		fprintf(stderr, "Out of memory");
		exit(-1);
	}
	imag = (double *) malloc(sizeof(double) * nTriangles);
	if(imag == NULL){
		fprintf(stderr, "Out of memory");
		exit(-1);
	}
	
	//
	//  Fill real & imaginary matrices with random data
	//
	for(iRow=0; iRow < nRows; iRow++){
		for(iCol=0; iCol < nCols; iCol++){
			real[iRow + iCol * nRows] = (double) rand() / RAND_MAX;
			imag[iRow + iCol * nRows] = (double) rand() / RAND_MAX;
		}
	}

	
	//
	//	Create colormap
	//
	CMap_bgyor();

	//
	//  Calculate the triangle vertices
	//
	CalcTriangleVertices(real, imag, nRows, nCols);

	InitializeRenderingContext(nRows, nCols);

	auxReshapeFunc(ChangeSize);
	auxMainLoop(RenderScene);
    
    return 0;
}