// DlgControl.cpp : implementation file
//

#include "stdafx.h"
#include <stdlib.h>
#include <math.h>
#include "glmovie.h"
#include "glmovieDoc.h"
#include "glmovieView.h"
#include "DlgControl.h"
#include "GLSeq2D.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

extern GLSeq2D      GLSequence;
extern CGlmovieView *pView;

/////////////////////////////////////////////////////////////////////////////
// DlgControl dialog


DlgControl::DlgControl(CWnd* pParent /*=NULL*/)
	: CDialog(DlgControl::IDD, pParent)
{
	//{{AFX_DATA_INIT(DlgControl)
	CMax = 0.0f;
	CMin = 0.0f;
	FrameRate = 5.0f;
	StepSize = 1;
	PlotStyle = 0;
	ColorMapping = 0;
	flgGrid = TRUE;
	flgColorBar = TRUE;
	flgOrtho = 0;
	//}}AFX_DATA_INIT
    flgTimerOn = 0;
}


void DlgControl::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(DlgControl)
	DDX_Text(pDX, IDC_COLORMAX, CMax);
	DDX_Text(pDX, IDC_COLORMIN, CMin);
	DDX_Text(pDX, IDC_FRAMERATE, FrameRate);
	DDV_MinMaxFloat(pDX, FrameRate, 0.f, 18.2066f);
	DDX_Text(pDX, IDC_STEPSIZE, StepSize);
	DDV_MinMaxInt(pDX, StepSize, 1, 10000000);
	DDX_Radio(pDX, IDC_COLORMAP, PlotStyle);
	DDX_Radio(pDX, IDC_BGYOR, ColorMapping);
	DDX_Check(pDX, IDC_GRID, flgGrid);
	DDX_Check(pDX, IDC_COLORBAR, flgColorBar);
	DDX_Radio(pDX, IDC_ORTHO, flgOrtho);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(DlgControl, CDialog)
	//{{AFX_MSG_MAP(DlgControl)
	ON_BN_CLICKED(IDC_PLAY, OnPlay)
	ON_BN_CLICKED(IDC_REVERSE, OnReverse)
	ON_BN_CLICKED(IDC_SINGLESTEP, OnSinglestep)
	ON_BN_CLICKED(IDC_STOP, OnStop)
	ON_BN_CLICKED(IDC_APPLY, OnApply)
	ON_BN_CLICKED(IDC_BKWDSTEP, OnBkwdstep)
	ON_BN_CLICKED(IDC_RESET, OnReset)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// DlgControl message handlers

void DlgControl::OnPlay() 
{
    //
    //  Start a timer for the specified period notifying the main window
    //
    pView->flgForward = 1;
    if(!flgTimerOn) {
        pView->SetTimer(101, (unsigned int) (1000.0 / FrameRate), NULL);
        flgTimerOn = 1;
    }
}


void DlgControl::OnReverse() 
{
    //
    //  Start a timer for the specified period notifying the main window
    //
    pView->flgForward = 0;
    if(!flgTimerOn) {
        pView->SetTimer(101, (unsigned int) (1000.0 / FrameRate), NULL);
        flgTimerOn = 1;
    }

}


void DlgControl::OnStop() 
{
    //
    //  Kill the timer
    //
    if(flgTimerOn) {
        pView->KillTimer(101);
        flgTimerOn = 0;
    }
}


void DlgControl::OnSinglestep() 
{
    //
    //  Increment the frame index
    //
    if(flgTimerOn) {
        pView->KillTimer(101);
        flgTimerOn = 0;
    }
    else {
        GLSequence.IncrementFrame(pView->StepSize);
        pView->Invalidate(FALSE);
        UpdateFrameIdx(GLSequence.GetFrameIdx());
    }
}


void DlgControl::OnBkwdstep() 
{
    //
    //  Decrement the frame index
    //
    if(flgTimerOn) {
        pView->KillTimer(101);
        flgTimerOn = 0;
    }
    else {
        GLSequence.DecrementFrame(pView->StepSize);
        pView->Invalidate(FALSE);
        UpdateFrameIdx(GLSequence.GetFrameIdx());
    }
}


void DlgControl::OnApply() 
{

    UpdateData(TRUE);
    pView->StepSize = StepSize;
    
    //
    //  This relationship depends on the tab order and the enum values for
    //  the DisplayType memeber.
    //
    GLSequence.SetCRange(CMin, CMax);
    GLSequence.SetDisplayType(PlotStyle);
    GLSequence.SetCMapType(ColorMapping);
    GLSequence.SetGridFlag(flgGrid);
    GLSequence.SetColorBarFlag(flgColorBar);
    if(flgOrtho == 0)
        GLSequence.SetViewOrtho();
    else
        GLSequence.SetViewFill();
    
    //
    //  If the movie is playing stop and update the timer period
    //
    if(flgTimerOn) {
        pView->KillTimer(101);
        pView->SetTimer(101, (unsigned int) (1000.0 / FrameRate), NULL);
    }
    else {
        pView->Invalidate(FALSE);
    }

}


void DlgControl::UpdateCRange(float ColorMin, float ColorMax)
{
    CMin = ColorMin;
    CMax = ColorMax;

    //
    //  Update the edit fields and the GLSequence object
    //
    UpdateData(FALSE);
    GLSequence.SetCRange(CMin, CMax);

}

void DlgControl::UpdateStatic(int nFrames, float DataMin, float DataMax)
{
    //
    //  Update the static controls
    //
    CString txtStatic;
    txtStatic.Format("Frames: %d", nFrames);
    SetDlgItemText(IDC_NFRAMES, txtStatic);
    
    txtStatic.Format("Minimum: %2.4f", DataMin);
    SetDlgItemText(IDC_MINMAG, txtStatic);

    txtStatic.Format("Maximum: %2.4f", DataMax); 
    SetDlgItemText(IDC_MAXMAG, txtStatic);
}

void DlgControl::PostNcDestroy() 
{
    delete this;
}

void DlgControl::OnReset() 
{
	//
    //  Reset the frame index
    //
	GLSequence.ResetFrame();
    UpdateFrameIdx(GLSequence.GetFrameIdx());
}

void DlgControl::UpdateFrameIdx(int iF)
{
    iFrame = iF;
    //
    //  Update the static controls
    //
    CString txtStatic;
    txtStatic.Format("Current Frame: %d", iFrame);
    SetDlgItemText(IDC_CURRFRAME, txtStatic);
}


void DlgControl::SetPlotStyle(int plot_style)
{
    PlotStyle = plot_style;    
    UpdateData(FALSE);    
}

void DlgControl::SetRealData()
{
    //
    //  Disallow the use of the arrows plotting style
    //
    CWnd *rbArrows;
    rbArrows = GetDlgItem(IDC_ARROWS);
    if(rbArrows)
        rbArrows->EnableWindow(FALSE);
}

void DlgControl::SetCmplxData()
{
    //
    //  Allow the use of the arrows plotting style
    //
    CWnd *rbArrows;
    rbArrows = GetDlgItem(IDC_ARROWS);
    if(rbArrows)
        rbArrows->EnableWindow(TRUE);
}
