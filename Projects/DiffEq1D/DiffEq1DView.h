// DiffEq1DView.h : interface of the CDiffEq1DView class
//
/////////////////////////////////////////////////////////////////////////////

class CDiffEq1DView : public CView
{
private:
    HGLRC   m_hRC;          // Rendering context handle
    HDC     m_hDC;          // Device context handle
protected: // create from serialization only
	CDiffEq1DView();
	DECLARE_DYNCREATE(CDiffEq1DView)

// Attributes
public:
	CDiffEq1DDoc* GetDocument();

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDiffEq1DView)
	public:
	virtual void OnDraw(CDC* pDC);  // overridden to draw this view
	virtual BOOL PreCreateWindow(CREATESTRUCT& cs);
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CDiffEq1DView();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:

// Generated message map functions
protected:
	//{{AFX_MSG(CDiffEq1DView)
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

#ifndef _DEBUG  // debug version in DiffEq1DView.cpp
inline CDiffEq1DDoc* CDiffEq1DView::GetDocument()
   { return (CDiffEq1DDoc*)m_pDocument; }
#endif

/////////////////////////////////////////////////////////////////////////////
