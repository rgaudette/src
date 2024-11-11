// SimpleView.cpp : implementation of the CSimpleView class
//

#include "stdafx.h"
#include "Simple.h"

#include "SimpleDoc.h"
#include "SimpleView.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CSimpleView

IMPLEMENT_DYNCREATE(CSimpleView, CView)

BEGIN_MESSAGE_MAP(CSimpleView, CView)
	//{{AFX_MSG_MAP(CSimpleView)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG_MAP
	// Standard printing commands
	ON_COMMAND(ID_FILE_PRINT, CView::OnFilePrint)
	ON_COMMAND(ID_FILE_PRINT_DIRECT, CView::OnFilePrint)
	ON_COMMAND(ID_FILE_PRINT_PREVIEW, CView::OnFilePrintPreview)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CSimpleView construction/destruction

CSimpleView::CSimpleView()
{
	// TODO: add construction code here

}

CSimpleView::~CSimpleView()
{
}

BOOL CSimpleView::PreCreateWindow(CREATESTRUCT& cs)
{
	// TODO: Modify the Window class or styles here by modifying
	//  the CREATESTRUCT cs

	return CView::PreCreateWindow(cs);
}

/////////////////////////////////////////////////////////////////////////////
// CSimpleView drawing

void CSimpleView::OnDraw(CDC* pDC)
{
	CSimpleDoc* pDoc = GetDocument();
	ASSERT_VALID(pDoc);

	// TODO: add draw code for native data here
}

/////////////////////////////////////////////////////////////////////////////
// CSimpleView printing

BOOL CSimpleView::OnPreparePrinting(CPrintInfo* pInfo)
{
	// default preparation
	return DoPreparePrinting(pInfo);
}

void CSimpleView::OnBeginPrinting(CDC* /*pDC*/, CPrintInfo* /*pInfo*/)
{
	// TODO: add extra initialization before printing
}

void CSimpleView::OnEndPrinting(CDC* /*pDC*/, CPrintInfo* /*pInfo*/)
{
	// TODO: add cleanup after printing
}

/////////////////////////////////////////////////////////////////////////////
// CSimpleView diagnostics

#ifdef _DEBUG
void CSimpleView::AssertValid() const
{
	CView::AssertValid();
}

void CSimpleView::Dump(CDumpContext& dc) const
{
	CView::Dump(dc);
}

CSimpleDoc* CSimpleView::GetDocument() // non-debug version is inline
{
	ASSERT(m_pDocument->IsKindOf(RUNTIME_CLASS(CSimpleDoc)));
	return (CSimpleDoc*)m_pDocument;
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CSimpleView message handlers
