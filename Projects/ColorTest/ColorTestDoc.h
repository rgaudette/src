// ColorTestDoc.h : interface of the CColorTestDoc class
//
/////////////////////////////////////////////////////////////////////////////

#if !defined(AFX_COLORTESTDOC_H__8DEC3B4B_AB3D_11D1_9B3A_000000000000__INCLUDED_)
#define AFX_COLORTESTDOC_H__8DEC3B4B_AB3D_11D1_9B3A_000000000000__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000


class CColorTestDoc : public CDocument
{
protected: // create from serialization only
	CColorTestDoc();
	DECLARE_DYNCREATE(CColorTestDoc)

// Attributes
public:

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CColorTestDoc)
	public:
	virtual BOOL OnNewDocument();
	virtual void Serialize(CArchive& ar);
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CColorTestDoc();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:

// Generated message map functions
protected:
	//{{AFX_MSG(CColorTestDoc)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_COLORTESTDOC_H__8DEC3B4B_AB3D_11D1_9B3A_000000000000__INCLUDED_)
