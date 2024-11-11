// ColorTestDoc.cpp : implementation of the CColorTestDoc class
//

#include "stdafx.h"
#include "ColorTest.h"

#include "ColorTestDoc.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CColorTestDoc

IMPLEMENT_DYNCREATE(CColorTestDoc, CDocument)

BEGIN_MESSAGE_MAP(CColorTestDoc, CDocument)
	//{{AFX_MSG_MAP(CColorTestDoc)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CColorTestDoc construction/destruction

CColorTestDoc::CColorTestDoc()
{
	// TODO: add one-time construction code here

}

CColorTestDoc::~CColorTestDoc()
{
}

BOOL CColorTestDoc::OnNewDocument()
{
	if (!CDocument::OnNewDocument())
		return FALSE;

	// TODO: add reinitialization code here
	// (SDI documents will reuse this document)

	return TRUE;
}



/////////////////////////////////////////////////////////////////////////////
// CColorTestDoc serialization

void CColorTestDoc::Serialize(CArchive& ar)
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
// CColorTestDoc diagnostics

#ifdef _DEBUG
void CColorTestDoc::AssertValid() const
{
	CDocument::AssertValid();
}

void CColorTestDoc::Dump(CDumpContext& dc) const
{
	CDocument::Dump(dc);
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CColorTestDoc commands
