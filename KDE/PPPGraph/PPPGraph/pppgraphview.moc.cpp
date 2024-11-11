/****************************************************************************
** PPPGraphView meta object code from reading C++ file 'pppgraphview.h'
**
** Created: Sat Sep 4 16:26:47 1999
**      by: The Qt Meta Object Compiler ($Revision: 2.25.2.12 $)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#if !defined(Q_MOC_OUTPUT_REVISION)
#define Q_MOC_OUTPUT_REVISION 2
#elif Q_MOC_OUTPUT_REVISION != 2
#error "Moc format conflict - please regenerate all moc files"
#endif

#include "./pppgraphview.h"
#include <qmetaobject.h>


const char *PPPGraphView::className() const
{
    return "PPPGraphView";
}

QMetaObject *PPPGraphView::metaObj = 0;


#if QT_VERSION >= 200
static QMetaObjectInit init_PPPGraphView(&PPPGraphView::staticMetaObject);

#endif

void PPPGraphView::initMetaObject()
{
    if ( metaObj )
	return;
    if ( strcmp(QWidget::className(), "QWidget") != 0 )
	badSuperclassWarning("PPPGraphView","QWidget");

#if QT_VERSION >= 200
    staticMetaObject();
}

void PPPGraphView::staticMetaObject()
{
    if ( metaObj )
	return;
    QWidget::staticMetaObject();
#else

    QWidget::initMetaObject();
#endif

    metaObj = new QMetaObject( "PPPGraphView", "QWidget",
	0, 0,
	0, 0 );
}
