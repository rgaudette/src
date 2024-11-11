// DiffEq1D.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "DiffEq1D.h"

#include "MainFrm.h"
#include "DiffEq1DDoc.h"
#include "DiffEq1DView.h"
#include <dos.h>
#include <direct.h>

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CDiffEq1DApp

BEGIN_MESSAGE_MAP(CDiffEq1DApp, CWinApp)
	//{{AFX_MSG_MAP(CDiffEq1DApp)
	ON_COMMAND(ID_APP_ABOUT, OnAppAbout)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG_MAP
	// Standard file based document commands
	ON_COMMAND(ID_FILE_NEW, CWinApp::OnFileNew)
	ON_COMMAND(ID_FILE_OPEN, CWinApp::OnFileOpen)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDiffEq1DApp construction

CDiffEq1DApp::CDiffEq1DApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}

/////////////////////////////////////////////////////////////////////////////
// The one and only CDiffEq1DApp object

CDiffEq1DApp theApp;

/////////////////////////////////////////////////////////////////////////////
// CDiffEq1DApp initialization

BOOL CDiffEq1DApp::InitInstance()
{
	// Standard initialization
	// If you are not using these features and wish to reduce the size
	//  of your final executable, you should remove from the following
	//  the specific initialization routines you do not need.

#ifdef _AFXDLL
	Enable3dControls();			// Call this when using MFC in a shared DLL
#else
	Enable3dControlsStatic();	// Call this when linking to MFC statically
#endif

	LoadStdProfileSettings();  // Load standard INI file options (including MRU)

	// Register the application's document templates.  Document templates
	//  serve as the connection between documents, frame windows and views.

	CSingleDocTemplate* pDocTemplate;
	pDocTemplate = new CSingleDocTemplate(
		IDR_MAINFRAME,
		RUNTIME_CLASS(CDiffEq1DDoc),
		RUNTIME_CLASS(CMainFrame),       // main SDI frame window
		RUNTIME_CLASS(CDiffEq1DView));
	AddDocTemplate(pDocTemplate);

	// Parse command line for standard shell commands, DDE, file open
	CCommandLineInfo cmdInfo;
	ParseCommandLine(cmdInfo);

	// Dispatch commands specified on the command line
	if (!ProcessShellCommand(cmdInfo))
		return FALSE;

	return TRUE;
}

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	virtual BOOL OnInitDialog();
	//{{AFX_MSG(CAboutDlg)
		// No message handlers
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
	//{{AFX_DATA_INIT(CAboutDlg)
	//}}AFX_DATA_INIT
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAboutDlg)
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
		// No message handlers
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

// App command to run the dialog
void CDiffEq1DApp::OnAppAbout()
{
	CAboutDlg aboutDlg;
	aboutDlg.DoModal();
}

/////////////////////////////////////////////////////////////////////////////
// CDiffEq1DApp commands

BOOL CAboutDlg::OnInitDialog()
{
	// CG: Folowing code is added by System Info Component
	{
	CDialog::OnInitDialog();
#ifndef _MAC
	CString strFreeDiskSpace;
	CString strFreeMemory;
	CString strFmt;

	// Fill available memory
	MEMORYSTATUS MemStat;
	MemStat.dwLength = sizeof(MEMORYSTATUS);
	GlobalMemoryStatus(&MemStat);
	strFmt.LoadString(CG_IDS_PHYSICAL_MEM);
	strFreeMemory.Format(strFmt, MemStat.dwTotalPhys / 1024L);

	//TODO: Add a static control to your About Box to receive the memory
	//      information.  Initialize the control with code like this:
	// SetDlgItemText(IDC_PHYSICAL_MEM, strFreeMemory);

	// Fill disk free information
	struct _diskfree_t diskfree;
	int nDrive = _getdrive(); // use current default drive
	if (_getdiskfree(nDrive, &diskfree) == 0)
	{
		strFmt.LoadString(CG_IDS_DISK_SPACE);
		strFreeDiskSpace.Format(strFmt,
			(DWORD)diskfree.avail_clusters *
			(DWORD)diskfree.sectors_per_cluster *
			(DWORD)diskfree.bytes_per_sector / (DWORD)1024L,
			nDrive-1 + _T('A'));
	}
 	else
 		strFreeDiskSpace.LoadString(CG_IDS_DISK_SPACE_UNAVAIL);

	//TODO: Add a static control to your About Box to receive the memory
	//      information.  Initialize the control with code like this:
	// SetDlgItemText(IDC_DISK_SPACE, strFreeDiskSpace);

#endif //_MAC
	}

	return TRUE;
}
