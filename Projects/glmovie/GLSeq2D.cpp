#include "stdafx.h"
#include "GLSeq2D.h"

#include <math.h>
#include <float.h>

//
//  Contructor for the GLSeq2D class
//
GLSeq2D::GLSeq2D() {
    //
    //  Initialize the triangle arrays NULL for first call to
    //  SetFieldSize
    //
    xVertices = NULL;
    yVertices = NULL;
    idxColor = NULL;

    //
    //  Default state of the view
    //
    nColors = 256;
    flgDataSet = FALSE;
    DisplayType = DT_COLORMAP;
    flgShowGrid = TRUE;
    flgShowColorBar = TRUE;
    flgOrtho = TRUE;

    //
    //  Create the colormap arrays;
    //
    rCMap = NULL;
    gCMap = NULL;
    bCMap = NULL;
    CmapType = 0;   
    CMap_bgyor();
}

//
//  Destructor for the GLSeq2D class
//
GLSeq2D::~GLSeq2D() {
    //
    //  delete memory resources
    //
    delete[] xVertices;
    delete[] yVertices;
    delete[] idxColor;
    delete[] bCMap;
    delete[] gCMap;
    delete[] rCMap;
}

//
//  (Re)set the array size and number of frames for the sequence
//
void GLSeq2D::SetFieldSize(int nr, int nc, int nf) {
    nRows = nr;
    nCols = nc;
    nFrames = nf;
    nElements = nr * nc;

    //
    //  Reallocate the vertices matrices
    //
    ReallocVertices();

    //
    //  Delete any allocated memory for the element color and reallocate
    //
    delete[] idxColor;
    idxColor = new int[nElements];
}

//
//  Update the real and imaginary array pointers
//  - recalculate the range
//
void GLSeq2D::UpdateData(const float *reVector, const float *imVector) {
    if(reVector != NULL)
        real = reVector;
    imag = imVector;

    flgDataSet = TRUE;
    CalcRange();
}

void GLSeq2D::SetWindowSize(int cx, int cy) {
    WndWidth = cx;
    WndHeight = cy;
}

void GLSeq2D::RenderWindow(void) {
    
    //
    //  Clear the window
    //
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);//| GL_DEPTH_BUFFER_BIT);

    //
    //  Set up the appropriate modes
    //
    glShadeModel(GL_FLAT);
    glPolygonMode(GL_FRONT, GL_FILL);
    glHint(GL_LINE_SMOOTH_HINT, GL_FASTEST);
    glHint(GL_POLYGON_SMOOTH_HINT, GL_FASTEST);

    //
    //  Set the viewport
    //
    SetView();
    
    //
    //  Render the grid and triangles
    //
    if(flgDataSet) {
        if(DisplayType == DT_TRIFIELD) {
            CalcTriangleVertices();
            RenderTriangles();
        }
        if(DisplayType == DT_COLORMAP) {
            CalcCMapVertices();
            RenderColorMap();
        }
        if(flgShowGrid)
            RenderGrid();
        if(flgShowColorBar)
            RenderColorBar();
    }

    glFlush();
}

void GLSeq2D::SetView(void) {
    
    //
    //  Setup the viewport in the window for the array
    //
    GLint VPWidth;

    if(flgShowColorBar)
        VPWidth = (GLint) (VIEWPORT_XWDTH * WndWidth);    
    else
        VPWidth = (GLint) ((VIEWPORT_XWDTH + VIEWPORT_CBWIDTH + VIEWPORT_XSPC) * 
            WndWidth);
    glViewport((GLint) (VIEWPORT_XMIN * WndWidth), 
               (GLint) (VIEWPORT_YMIN * WndHeight), 
               VPWidth,
               (GLsizei) (VIEWPORT_YWDTH * WndHeight));

    glLoadIdentity();

    //
    //  Create a orthographic viewing tranformation such that the
    //  spacing between nodes in x and y is equvalent.
    //    
    if(flgOrtho) {
        float VPAspectRatio, DataAspectRatio, ScaleCoeff, Offset;
        VPAspectRatio = VIEWPORT_YWDTH * WndHeight /
                       (VIEWPORT_XWDTH * WndWidth);
        DataAspectRatio = (nRows + 1.0f) / (nCols + 1.0f);
    
        if(DataAspectRatio < VPAspectRatio) {
            ScaleCoeff = VPAspectRatio / DataAspectRatio;
            Offset = -0.5f * (nRows + 1.0f) * (ScaleCoeff - 1.0f);
            glOrtho(0, nCols + 1.0f, 
                (nRows + 1.0f) * ScaleCoeff, Offset,
                1.0f, -1.0f);
        }
        else {
            ScaleCoeff = DataAspectRatio / VPAspectRatio;
            Offset = -0.5f * (nCols + 1.0f) * (ScaleCoeff - 1.0f);
            glOrtho(Offset, (nCols + 1.0f) * ScaleCoeff, 
                nRows + 1.0f, 0,
                1.0f, -1.0f);
        }
    }
    
    //
    //  Fill the viewing volume with the image
    //
    else
        glOrtho(0, nCols + 1.0f, nRows + 1.0f, 0, 1.0f, -1.0f);

}

void GLSeq2D::RenderTriangles(void) {

    int iTri;
    
    glBegin(GL_TRIANGLES);

        for(iTri=0; iTri < nElements; iTri++){

            //
            //  This is actually prone to bugs because it assumes that the 
            //  first color in the colormap is black
            //
            if(idxColor[iTri] != 0) {
                //
                //  Set the color
                //
                glColor3f(rCMap[idxColor[iTri]], gCMap[idxColor[iTri]], 
                    bCMap[idxColor[iTri]]);

                //
                //  Draw the triangle
                //
                glVertex2f(xVertices[3*iTri], yVertices[3*iTri]);
                glVertex2f(xVertices[3*iTri+1], yVertices[3*iTri+1]);
                glVertex2f(xVertices[3*iTri+2], yVertices[3*iTri+2]);
            }
        }

    glEnd();
    glFlush();
}

//
//  CalcTriangleVertices
//
void GLSeq2D::CalcTriangleVertices(void){
    int     iRow, iCol;
    int     offFrame, offCol, offFull, offVertex;
    float   Mag, normReal, normImag, ColorRange;

    ColorRange = Cmax - Cmin;

    //
    //  Loop over the whole frame computing
    //  - magnitude
    //  - normalized vector
    //  - triangle vetices
    //  - color index for each triangle
    //
    offFrame = idxFrame * nElements;
    for(iCol=0; iCol < nCols; iCol++){
        offCol = iCol * nRows;
        offFull = offCol + offFrame;    
        for(iRow=0; iRow < nRows; iRow++){
        
            //
            //  Calculate the magnitude of the current element
            //

            Mag = (float)sqrt(
               real[iRow + offFull] * real[iRow + offFull] +
               imag[iRow + offFull] * imag[iRow + offFull] );


            normReal = real[iRow + offFull] / Mag;
            normImag = imag[iRow + offFull] / Mag;

            //
            //  Calculate the vertices of the current element
            //  Drawn CCW
            //
            offVertex = 3 * (iRow + offCol);
            

            xVertices[offVertex] = 
                normReal * -0.5f + normImag * -0.25f + iCol + 1.0f;
            yVertices[offVertex] = 
                normImag * 0.5f + normReal * -0.25f + iRow + 1.0f;
            
            xVertices[offVertex + 1] = 
                normReal * 0.5f + iCol + 1.0f;
            yVertices[offVertex + 1] = 
                normImag * -0.5f + iRow + 1.0f;
            
            xVertices[offVertex + 2] = 
                normReal * -0.5f + normImag * 0.25f + iCol + 1.0f;
            yVertices[offVertex + 2] = 
                normImag * 0.5f + normReal * 0.25f + iRow + 1.0f;

            //
            //  Calculate the color of the current element
            //
            idxColor[iRow + offCol] = (int)
                floor((Mag - Cmin) / ColorRange * nColors + 0.5);
    
            //
            //  Range check the color
            //
            if(idxColor[iRow + offCol] > (nColors - 1))
                idxColor[iRow + offCol] = (nColors - 1);
            if(idxColor[iRow + offCol] < 0)
                idxColor[iRow + offCol] = 0;
        }
    }
}

//
//  CalcBlockVertices
//
void GLSeq2D::CalcCMapVertices(void){
    int     iRow, iCol;
    int     offFrame, offCol, offFull, offVertex;
    float   Mag, ColorRange;

    ColorRange = Cmax - Cmin;

    //
    //Loop over the whole frame computing
    //  - magnitude
    //  - color index for each pixel
    //
    offFrame = idxFrame * nElements;
    for(iCol=0; iCol < nCols; iCol++){
        offCol = iCol * nRows;
        offFull = offCol + offFrame;    
        for(iRow=0; iRow < nRows; iRow++){
        
            //
            //  Calculate the magnitude of the current element
            //
            if(imag != NULL)
                Mag = (float)sqrt(
                    real[iRow + offFull] * real[iRow + offFull] +
                    imag[iRow + offFull] * imag[iRow + offFull] );
            else
                Mag = (float) real[iRow + offFull];

            //
            //  Calculate the vertices of the current element
            //  Drawn CCW
            //
            offVertex = 4 * (iRow + offCol);
            
            xVertices[offVertex] = iCol + 0.5F ;
            yVertices[offVertex] = iRow + 0.5F;
            
            xVertices[offVertex + 1] = iCol + 1.5F;
            yVertices[offVertex + 1] = iRow + 0.5F;
            
            xVertices[offVertex + 2] = iCol + 1.5F;
            yVertices[offVertex + 2] = iRow + 1.5F;
            
            xVertices[offVertex + 3] = iCol + 0.5F;
            yVertices[offVertex + 3] = iRow + 1.5F;
            
            //
            //  Calculate the color of the current element
            //
            idxColor[iRow + offCol] = (int)
                floor((Mag - Cmin) / ColorRange * nColors + 0.5);
    
            //
            //  Range check the color
            //
            if(idxColor[iRow + offCol] > (nColors - 1))
                idxColor[iRow + offCol] = (nColors - 1);
            if(idxColor[iRow + offCol] < 0)
                idxColor[iRow + offCol] = 0;
        }
    }
}

//
//  Draw the colorbar
//
void GLSeq2D::RenderColorBar(void) {

    int iColor;

    glPushMatrix();
    
    //
    //  Set the viewport and orthographic volume for the colorbar
    //
    glViewport( (GLint)((VIEWPORT_XMIN+VIEWPORT_XWDTH+VIEWPORT_XSPC)*WndWidth),
                (GLint)(VIEWPORT_YMIN * WndHeight),
                (GLsizei)(VIEWPORT_CBWIDTH * WndWidth),
                (GLsizei)(VIEWPORT_YWDTH * WndHeight) );
    
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

//
//  Create the colormap arrays
//
void GLSeq2D::CMap_bgyor(void) {
    int iColor;
    
    if(rCMap == NULL) {
        rCMap = new float[nColors];
        gCMap = new float[nColors];
        bCMap = new float[nColors];
    }

    if(CmapType == 0){
        //
        //  Blue-green-yellow-orange-red colormap
        //
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
    else {
        //
        //  Grey scale colormap
        //
        for(iColor = 1; iColor < nColors; iColor++) {
            rCMap[iColor] = (1.0F * iColor) / nColors;
            gCMap[iColor] = (1.0F * iColor) / nColors;
            bCMap[iColor] = (1.0F * iColor) / nColors;
        }
    }

    //
    //  Make sure the first color is black
    //
    rCMap[0] = 0.0f;
    gCMap[0] = 0.0f;
    bCMap[0] = 0.0f;
}

void GLSeq2D::RenderGrid(void) {

    glColor3f(0.5f, 0.5f, 0.5f);
    //
    //  Draw a box around the array
    //
    glBegin(GL_LINE_STRIP);
        glVertex3f(0.0f, 0.0f, 0.0f);
        glVertex3f(nCols + 1.0f, 0.0f, 0.0f);
        glVertex3f(nCols + 1.0f, nRows + 1.0f, 0.0f);
        glVertex3f(0.0f, nRows + 1.0f, 0.0f);
        glVertex3f(0.0f, 0.0f, 0.0f);
    glEnd();

    //
    //  Draw grid lines
    //
    glEnable(GL_LINE_STIPPLE);
    glLineStipple(1, (GLushort) 0x5555);
    
    glBegin(GL_LINES);
        int iRow, iCol;    
        for(iRow = 1; iRow <= nRows; iRow++) {
            glVertex2i(0,iRow);
            glVertex2i(nCols+1, iRow);
        }
        for(iCol = 1; iCol <= nCols; iCol++) {
            glVertex2i(iCol,0);
            glVertex2i(iCol, nRows+1);
        }
    
    glEnd();
    glDisable(GL_LINE_STIPPLE);
}
 
//
//  Increment the frame index
//
void GLSeq2D::IncrementFrame(int StepSize)
{
    idxFrame += StepSize;
    if(idxFrame >= nFrames) idxFrame = idxFrame % nFrames;
}

//
//  Decrement the frame index
//
void GLSeq2D::DecrementFrame(int StepSize)
{
    idxFrame -= StepSize;
    if(idxFrame < 0 ) idxFrame = (idxFrame + nFrames) % nFrames;
}


//
//  Reset the frame index to the begining of the sequence
//
void GLSeq2D::ResetFrame()
{
    idxFrame = 0;
}

void GLSeq2D::CalcRange()
{
    int iFrame, offFrame, iCol, offCol, iRow;
    float Mag;
    //
    //  Calculate the magnitude of each vector in the sequence
    //
    maxData = -1*FLT_MIN;
    minData = FLT_MAX;
    if(imag != NULL) {
        for(iFrame=0; iFrame < nFrames; iFrame++) {
            offFrame = iFrame * nElements;
            for(iCol=0; iCol < nCols; iCol++) { 
                offCol = iCol * nRows + offFrame;
                for(iRow=0; iRow < nRows; iRow++) {
                    Mag = (float)sqrt(
                        real[iRow + offCol] * real[iRow + offCol] +
                        imag[iRow + offCol] * imag[iRow + offCol] );
                    if(Mag > maxData) maxData = Mag;
                    if(Mag < minData) minData = Mag;
                }
            }
        }
    }
    else {
        for(iFrame=0; iFrame < nFrames; iFrame++) {
            offFrame = iFrame * nElements;
            for(iCol=0; iCol < nCols; iCol++) { 
                offCol = iCol * nRows + offFrame;
                for(iRow=0; iRow < nRows; iRow++) {
                    Mag = real[iRow + offCol];
                    if(Mag > maxData) maxData = Mag;
                    if(Mag < minData) minData = Mag;
                }
            }
        }
    }

}

void GLSeq2D::SetCRange(float ColorMin, float ColorMax)
{
    Cmin = ColorMin;
    Cmax = ColorMax;
}

void GLSeq2D::SetCMapType(int cmt)
{
    //
    //  Set the colormap type member
    //
    CmapType = cmt;

    //
    //  Update the colormap
    //
    CMap_bgyor();
}

float GLSeq2D::GetDataMin()
{
    return minData;
}

float GLSeq2D::GetDataMax()
{
    return maxData;
}

void GLSeq2D::ReallocVertices()
{
    //
    //  Delete the current vertex arrays and re-allocate according to the selected display type
    //
    delete[] xVertices;
    delete[] yVertices;
    switch(DisplayType) {
    case DT_TRIFIELD:
        xVertices = new GLfloat[3*nElements];
        yVertices = new GLfloat[3*nElements];
        break;
    case DT_COLORMAP:
        xVertices = new GLfloat[4*nElements];
        yVertices = new GLfloat[4*nElements];
        break;
    }
}

void GLSeq2D::RenderColorMap()
{
    int iQuad;
    
    glBegin(GL_QUADS);

        for(iQuad=0; iQuad < nElements; iQuad++){

            glColor3f(rCMap[idxColor[iQuad]], gCMap[idxColor[iQuad]], 
                bCMap[idxColor[iQuad]]);

            glVertex2f(xVertices[4*iQuad], yVertices[4*iQuad]);
            glVertex2f(xVertices[4*iQuad+1], yVertices[4*iQuad+1]);
            glVertex2f(xVertices[4*iQuad+2], yVertices[4*iQuad+2]);
            glVertex2f(xVertices[4*iQuad+3], yVertices[4*iQuad+3]);
        }

    glEnd();
    glFlush();

}


int GLSeq2D::GetFrameIdx()
{
    return idxFrame;
}

void GLSeq2D::SetGridFlag(int fsg)
{
    flgShowGrid = fsg;
}

void GLSeq2D::SetColorBarFlag(int cbf)
{
    flgShowColorBar = cbf;
}

void GLSeq2D::SetDisplayType(int dt)
{
    DisplayType = (DTYPE) dt;
}

void GLSeq2D::SetViewOrtho()
{
    flgOrtho = TRUE;
}

void GLSeq2D::SetViewFill()
{
    flgOrtho = FALSE;
}
