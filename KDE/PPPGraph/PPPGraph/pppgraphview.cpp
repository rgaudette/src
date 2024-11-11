// include files for Qt
#include <qprinter.h>
#include <qpainter.h>

// application specific includes
#include <pppgraphview.h>
#include "pppgraphdoc.h"
#include "pppgraph.h"

PPPGraphView::PPPGraphView(QWidget *parent, const char* name) : QWidget(parent, name){
	setBackgroundMode( PaletteBase );

}

PPPGraphView::~PPPGraphView(){
}


PPPGraphDoc* PPPGraphView::getDocument() const
{
	PPPGraphApp* theApp=(PPPGraphApp*)parentWidget();
	return theApp->getDocument();
}

void PPPGraphView::print(QPrinter* m_pPrinter)
{
	QPainter printpainter;
	printpainter.begin(m_pPrinter);
	
	// TODO: add your printing code here
	
	printpainter.end();

}








