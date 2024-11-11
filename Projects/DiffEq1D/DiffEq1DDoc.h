// DiffEq1DDoc.h : interface of the CDiffEq1DDoc class
//
/////////////////////////////////////////////////////////////////////////////

class CDiffEq1DDoc : public CDocument
{
protected: // create from serialization only
	CDiffEq1DDoc();
	DECLARE_DYNCREATE(CDiffEq1DDoc)

// Attributes
public:

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDiffEq1DDoc)
	public:
	virtual BOOL OnNewDocument();
	virtual void Serialize(CArchive& ar);
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CDiffEq1DDoc();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:

// Generated message map functions
protected:
	//{{AFX_MSG(CDiffEq1DDoc)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	float yRightBC;
	float yLeftBC;
	float minStepDiff;
	float XDiff;
	GLfloat * yPrevVec;
	GLfloat * yVec;
	GLfloat * xVec;
	int nElements;
};

/////////////////////////////////////////////////////////////////////////////
