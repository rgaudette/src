// glmovieDoc.cpp : implementation of the CGlmovieDoc class
//

#include "stdafx.h"
#include "glmovie.h"
#include "glmovieDoc.h"
#include "MatVarDir.h"
#include "DlgGetArraySize.h"
#include "DlgControl.h"
#include "GLSeq2D.h"
#include <mat.h>

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

//
//  This is the instance of the OpenGL triangle field class, declared in
//  glmovie.cpp
//
extern GLSeq2D      GLSequence;
extern DlgControl   *pMainControl;

/////////////////////////////////////////////////////////////////////////////
// CGlmovieDoc

IMPLEMENT_DYNCREATE(CGlmovieDoc, CDocument)

BEGIN_MESSAGE_MAP(CGlmovieDoc, CDocument)
	//{{AFX_MSG_MAP(CGlmovieDoc)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CGlmovieDoc construction/destruction

CGlmovieDoc::CGlmovieDoc()
{
    //
	//	Allocate memory for random test matrix
	//
    real = NULL;
    imag = NULL;
}

CGlmovieDoc::~CGlmovieDoc()
{
    delete[] real;
    delete[] imag;
}

BOOL CGlmovieDoc::OnNewDocument()
{
	if (!CDocument::OnNewDocument())
		return FALSE;
    
    return TRUE;
}

/////////////////////////////////////////////////////////////////////////////
// CGlmovieDoc serialization

void CGlmovieDoc::Serialize(CArchive& ar)
{
	MatVarDir       MatVarDlg;
    DlgGetArraySize GetArraySize;
    
    if (ar.IsStoring())
	{
		// TODO: add storing code here
	}
	else
	{
        //
        //  Get the filename selected by the user
        //
        CFile* fp = ar.GetFile();
        CString strFname = fp->GetFilePath();

        //
        //  Open the MATLAB file
        //
        MATFile *fptrMatFile = matOpen(strFname.GetBuffer(0), "r");
        if(fptrMatFile == NULL) {
            CString strMsg("Error: Unable to open as a Matlab file:\n");
            strMsg += strFname;
            AfxMessageBox(strMsg.GetBuffer(0), MB_OK|MB_OK|MB_ICONEXCLAMATION);
            return;
        }
        
        MatVarDlg.fptrMatfile = fptrMatFile;
        
        //
        //  Get the matlab variable name from the user
        //
        
        if(MatVarDlg.DoModal() == IDOK) {
            //
            //  Get the selected MATLAB array from the file
            //
            mxArray *mxArr = matGetArray(fptrMatFile,
                MatVarDlg.SelectedVar.GetBuffer(0));
            if (mxArr == NULL) {
                CString strMsg("Error: Unable to get Matlab object:\n");
                strMsg += MatVarDlg.SelectedVar;
                AfxMessageBox(strMsg.GetBuffer(0),
                    MB_OK|MB_OK|MB_ICONEXCLAMATION);
                matClose(fptrMatFile);
                return;
            }

            //
            //  Decipher or ask for the array format
            //
            int nDim = mxGetNumberOfDimensions(mxArr);
            const *vDim = mxGetDimensions(mxArr);
            nElems = mxGetNumberOfElements(mxArr);
            int szElem = mxGetElementSize(mxArr);
    
            if(mxIsComplex(mxArr))
                flgImaginary = 1;
            else
                flgImaginary = 0;

            if(nDim == 3) {
                nRows = vDim[0];
                nCols = vDim[1];
                nFrames = vDim[2];
            }
            else {
                //
                //  Prompt the user to enter the array structure
                //
                GetArraySize.nElems = nElems;
                
                if(GetArraySize.DoModal() == IDOK) {
                    nRows = GetArraySize.nRows;
                    nCols = GetArraySize.nCols;
                    nFrames = nElems / (nRows * nCols);
                }
                else {
                    matClose(fptrMatFile);
                    mxDestroyArray(mxArr);
                    return;
                }
            }      
            
            //
            //  (Re)allocate space for the array
            //
            delete[] real;
            delete[] imag;

            real = new float[nElems];
            if(flgImaginary)
                imag = new float[nElems];
            else
                imag = NULL;


            //
            //  Copy the data into this class
            //
            double *mxReal = mxGetPr(mxArr);
            double *mxImag;
            if(flgImaginary)
                mxImag = mxGetPi(mxArr);
    
            for(int i=0; i<nElems; i++)
                real[i] = (float) mxReal[i];
            if(flgImaginary) {
                for(i=0; i<nElems; i++)
                    imag[i] = (float) mxImag[i];
            }
            
            //
            //  Free up the MATLAB structures
            //
            matClose(fptrMatFile);
            mxDestroyArray(mxArr);
    
            //
            //  If the data is real then force the colormap display
            //
            if(!flgImaginary) { 
                GLSequence.SetDisplayType(DT_COLORMAP);
                pMainControl->SetPlotStyle(DT_COLORMAP);
                pMainControl->SetRealData();
            }
            else {
                pMainControl->SetCmplxData();
            }

            //
            //  Update the display data
            //
            GLSequence.SetFieldSize(nRows, nCols, nFrames);
            GLSequence.UpdateData(real, imag);
            GLSequence.ResetFrame();

            //
            //  Update the control window
            //
            float minData = GLSequence.GetDataMin();
            float maxData = GLSequence.GetDataMax();
            pMainControl->UpdateStatic(nFrames, minData, maxData);
            pMainControl->UpdateCRange(minData, maxData);
        }
    }
}

/////////////////////////////////////////////////////////////////////////////
// CGlmovieDoc diagnostics

#ifdef _DEBUG
void CGlmovieDoc::AssertValid() const
{
	CDocument::AssertValid();
}

void CGlmovieDoc::Dump(CDumpContext& dc) const
{
	CDocument::Dump(dc);
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CGlmovieDoc commands
