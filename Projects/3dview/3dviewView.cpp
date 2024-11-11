// 3dviewView.cpp : implementation of the CMy3dviewView class
//

#include "stdafx.h"
#include "3dview.h"

#include "3dviewDoc.h"
#include "3dviewView.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CMy3dviewView

IMPLEMENT_DYNCREATE(CMy3dviewView, CView)

BEGIN_MESSAGE_MAP(CMy3dviewView, CView)
	//{{AFX_MSG_MAP(CMy3dviewView)
	ON_WM_CREATE()
	ON_WM_DESTROY()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMy3dviewView construction/destruction

CMy3dviewView::CMy3dviewView()
{
	// TODO: add construction code here

}

CMy3dviewView::~CMy3dviewView()
{
}

BOOL CMy3dviewView::PreCreateWindow(CREATESTRUCT& cs)
{
	//
    // Modify the window style for OpenGL use
    //
    cs.style |= (WS_CLIPCHILDREN | WS_CLIPSIBLINGS | CS_OWNDC);

  	return CView::PreCreateWindow(cs);
}

/////////////////////////////////////////////////////////////////////////////
// CMy3dviewView drawing

void CMy3dviewView::OnDraw(CDC* pDC)
{
	CMy3dviewDoc* pDoc = GetDocument();
	ASSERT_VALID(pDoc);

    //
    //  Render the scene, swap buffers
    //
    GLSequence.RenderWindow();
    SwapBuffers(m_hDC);
}

/////////////////////////////////////////////////////////////////////////////
// CMy3dviewView diagnostics

#ifdef _DEBUG
void CMy3dviewView::AssertValid() const
{
	CView::AssertValid();
}

void CMy3dviewView::Dump(CDumpContext& dc) const
{
	CView::Dump(dc);
}

CMy3dviewDoc* CMy3dviewView::GetDocument() // non-debug version is inline
{
	ASSERT(m_pDocument->IsKindOf(RUNTIME_CLASS(CMy3dviewDoc)));
	return (CMy3dviewDoc*)m_pDocument;
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CMy3dviewView message handlers

int CMy3dviewView::OnCreate(LPCREATESTRUCT lpCreateStruct) 
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

void CMy3dviewView::OnDestroy() 
{
	CView::OnDestroy();
	
	//
    //  Delete the OpenGL rendering context
    //
    wglMakeCurrent(NULL, NULL);
	wglDeleteContext(m_hRC);
    ::ReleaseDC(m_hWnd, m_hDC);
}
