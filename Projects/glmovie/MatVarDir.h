// MatVarDir.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// MatVarDir dialog
#include <mat.h>

class MatVarDir : public CDialog
{
// Construction
public:

	MATFile *fptrMatfile;
	CString SelectedVar;
	MatVarDir(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(MatVarDir)
	enum { IDD = IDD_MATFILEDIR };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(MatVarDir)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(MatVarDir)
	virtual void OnOK();
	virtual BOOL OnInitDialog();
	afx_msg void OnDblclkMatvarlist();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	void GetSelectedVar();
};
