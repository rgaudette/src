#include "stdafx.h"
#include "GLcode.h"
#include "ColorTest.h"

#define XSTARTCOEF 0.05
#define YSTARTCOEF 0.05
#define XWIDTHCOEF 0.9
#define YWIDTHCOEF 0.9

extern int WndWidth, WndHeight;
extern EPATTERN Pattern;

void RenderWindow() {
    
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
    GLint   npixXStart = (GLint) (XSTARTCOEF * WndWidth);
    GLint   npixYStart = (GLint) (YSTARTCOEF * WndHeight);
    GLsizei npixXWidth = (GLsizei) (XWIDTHCOEF * WndWidth);
    GLsizei npixYWidth = (GLsizei) (YWIDTHCOEF * WndHeight);
    glViewport(npixXStart, npixYStart, npixXWidth, npixYWidth);

    glLoadIdentity();
    
    //
    //  Set the viewing coordinates
    //
    glOrtho(0.0f, 1.0f, 0.0f, 1.0f, 1.0f, -1.0f);
    int nColors = 256;
    int iColor, iBar, nBars;
    float wRegion, wColor;
    GLfloat iLine;    
    switch(Pattern) {
    
    case(PRIMARYS):

        //
        //  Render the color strips
        //
        wRegion = 1.0f / 7.0f;
        wColor = 0.9f * wRegion;

        //
        //
        //
        for(iBar = 0; iBar < 7; iBar++) {    
            glBegin(GL_QUAD_STRIP);
            glVertex2f(iBar*wRegion, 0.0f);
            glVertex2f(iBar*wRegion+wColor, 0.0f);

            for(iColor=1; iColor <= nColors; iColor++) {
                switch(iBar) {
                case 0:
                    glColor3f(((float)iColor) / nColors, 0, 0);
                    break;
                case 1:
                    glColor3f(0, ((float)iColor) / nColors, 0);
                    break;
                case 2:
                    glColor3f(0, 0, ((float)iColor) / nColors);
                    break;
                case 3:
                    glColor3f(((float)iColor) / nColors, ((float)iColor) / nColors, 0);
                    break;
                case 4:
                    glColor3f(0, ((float)iColor) / nColors, ((float)iColor) / nColors);
                    break;
                case 5:
                    glColor3f(((float)iColor) / nColors, 0, ((float)iColor) / nColors);
                    break;

                case 6:
                    glColor3f(((float)iColor) / nColors,
                              ((float)iColor) / nColors,
                              ((float)iColor) / nColors);
                    break;

                }
                glVertex2f(iBar*wRegion, iColor/(nColors + 1.0f));
                glVertex2f(iBar*wRegion+wColor, iColor/(nColors + 1.0f));
            }
            glEnd();
        }
        break;

    case(GREYS):
        nBars = 16;
        float  Color;
        wRegion = 1.0f / nBars;
        wColor = 0.9f * wRegion;
        
        for(iBar = 0; iBar < nBars; iBar++){
            glBegin(GL_QUADS);
            Color = ((float)iBar) / nBars;
            glColor3f(Color, Color, Color);
            glVertex2f(iBar*wRegion, 0.0f);
            glVertex2f(iBar*wRegion+wColor, 0.0f);
            glVertex2f(iBar*wRegion+wColor, 1.0f);
            glVertex2f(iBar*wRegion, 1.0f);
            glEnd();
        }
        break;
    case(RGB):
        
        break;
    
    case(HZLINES1):
        glOrtho(0, npixXWidth, 0, npixYWidth, 1.0f, -1.0f);
        glLineWidth((GLfloat) 0.0001);

        glBegin(GL_LINES);
        glColor3f(1.0f, 1.0f, 1.0f);
        for(iLine = (GLfloat) npixYStart; iLine <= npixYWidth; iLine = iLine + 2.0f) {
            glVertex2f((GLfloat) npixXStart, (GLfloat) iLine);
            glVertex2f((GLfloat) npixXWidth, (GLfloat) iLine);
        }
        glEnd();
        break;
    
    case(VTLINES1):
        glOrtho(0, npixXWidth, 0, npixYWidth, 1.0f, -1.0f);
        glLineWidth((GLfloat) 0.05);
        glBegin(GL_LINES);
        glColor3f(1.0f, 1.0f, 1.0f);
        for(iLine = (GLfloat) npixXStart; iLine <= npixXWidth; iLine = iLine + 2.0f) {
            glVertex2f((GLfloat) iLine, (GLfloat) npixYStart);
            glVertex2f((GLfloat) iLine, (GLfloat) npixYWidth);
        }
        glEnd();
        break;
    
    case(PAT_POINTS):
        glOrtho(1, npixXWidth, 1, npixYWidth, 1.0f, -1.0f);
        GLfloat iX, iY;
        glBegin(GL_POINTS);
        glColor3f(1.0f, 1.0f, 1.0f);
        for(iX = (GLfloat) npixXStart; iX <= npixXWidth; iX = iX + 4.0f) {
            for(iY = (GLfloat) npixYStart; iY <= npixYWidth; iY = iY + 4.0f) {
                glVertex2f(iX, iY);
            }
        }
        glEnd();
        break;
    }
 
    glFlush();
}