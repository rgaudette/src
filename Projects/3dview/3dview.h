// 3dview.h : main header file for the 3DVIEW application
//

#if !defined(AFX_3DVIEW_H__20A84EE4_DD1B_11D1_9BE7_02608CAB759B__INCLUDED_)
#define AFX_3DVIEW_H__20A84EE4_DD1B_11D1_9BE7_02608CAB759B__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"       // main symbols

/////////////////////////////////////////////////////////////////////////////
// CMy3dviewApp:
// See 3dview.cpp for the implementation of this class
//

class CMy3dviewApp : public CWinApp
{
public:
	CMy3dviewApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMy3dviewApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CMy3dviewApp)
	afx_msg void OnAppAbout();
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_3DVIEW_H__20A84EE4_DD1B_11D1_9BE7_02608CAB759B__INCLUDED_)
