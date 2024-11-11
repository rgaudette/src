// glmovieDoc.h : interface of the CGlmovieDoc class
//
/////////////////////////////////////////////////////////////////////////////

class CGlmovieDoc : public CDocument
{
protected: // create from serialization only
	CGlmovieDoc();
	DECLARE_DYNCREATE(CGlmovieDoc)

// Attributes
private:
	int flgImaginary;
    int nRows, nCols, nElems;
    int nFrames;
    float *real, *imag;
public:

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CGlmovieDoc)
	public:
	virtual BOOL OnNewDocument();
	virtual void Serialize(CArchive& ar);
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CGlmovieDoc();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:

// Generated message map functions
protected:
	//{{AFX_MSG(CGlmovieDoc)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////
