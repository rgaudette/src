// glmovieView.cpp : implementation of the CGlmovieView class
//

#include "stdafx.h"
#include "glmovie.h"
#include "glmovieDoc.h"
#include "glmovieView.h"
#include "GLSeq2D.h"
#include "DlgControl.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

//
//  This is the instance of the OpenGL triangle field class, declared in
//  glmovie.cpp
//
extern GLSeq2D      GLSequence;
extern CGlmovieView *pView;
extern DlgControl   *pMainControl;
/////////////////////////////////////////////////////////////////////////////
// CGlmovieView

IMPLEMENT_DYNCREATE(CGlmovieView, CView)

BEGIN_MESSAGE_MAP(CGlmovieView, CView)
	//{{AFX_MSG_MAP(CGlmovieView)
	ON_WM_CREATE()
	ON_WM_DESTROY()
	ON_WM_ERASEBKGND()
	ON_WM_SIZE()
	ON_WM_TIMER()
	//}}AFX_MSG_MAP
	// Standard printing commands
	ON_COMMAND(ID_FILE_PRINT, CView::OnFilePrint)
	ON_COMMAND(ID_FILE_PRINT_DIRECT, CView::OnFilePrint)
	ON_COMMAND(ID_FILE_PRINT_PREVIEW, CView::OnFilePrintPreview)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CGlmovieView construction/destruction

CGlmovieView::CGlmovieView()
{
    pView = this;
    StepSize = 1;
    flgForward = 1;
}

CGlmovieView::~CGlmovieView()
{
}

BOOL CGlmovieView::PreCreateWindow(CREATESTRUCT& cs)
{
	//
    // Modify the window style for OpenGL use
    //
    cs.style |= (WS_CLIPCHILDREN | WS_CLIPSIBLINGS | CS_OWNDC);

    return CView::PreCreateWindow(cs);
}

/////////////////////////////////////////////////////////////////////////////
// CGlmovieView drawing

void CGlmovieView::OnDraw(CDC* pDC)
{
	CGlmovieDoc* pDoc = GetDocument();
	ASSERT_VALID(pDoc);

    //
    //  Render the scene, swap buffers
    //
    GLSequence.RenderWindow();
    SwapBuffers(m_hDC);
}

/////////////////////////////////////////////////////////////////////////////
// CGlmovieView printing

BOOL CGlmovieView::OnPreparePrinting(CPrintInfo* pInfo)
{
	// default preparation
	return DoPreparePrinting(pInfo);
}

void CGlmovieView::OnBeginPrinting(CDC* /*pDC*/, CPrintInfo* /*pInfo*/)
{
	// TODO: add extra initialization before printing
}

void CGlmovieView::OnEndPrinting(CDC* /*pDC*/, CPrintInfo* /*pInfo*/)
{
	// TODO: add cleanup after printing
}

/////////////////////////////////////////////////////////////////////////////
// CGlmovieView diagnostics

#ifdef _DEBUG
void CGlmovieView::AssertValid() const
{
	CView::AssertValid();
}

void CGlmovieView::Dump(CDumpContext& dc) const
{
	CView::Dump(dc);
}

CGlmovieDoc* CGlmovieView::GetDocument() // non-debug version is inline
{
	ASSERT(m_pDocument->IsKindOf(RUNTIME_CLASS(CGlmovieDoc)));
	return (CGlmovieDoc*)m_pDocument;
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CGlmovieView message handlers

int CGlmovieView::OnCreate(LPCREATESTRUCT lpCreateStruct) 
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

void CGlmovieView::OnDestroy() 
{
	//
    //  Delete the OpenGL rendering context
    //
    wglMakeCurrent(NULL, NULL);
	wglDeleteContext(m_hRC);
    ::ReleaseDC(m_hWnd, m_hDC);

    CView::OnDestroy();
}

BOOL CGlmovieView::OnEraseBkgnd(CDC* pDC) 
{
	//
    //  Prevent the windows from erasing the background for each redraw
    //  This is handled by OpenGL
	//
	return FALSE;
}

void CGlmovieView::OnSize(UINT nType, int cx, int cy) 
{
	CView::OnSize(nType, cx, cy);
	
    //
	//  Call the OpenGL resizing code.
    //
    GLSequence.SetWindowSize(cx, cy);
}

void CGlmovieView::OnTimer(UINT nIDEvent) 
{
	//
    //  Increment/decrement the frame and render the window
    //
    if(flgForward)
        GLSequence.IncrementFrame(StepSize);
    else
        GLSequence.DecrementFrame(StepSize);
    //
    //  Force the main window to be redrawn
    //
    Invalidate(FALSE);

    //
    //  Update the control dialog frame index
    //
    pMainControl->UpdateFrameIdx(GLSequence.GetFrameIdx());
    
    //
    //  Reset the timer
    //
	CView::OnTimer(nIDEvent);
}

