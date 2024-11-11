// 3dviewView.h : interface of the CMy3dviewView class
//
/////////////////////////////////////////////////////////////////////////////

#if !defined(AFX_3DVIEWVIEW_H__20A84EEC_DD1B_11D1_9BE7_02608CAB759B__INCLUDED_)
#define AFX_3DVIEWVIEW_H__20A84EEC_DD1B_11D1_9BE7_02608CAB759B__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

class CMy3dviewView : public CView
{
protected: // create from serialization only
	CMy3dviewView();
	DECLARE_DYNCREATE(CMy3dviewView)

// Attributes
public:
	CMy3dviewDoc* GetDocument();

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMy3dviewView)
	public:
	virtual void OnDraw(CDC* pDC);  // overridden to draw this view
	virtual BOOL PreCreateWindow(CREATESTRUCT& cs);
	protected:
	//}}AFX_VIRTUAL

// Implementation
public:
	HDC m_hDC;
	HGLRC m_hRC;
	virtual ~CMy3dviewView();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:

// Generated message map functions
protected:
	//{{AFX_MSG(CMy3dviewView)
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnDestroy();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

#ifndef _DEBUG  // debug version in 3dviewView.cpp
inline CMy3dviewDoc* CMy3dviewView::GetDocument()
   { return (CMy3dviewDoc*)m_pDocument; }
#endif

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_3DVIEWVIEW_H__20A84EEC_DD1B_11D1_9BE7_02608CAB759B__INCLUDED_)
