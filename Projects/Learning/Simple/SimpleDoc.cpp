// SimpleDoc.cpp : implementation of the CSimpleDoc class
//

#include "stdafx.h"
#include "Simple.h"

#include "SimpleDoc.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CSimpleDoc

IMPLEMENT_DYNCREATE(CSimpleDoc, CDocument)

BEGIN_MESSAGE_MAP(CSimpleDoc, CDocument)
	//{{AFX_MSG_MAP(CSimpleDoc)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CSimpleDoc construction/destruction

CSimpleDoc::CSimpleDoc()
{
	// TODO: add one-time construction code here

}

CSimpleDoc::~CSimpleDoc()
{
}

BOOL CSimpleDoc::OnNewDocument()
{
	if (!CDocument::OnNewDocument())
		return FALSE;

	// TODO: add reinitialization code here
	// (SDI documents will reuse this document)

	return TRUE;
}

/////////////////////////////////////////////////////////////////////////////
// CSimpleDoc serialization

void CSimpleDoc::Serialize(CArchive& ar)
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
// CSimpleDoc diagnostics

#ifdef _DEBUG
void CSimpleDoc::AssertValid() const
{
	CDocument::AssertValid();
}

void CSimpleDoc::Dump(CDumpContext& dc) const
{
	CDocument::Dump(dc);
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CSimpleDoc commands
