// ColorTest.h : main header file for the COLORTEST application
//

#if !defined(AFX_COLORTEST_H__8DEC3B45_AB3D_11D1_9B3A_000000000000__INCLUDED_)
#define AFX_COLORTEST_H__8DEC3B45_AB3D_11D1_9B3A_000000000000__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"       // main symbols

enum EPATTERN {PRIMARYS=0, GREYS=1, RGB=2, HZLINES1=3, VTLINES1=4, PAT_POINTS=5};

/////////////////////////////////////////////////////////////////////////////
// CColorTestApp:
// See ColorTest.cpp for the implementation of this class
//

class CColorTestApp : public CWinApp
{
public:
	CColorTestApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CColorTestApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CColorTestApp)
	afx_msg void OnAppAbout();
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_COLORTEST_H__8DEC3B45_AB3D_11D1_9B3A_000000000000__INCLUDED_)
