// DlgGetArraySize.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// DlgGetArraySize dialog

class DlgGetArraySize : public CDialog
{
// Construction
public:
	int nElems;
	DlgGetArraySize(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(DlgGetArraySize)
	enum { IDD = IDD_GETARRAYSIZE };
	int		nCols;
	int		nRows;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(DlgGetArraySize)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(DlgGetArraySize)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};
