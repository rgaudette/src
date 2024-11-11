// DlgGetArraySize.cpp : implementation file
//

#include "stdafx.h"
#include "glmovie.h"
#include "DlgGetArraySize.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// DlgGetArraySize dialog


DlgGetArraySize::DlgGetArraySize(CWnd* pParent /*=NULL*/)
	: CDialog(DlgGetArraySize::IDD, pParent)
{
	//{{AFX_DATA_INIT(DlgGetArraySize)
	nCols = 0;
	nRows = 0;
	//}}AFX_DATA_INIT
}


void DlgGetArraySize::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(DlgGetArraySize)
	DDX_Text(pDX, IDC_NCOLS, nCols);
	DDX_Text(pDX, IDC_NROWS, nRows);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(DlgGetArraySize, CDialog)
	//{{AFX_MSG_MAP(DlgGetArraySize)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// DlgGetArraySize message handlers

BOOL DlgGetArraySize::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	//
    //  Initialize the static control specifying the number of elements
    //
    CString StrNElem;
    StrNElem.Format("The number of elements in the MATLAB object is: %d", nElems);
    SetDlgItemText(IDC_NELEMS, StrNElem);
	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void DlgGetArraySize::OnOK() 
{
	//
    //  Exchange data between the controls and member variables
    //
    if(!UpdateData(TRUE)) return;

    //
    //  Check to see that the product of the rows and columns divides evenly
    //  into the number of elements.
    //
	int remainder = nElems % (nRows * nCols);
    if(remainder != 0) {
        AfxMessageBox(
            "The product of the number of rows and columns\nmust evenly divide into the number of elements",
            MB_OK|MB_OK|MB_ICONEXCLAMATION);
        return;
    }
	CDialog::OnOK();
}
