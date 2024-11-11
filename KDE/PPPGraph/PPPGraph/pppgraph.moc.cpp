/****************************************************************************
** PPPGraphApp meta object code from reading C++ file 'pppgraph.h'
**
** Created: Sat Sep 4 16:26:44 1999
**      by: The Qt Meta Object Compiler ($Revision: 2.25.2.12 $)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#if !defined(Q_MOC_OUTPUT_REVISION)
#define Q_MOC_OUTPUT_REVISION 2
#elif Q_MOC_OUTPUT_REVISION != 2
#error "Moc format conflict - please regenerate all moc files"
#endif

#include "./pppgraph.h"
#include <qmetaobject.h>


const char *PPPGraphApp::className() const
{
    return "PPPGraphApp";
}

QMetaObject *PPPGraphApp::metaObj = 0;


#if QT_VERSION >= 200
static QMetaObjectInit init_PPPGraphApp(&PPPGraphApp::staticMetaObject);

#endif

void PPPGraphApp::initMetaObject()
{
    if ( metaObj )
	return;
    if ( strcmp(KTMainWindow::className(), "KTMainWindow") != 0 )
	badSuperclassWarning("PPPGraphApp","KTMainWindow");

#if QT_VERSION >= 200
    staticMetaObject();
}

void PPPGraphApp::staticMetaObject()
{
    if ( metaObj )
	return;
    KTMainWindow::staticMetaObject();
#else

    KTMainWindow::initMetaObject();
#endif

    typedef void(PPPGraphApp::*m1_t0)(int);
    typedef void(PPPGraphApp::*m1_t1)(int);
    typedef void(PPPGraphApp::*m1_t2)();
    typedef void(PPPGraphApp::*m1_t3)();
    typedef void(PPPGraphApp::*m1_t4)();
    typedef void(PPPGraphApp::*m1_t5)(int);
    typedef void(PPPGraphApp::*m1_t6)();
    typedef void(PPPGraphApp::*m1_t7)();
    typedef void(PPPGraphApp::*m1_t8)();
    typedef void(PPPGraphApp::*m1_t9)();
    typedef void(PPPGraphApp::*m1_t10)();
    typedef void(PPPGraphApp::*m1_t11)();
    typedef void(PPPGraphApp::*m1_t12)();
    typedef void(PPPGraphApp::*m1_t13)();
    typedef void(PPPGraphApp::*m1_t14)();
    typedef void(PPPGraphApp::*m1_t15)();
    typedef void(PPPGraphApp::*m1_t16)(const char*);
    typedef void(PPPGraphApp::*m1_t17)(const char*);
    m1_t0 v1_0 = &PPPGraphApp::commandCallback;
    m1_t1 v1_1 = &PPPGraphApp::statusCallback;
    m1_t2 v1_2 = &PPPGraphApp::slotFileNewWindow;
    m1_t3 v1_3 = &PPPGraphApp::slotFileNew;
    m1_t4 v1_4 = &PPPGraphApp::slotFileOpen;
    m1_t5 v1_5 = &PPPGraphApp::slotFileOpenRecent;
    m1_t6 v1_6 = &PPPGraphApp::slotFileSave;
    m1_t7 v1_7 = &PPPGraphApp::slotFileSaveAs;
    m1_t8 v1_8 = &PPPGraphApp::slotFileClose;
    m1_t9 v1_9 = &PPPGraphApp::slotFilePrint;
    m1_t10 v1_10 = &PPPGraphApp::slotFileQuit;
    m1_t11 v1_11 = &PPPGraphApp::slotEditCut;
    m1_t12 v1_12 = &PPPGraphApp::slotEditCopy;
    m1_t13 v1_13 = &PPPGraphApp::slotEditPaste;
    m1_t14 v1_14 = &PPPGraphApp::slotViewToolBar;
    m1_t15 v1_15 = &PPPGraphApp::slotViewStatusBar;
    m1_t16 v1_16 = &PPPGraphApp::slotStatusMsg;
    m1_t17 v1_17 = &PPPGraphApp::slotStatusHelpMsg;
    QMetaData *slot_tbl = new QMetaData[18];
    slot_tbl[0].name = "commandCallback(int)";
    slot_tbl[1].name = "statusCallback(int)";
    slot_tbl[2].name = "slotFileNewWindow()";
    slot_tbl[3].name = "slotFileNew()";
    slot_tbl[4].name = "slotFileOpen()";
    slot_tbl[5].name = "slotFileOpenRecent(int)";
    slot_tbl[6].name = "slotFileSave()";
    slot_tbl[7].name = "slotFileSaveAs()";
    slot_tbl[8].name = "slotFileClose()";
    slot_tbl[9].name = "slotFilePrint()";
    slot_tbl[10].name = "slotFileQuit()";
    slot_tbl[11].name = "slotEditCut()";
    slot_tbl[12].name = "slotEditCopy()";
    slot_tbl[13].name = "slotEditPaste()";
    slot_tbl[14].name = "slotViewToolBar()";
    slot_tbl[15].name = "slotViewStatusBar()";
    slot_tbl[16].name = "slotStatusMsg(const char*)";
    slot_tbl[17].name = "slotStatusHelpMsg(const char*)";
    slot_tbl[0].ptr = *((QMember*)&v1_0);
    slot_tbl[1].ptr = *((QMember*)&v1_1);
    slot_tbl[2].ptr = *((QMember*)&v1_2);
    slot_tbl[3].ptr = *((QMember*)&v1_3);
    slot_tbl[4].ptr = *((QMember*)&v1_4);
    slot_tbl[5].ptr = *((QMember*)&v1_5);
    slot_tbl[6].ptr = *((QMember*)&v1_6);
    slot_tbl[7].ptr = *((QMember*)&v1_7);
    slot_tbl[8].ptr = *((QMember*)&v1_8);
    slot_tbl[9].ptr = *((QMember*)&v1_9);
    slot_tbl[10].ptr = *((QMember*)&v1_10);
    slot_tbl[11].ptr = *((QMember*)&v1_11);
    slot_tbl[12].ptr = *((QMember*)&v1_12);
    slot_tbl[13].ptr = *((QMember*)&v1_13);
    slot_tbl[14].ptr = *((QMember*)&v1_14);
    slot_tbl[15].ptr = *((QMember*)&v1_15);
    slot_tbl[16].ptr = *((QMember*)&v1_16);
    slot_tbl[17].ptr = *((QMember*)&v1_17);
    metaObj = new QMetaObject( "PPPGraphApp", "KTMainWindow",
	slot_tbl, 18,
	0, 0 );
}
