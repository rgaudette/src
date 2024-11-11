// ScribbleDoc.h : interface of the CScribbleDoc class
//
/////////////////////////////////////////////////////////////////////////////

// Forward declaration of data stucture class
class CStroke;

class CScribbleDoc : public CDocument
{
protected: // create from serialization only
	void InitDocument();
	UINT m_nPenWidth;
	CScribbleDoc();
	DECLARE_DYNCREATE(CScribbleDoc)

// Attributes
public:
	CStroke* NewStroke();
	CPen m_penCur;
	CTypedPtrList<CObList, CStroke*> m_strokeList;
	CPen*	GetCurrentPen() { return &m_penCur; }

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CScribbleDoc)
	public:
	virtual BOOL OnNewDocument();
	virtual void Serialize(CArchive& ar);
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CScribbleDoc();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:

// Generated message map functions
protected:
	//{{AFX_MSG(CScribbleDoc)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////
