// ColorTestView.cpp : implementation of the CColorTestView class
//

#include "stdafx.h"
#include "ColorTest.h"

#include "ColorTestDoc.h"
#include "ColorTestView.h"
#include "GLcode.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

extern int WndWidth, WndHeight;
extern EPATTERN Pattern;

/////////////////////////////////////////////////////////////////////////////
// CColorTestView

IMPLEMENT_DYNCREATE(CColorTestView, CView)

BEGIN_MESSAGE_MAP(CColorTestView, CView)
	//{{AFX_MSG_MAP(CColorTestView)
	ON_WM_CREATE()
	ON_WM_DESTROY()
	ON_WM_ERASEBKGND()
	ON_WM_SIZE()
	ON_COMMAND(ID_PATTERNS_PRIMARYANDSECONDARY, OnPatternsPrimaryandsecondary)
	ON_COMMAND(ID_PATTERNS_GREY, OnPatternsGrey)
	ON_COMMAND(ID_PATTERNS_RGBSCALES, OnPatternsRgbscales)
	ON_COMMAND(ID_PATTERNS_HORIZONTALLINES1PIXEL, OnPatternsHorizontalLines1pixel)
	ON_COMMAND(ID_PATTERNS_VERTICALLINES1PIXEL, OnPatternsVerticalLines1pixel)
	ON_COMMAND(ID_PATTERNS_POINTS, OnPatternsPoints)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CColorTestView construction/destruction

CColorTestView::CColorTestView()
{
	// TODO: add construction code here

}

CColorTestView::~CColorTestView()
{
}

BOOL CColorTestView::PreCreateWindow(CREATESTRUCT& cs)
{
	//
    // Modify the window style for OpenGL use
    //
    cs.style |= (WS_CLIPCHILDREN | WS_CLIPSIBLINGS | CS_OWNDC);





	return CView::PreCreateWindow(cs);
}

/////////////////////////////////////////////////////////////////////////////
// CColorTestView drawing

void CColorTestView::OnDraw(CDC* pDC)
{
	CColorTestDoc* pDoc = GetDocument();
	ASSERT_VALID(pDoc);

    //
    //  Render the scene, swap buffers
    //
    RenderWindow();
    SwapBuffers(m_hDC);
}

/////////////////////////////////////////////////////////////////////////////
// CColorTestView diagnostics

#ifdef _DEBUG
void CColorTestView::AssertValid() const
{
	CView::AssertValid();
}

void CColorTestView::Dump(CDumpContext& dc) const
{
	CView::Dump(dc);
}

CColorTestDoc* CColorTestView::GetDocument() // non-debug version is inline
{
	ASSERT(m_pDocument->IsKindOf(RUNTIME_CLASS(CColorTestDoc)));
	return (CColorTestDoc*)m_pDocument;
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CColorTestView message handlers

int CColorTestView::OnCreate(LPCREATESTRUCT lpCreateStruct) 
{
	if (CView::OnCreate(lpCreateStruct) == -1)
		return -1;
	
	int nPixelFormat;
    m_hDC = ::GetDC(m_hWnd);

    //
    //  Initialize the Pixel Format Descriptor
    //
    static PIXELFORMATDESCRIPTOR pfd = {
        sizeof(PIXELFORMATDESCRIPTOR),
        1,
        PFD_DRAW_TO_WINDOW |
        PFD_SUPPORT_OPENGL |
        PFD_DOUBLEBUFFER,
        PFD_TYPE_RGBA,
        24,
        0,0,0,0,0,0,
        0,0,
        0,0,0,0,0,
        16,
        0,0,
        PFD_MAIN_PLANE,
        0,0,0,0
    };

    //
    //  Choose the nearest pixel format descriptor
    //
    nPixelFormat = ChoosePixelFormat(m_hDC, &pfd);

    //
    //  Set the pixel format for the DC
    //
    VERIFY(SetPixelFormat(m_hDC, nPixelFormat, &pfd));

    //
    //  Create the rendering context and do any intitialization
    //
    m_hRC = wglCreateContext(m_hDC);
    VERIFY(wglMakeCurrent(m_hDC, m_hRC));
        
	return 0;
}

void CColorTestView::OnDestroy() 
{
	CView::OnDestroy();
	
	//
    //  Delete the OpenGL rendering context
    //
    wglMakeCurrent(NULL, NULL);
	wglDeleteContext(m_hRC);
    ::ReleaseDC(m_hWnd, m_hDC);


	
}

BOOL CColorTestView::OnEraseBkgnd(CDC* pDC) 
{
	//
    //  Prevent the windows from erasing the background for each redraw
    //  This is handled by OpenGL
	//
	return FALSE;
}

void CColorTestView::OnSize(UINT nType, int cx, int cy) 
{
	CView::OnSize(nType, cx, cy);
	
    //
	//  Call the OpenGL resizing code.
    //
    WndWidth = cx;
    WndHeight = cy;
}

void CColorTestView::OnPatternsPrimaryandsecondary() 
{
	Pattern = PRIMARYS;
	Invalidate(FALSE);
}

void CColorTestView::OnPatternsGrey() 
{
	Pattern = GREYS;
    Invalidate(FALSE);
}

void CColorTestView::OnPatternsRgbscales() 
{
	Pattern = RGB;
    Invalidate(FALSE);
}

void CColorTestView::OnPatternsHorizontalLines1pixel() 
{
	Pattern = HZLINES1;
    Invalidate(FALSE);
	
}

void CColorTestView::OnPatternsVerticalLines1pixel() 
{
	Pattern = VTLINES1;
    Invalidate(FALSE);	
}

void CColorTestView::OnPatternsPoints() 
{
	Pattern = PAT_POINTS;
    Invalidate(FALSE);
	
}
