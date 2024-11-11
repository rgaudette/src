// DiffEq1DDoc.cpp : implementation of the CDiffEq1DDoc class
//

#include "stdafx.h"
#include "DiffEq1D.h"

#include "DiffEq1DDoc.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CDiffEq1DDoc

IMPLEMENT_DYNCREATE(CDiffEq1DDoc, CDocument)

BEGIN_MESSAGE_MAP(CDiffEq1DDoc, CDocument)
	//{{AFX_MSG_MAP(CDiffEq1DDoc)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDiffEq1DDoc construction/destruction

CDiffEq1DDoc::CDiffEq1DDoc()
{
	//
    //  Allocate memory for data vectors
    //
    nElements = 500;
    xVec = new GLfloat[nElements];
    yVec = new GLfloat[nElements];
    yPrevVec = new GLfloat[nElements];


    //
    //  Initialize the domain vector
    //
    for(int i=1; i < nElements; i++) {
        xVec[i] = xVec[i-1] + XDiff;
    }

    //
    //  Set up the boundary conditions
    //
    yLeftBC = 1;
    yRightBC = 0;
    yPrevVec[0] = yLeftBC;
    yPrevVec[nElements] = yLeftBC;
}

CDiffEq1DDoc::~CDiffEq1DDoc()
{
}

BOOL CDiffEq1DDoc::OnNewDocument()
{
//	if (!CDocument::OnNewDocument())
//		return FALSE;

    while(IsConverged()) {
        Step();
        RenderPlot();

	return TRUE;
}

/////////////////////////////////////////////////////////////////////////////
// CDiffEq1DDoc serialization

void CDiffEq1DDoc::Serialize(CArchive& ar)
{
	if (ar.IsStoring())
	{
		// TODO: add storing code here
	}
	else
	{
		// TODO: add loading code here
	}
}

/////////////////////////////////////////////////////////////////////////////
// CDiffEq1DDoc diagnostics

#ifdef _DEBUG
void CDiffEq1DDoc::AssertValid() const
{
	CDocument::AssertValid();
}

void CDiffEq1DDoc::Dump(CDumpContext& dc) const
{
	CDocument::Dump(dc);
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CDiffEq1DDoc commands
