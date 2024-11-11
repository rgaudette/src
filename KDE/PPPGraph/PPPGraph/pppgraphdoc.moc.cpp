/****************************************************************************
** PPPGraphDoc meta object code from reading C++ file 'pppgraphdoc.h'
**
** Created: Sat Sep 4 16:26:46 1999
**      by: The Qt Meta Object Compiler ($Revision: 2.25.2.12 $)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#if !defined(Q_MOC_OUTPUT_REVISION)
#define Q_MOC_OUTPUT_REVISION 2
#elif Q_MOC_OUTPUT_REVISION != 2
#error "Moc format conflict - please regenerate all moc files"
#endif

#include "./pppgraphdoc.h"
#include <qmetaobject.h>


const char *PPPGraphDoc::className() const
{
    return "PPPGraphDoc";
}

QMetaObject *PPPGraphDoc::metaObj = 0;


#if QT_VERSION >= 200
static QMetaObjectInit init_PPPGraphDoc(&PPPGraphDoc::staticMetaObject);

#endif

void PPPGraphDoc::initMetaObject()
{
    if ( metaObj )
	return;
    if ( strcmp(QObject::className(), "QObject") != 0 )
	badSuperclassWarning("PPPGraphDoc","QObject");

#if QT_VERSION >= 200
    staticMetaObject();
}

void PPPGraphDoc::staticMetaObject()
{
    if ( metaObj )
	return;
    QObject::staticMetaObject();
#else

    QObject::initMetaObject();
#endif

    typedef void(PPPGraphDoc::*m1_t0)(PPPGraphView*);
    m1_t0 v1_0 = &PPPGraphDoc::slotUpdateAllViews;
    QMetaData *slot_tbl = new QMetaData[1];
    slot_tbl[0].name = "slotUpdateAllViews(PPPGraphView*)";
    slot_tbl[0].ptr = *((QMember*)&v1_0);
    metaObj = new QMetaObject( "PPPGraphDoc", "QObject",
	slot_tbl, 1,
	0, 0 );
}
