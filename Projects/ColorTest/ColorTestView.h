// ColorTestView.h : interface of the CColorTestView class
//
/////////////////////////////////////////////////////////////////////////////

#if !defined(AFX_COLORTESTVIEW_H__8DEC3B4D_AB3D_11D1_9B3A_000000000000__INCLUDED_)
#define AFX_COLORTESTVIEW_H__8DEC3B4D_AB3D_11D1_9B3A_000000000000__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

class CColorTestView : public CView
{
protected: // create from serialization only
	CColorTestView();
	DECLARE_DYNCREATE(CColorTestView)

// Attributes
public:
	CColorTestDoc* GetDocument();

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CColorTestView)
	public:
	virtual void OnDraw(CDC* pDC);  // overridden to draw this view
	virtual BOOL PreCreateWindow(CREATESTRUCT& cs);
	//}}AFX_VIRTUAL

// Implementation
public:
	HGLRC m_hRC;
	HDC m_hDC;
	virtual ~CColorTestView();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:

// Generated message map functions
protected:
	//{{AFX_MSG(CColorTestView)
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnDestroy();
	afx_msg BOOL OnEraseBkgnd(CDC* pDC);
	afx_msg void OnSize(UINT nType, int cx, int cy);
	afx_msg void OnPatternsPrimaryandsecondary();
	afx_msg void OnPatternsGrey();
	afx_msg void OnPatternsRgbscales();
	afx_msg void OnPatternsHorizontalLines1pixel();
	afx_msg void OnPatternsVerticalLines1pixel();
	afx_msg void OnPatternsPoints();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

#ifndef _DEBUG  // debug version in ColorTestView.cpp
inline CColorTestDoc* CColorTestView::GetDocument()
   { return (CColorTestDoc*)m_pDocument; }
#endif

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_COLORTESTVIEW_H__8DEC3B4D_AB3D_11D1_9B3A_000000000000__INCLUDED_)
