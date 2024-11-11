// 3dviewDoc.cpp : implementation of the CMy3dviewDoc class
//

#include "stdafx.h"
#include "3dview.h"

#include "3dviewDoc.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CMy3dviewDoc

IMPLEMENT_DYNCREATE(CMy3dviewDoc, CDocument)

BEGIN_MESSAGE_MAP(CMy3dviewDoc, CDocument)
	//{{AFX_MSG_MAP(CMy3dviewDoc)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMy3dviewDoc construction/destruction

CMy3dviewDoc::CMy3dviewDoc()
{
	// TODO: add one-time construction code here

}

CMy3dviewDoc::~CMy3dviewDoc()
{
}

BOOL CMy3dviewDoc::OnNewDocument()
{
	if (!CDocument::OnNewDocument())
		return FALSE;

	// TODO: add reinitialization code here
	// (SDI documents will reuse this document)

	return TRUE;
}



/////////////////////////////////////////////////////////////////////////////
// CMy3dviewDoc serialization

void CMy3dviewDoc::Serialize(CArchive& ar)
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
// CMy3dviewDoc diagnostics

#ifdef _DEBUG
void CMy3dviewDoc::AssertValid() const
{
	CDocument::AssertValid();
}

void CMy3dviewDoc::Dump(CDumpContext& dc) const
{
	CDocument::Dump(dc);
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CMy3dviewDoc commands
