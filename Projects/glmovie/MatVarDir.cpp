// MatVarDir.cpp : implementation file
//

#include "stdafx.h"
#include "glmovie.h"
#include "MatVarDir.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// MatVarDir dialog


MatVarDir::MatVarDir(CWnd* pParent /*=NULL*/)
	: CDialog(MatVarDir::IDD, pParent)
{
	//{{AFX_DATA_INIT(MatVarDir)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void MatVarDir::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(MatVarDir)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(MatVarDir, CDialog)
	//{{AFX_MSG_MAP(MatVarDir)
	ON_LBN_DBLCLK(IDC_MATVARLIST, OnDblclkMatvarlist)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// MatVarDir message handlers

void MatVarDir::OnOK() 
{
    GetSelectedVar();
	CDialog::OnOK();
}


BOOL MatVarDir::OnInitDialog() 
{
    
    CDialog::OnInitDialog();
    
    //
    //  Get the a pointer to the ListBox from the dialog box.
    //
    CListBox *pLBMatDir = (CListBox *) GetDlgItem(IDC_MATVARLIST);
    
    mxArray *MatArray;
    CString strDirEntry, strDimensions, strTemp;
    int iDim, nDim;
    const int *vDim;
    while(MatArray = matGetNextArrayHeader(fptrMatfile)) {
        //
        //  Get the description of the current array
        //
        nDim = mxGetNumberOfDimensions(MatArray);
        vDim = mxGetDimensions(MatArray);
        strDimensions.Format("%d", vDim[0]);
        for(iDim = 1; iDim < nDim; iDim++) {
            strDimensions += "x";
            strTemp.Format("%d", vDim[iDim]);
            strDimensions += strTemp;
        }
        strDirEntry.Format("%-40s\t%10s\t%32s",mxGetName(MatArray), 
            strDimensions, mxGetClassName(MatArray));
        pLBMatDir->AddString(strDirEntry.GetBuffer(0));
        
        mxFree(MatArray);
    }
	

   
	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void MatVarDir::OnDblclkMatvarlist() 
{
    GetSelectedVar();
    EndDialog(IDOK);
	
}

void MatVarDir::GetSelectedVar()
{
    //
    //  Get selected variable from list, copy into SelectedVar member.
    //
    CListBox *pLBMatDir = (CListBox *) GetDlgItem(IDC_MATVARLIST);
    int idxSelect = pLBMatDir->GetCurSel();
    if(idxSelect == LB_ERR) {
        AfxMessageBox("A MATLAB object must be selected", 
            MB_OK|MB_OK|MB_ICONEXCLAMATION);
        return;
    }
    else {
        pLBMatDir->GetText(idxSelect, SelectedVar.GetBuffer(256));
        SelectedVar.ReleaseBuffer();
        SelectedVar = SelectedVar.Left(40);
        SelectedVar.TrimRight();
    }


}
