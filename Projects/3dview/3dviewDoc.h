// 3dviewDoc.h : interface of the CMy3dviewDoc class
//
/////////////////////////////////////////////////////////////////////////////

#if !defined(AFX_3DVIEWDOC_H__20A84EEA_DD1B_11D1_9BE7_02608CAB759B__INCLUDED_)
#define AFX_3DVIEWDOC_H__20A84EEA_DD1B_11D1_9BE7_02608CAB759B__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000


class CMy3dviewDoc : public CDocument
{
protected: // create from serialization only
	CMy3dviewDoc();
	DECLARE_DYNCREATE(CMy3dviewDoc)

// Attributes
public:

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMy3dviewDoc)
	public:
	virtual BOOL OnNewDocument();
	virtual void Serialize(CArchive& ar);
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CMy3dviewDoc();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:

// Generated message map functions
protected:
	//{{AFX_MSG(CMy3dviewDoc)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_3DVIEWDOC_H__20A84EEA_DD1B_11D1_9BE7_02608CAB759B__INCLUDED_)
