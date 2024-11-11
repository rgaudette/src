// glmovieView.h : interface of the CGlmovieView class
//
/////////////////////////////////////////////////////////////////////////////

class CGlmovieView : public CView
{
public:
    HGLRC   m_hRC;          // Rendering context handle
    HDC     m_hDC;          // Device context handle
    int     StepSize;
    int     flgForward;

protected: // create from serialization only
	CGlmovieView();
	DECLARE_DYNCREATE(CGlmovieView)

// Attributes
public:
	CGlmovieDoc* GetDocument();

// Operations
public:
    
// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CGlmovieView)
	public:
	virtual void OnDraw(CDC* pDC);  // overridden to draw this view
	virtual BOOL PreCreateWindow(CREATESTRUCT& cs);
	protected:
	virtual BOOL OnPreparePrinting(CPrintInfo* pInfo);
	virtual void OnBeginPrinting(CDC* pDC, CPrintInfo* pInfo);
	virtual void OnEndPrinting(CDC* pDC, CPrintInfo* pInfo);
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CGlmovieView();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:

// Generated message map functions
protected:
	//{{AFX_MSG(CGlmovieView)
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnDestroy();
	afx_msg BOOL OnEraseBkgnd(CDC* pDC);
	afx_msg void OnSize(UINT nType, int cx, int cy);
	afx_msg void OnTimer(UINT nIDEvent);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	
};

#ifndef _DEBUG  // debug version in glmovieView.cpp
inline CGlmovieDoc* CGlmovieView::GetDocument()
   { return (CGlmovieDoc*)m_pDocument; }
#endif

/////////////////////////////////////////////////////////////////////////////
