// DiffEq1DView.cpp : implementation of the CDiffEq1DView class
//

#include "stdafx.h"
#include "DiffEq1D.h"

#include "DiffEq1DDoc.h"
#include "DiffEq1DView.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CDiffEq1DView

IMPLEMENT_DYNCREATE(CDiffEq1DView, CView)

BEGIN_MESSAGE_MAP(CDiffEq1DView, CView)
	//{{AFX_MSG_MAP(CDiffEq1DView)
	ON_WM_CREATE()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDiffEq1DView construction/destruction

CDiffEq1DView::CDiffEq1DView()
{
	// TODO: add construction code here

}

CDiffEq1DView::~CDiffEq1DView()
{
}

BOOL CDiffEq1DView::PreCreateWindow(CREATESTRUCT& cs)
{
    //
    // Modify the window style for OpenGL use
    //
    cs.style |= (WS_CLIPCHILDREN | WS_CLIPSIBLINGS | CS_OWNDC);

	return CView::PreCreateWindow(cs);
}

/////////////////////////////////////////////////////////////////////////////
// CDiffEq1DView drawing

void CDiffEq1DView::OnDraw(CDC* pDC)
{
	CDiffEq1DDoc* pDoc = GetDocument();
	ASSERT_VALID(pDoc);

	//
    //  Render the scene, swap buffers
    //
    //GLSequence.RenderWindow();
    SwapBuffers(m_hDC);
}

/////////////////////////////////////////////////////////////////////////////
// CDiffEq1DView diagnostics

#ifdef _DEBUG
void CDiffEq1DView::AssertValid() const
{
	CView::AssertValid();
}

void CDiffEq1DView::Dump(CDumpContext& dc) const
{
	CView::Dump(dc);
}

CDiffEq1DDoc* CDiffEq1DView::GetDocument() // non-debug version is inline
{
	ASSERT(m_pDocument->IsKindOf(RUNTIME_CLASS(CDiffEq1DDoc)));
	return (CDiffEq1DDoc*)m_pDocument;
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CDiffEq1DView message handlers

int CDiffEq1DView::OnCreate(LPCREATESTRUCT lpCreateStruct) 
{
	if (CView::OnCreate(lpCreateStruct) == -1)
		return -1;
	
	int nPixelFormat;
    m_hDC = ::GetDC(m_hWnd);

    //
    //  Initialize the Pixel Format Descriptor
    //
    static PIXELFORMATDESCRIPTOR pfd;
    pfd.nSize       = sizeof(PIXELFORMATDESCRIPTOR);
    pfd.nVersion    = 1;
    pfd.dwFlags     = PFD_DRAW_TO_WINDOW | 
                      PFD_SUPPORT_OPENGL | 
                      PFD_DOUBLEBUFFER;
    pfd.iPixelType  = PFD_TYPE_RGBA;
    pfd.cColorBits  = 24;
    pfd.cRedBits    = 0;    //  These bits are not use by MS
    pfd.cRedShift   = 0;
    pfd.cBlueBits   = 0;
    pfd.cBlueShift  = 0;
    pfd.cGreenBits  = 0;
    pfd.cGreenShift = 0;
    pfd.cAlphaBits  = 0;
    pfd.cAlphaShift = 0;
    pfd.cAccumBits  = 0;
    pfd.cAccumRedBits   = 0;
    pfd.cAccumGreenBits = 0;
    pfd.cAccumBlueBits  = 0;
    pfd.cAccumAlphaBits = 0;    //  End of bits not used
    pfd.cDepthBits      = 16;
    pfd.cStencilBits    = 0;
    pfd.cAuxBuffers     = 0;
    pfd.iLayerType      = PFD_MAIN_PLANE;
    pfd.bReserved       = 0;    //
    pfd.dwLayerMask     = 0;    //  This block is also
    pfd.dwVisibleMask   = 0;    //  not used
    pfd.dwDamageMask    = 0;    //
   

    //
    //  Choose the nearest pixel format descriptor
    //
    nPixelFormat = ChoosePixelFormat(m_hDC, &pfd);
    if(nPixelFormat == 0) {
        DWORD ErrCode = GetLastError();
        MessageBox("Error choosing pixel format", NULL, MB_OK );
        return -1;
    }

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
