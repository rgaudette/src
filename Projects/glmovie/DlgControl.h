// DlgControl.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// DlgControl dialog

class DlgControl : public CDialog
{
public:
	void SetCmplxData();
	void SetRealData();
	//
    //  Class interface methods
    //
    void SetPlotStyle(int plot_style);
    void UpdateFrameIdx(int iF);
    void UpdateStatic(int nFrames, float DataMin, float DataMax);
	void UpdateCRange(float ColorMin, float ColorMax);

    // Construction
	DlgControl(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(DlgControl)
	enum { IDD = IDD_DLGCONTROL };
	float	CMax;
	float	CMin;
	float	FrameRate;
	int		StepSize;
	int		PlotStyle;
	int		ColorMapping;
	BOOL	flgGrid;
	BOOL	flgColorBar;
	int		flgOrtho;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(DlgControl)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual void PostNcDestroy();
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(DlgControl)
	afx_msg void OnPlay();
	afx_msg void OnReverse();
	afx_msg void OnSinglestep();
	afx_msg void OnStop();
	afx_msg void OnApply();
	afx_msg void OnBkwdstep();
	afx_msg void OnReset();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

private:
	int flgTimerOn;
	int iFrame;
};
