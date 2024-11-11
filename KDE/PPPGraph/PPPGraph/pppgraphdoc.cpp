// include files for Qt
#include <qdir.h>
#include <qfileinfo.h>
#include <qwidget.h>

// include files for KDE
#include <kapp.h>
#include <kmsgbox.h>

// application specific includes
#include <pppgraphdoc.h>
#include "pppgraph.h"
#include "pppgraphview.h"

QList<PPPGraphView>* PPPGraphDoc::viewList = 0L;

PPPGraphDoc::PPPGraphDoc(QWidget *parent, const char* name):QObject(parent, name)
{
	if( !viewList )
		viewList = new QList<PPPGraphView>;
	viewList->setAutoDelete(true);
}

PPPGraphDoc::~PPPGraphDoc()
{
}

void PPPGraphDoc::addView(PPPGraphView* m_pView)
{
	viewList->append(m_pView);
}

void PPPGraphDoc::removeView(PPPGraphView* m_pView)
{
	viewList->remove(m_pView);
}
const QString& PPPGraphDoc::getPathName() const
{
	return m_path;
}

void PPPGraphDoc::slotUpdateAllViews(PPPGraphView* pSender)
{
	PPPGraphView* w;
	if(viewList)
	{
		for( w = viewList->first(); w; w = viewList->next() )
		{ if( w != pSender)
				w->repaint();
		}
	}

}

void PPPGraphDoc::pathName( const char* path_name)
{
	m_path=path_name;
}
void PPPGraphDoc::title( const char* title)
{
	m_title=title;
}

const QString& PPPGraphDoc::getTitle() const
{
	return m_title;
}

bool PPPGraphDoc::saveModified()
{
	if(b_modified)
	{
		PPPGraphApp* win=(PPPGraphApp*) parent();
  	int want_save = KMsgBox::yesNoCancel(win,
  									i18n("Warning"),	i18n("The current file has been modified.\nDo you want to save it?"));
   	switch(want_save)
    {
    	case 1:
    		if(m_title == "Untitled")
    			win->slotFileSaveAs();
    		else
	     		saveDocument(getPathName()+getTitle());
       	
       	deleteContents();
        return true;
        break;
  		case 2:
    		setModified(false);
      	deleteContents();
  			return true;
  			break;	
  		case 3:
  			return false;
  			break;
  		default:
  			return false;
  			break;
  	}
	}
	else
		return true;

}

void PPPGraphDoc::closeDocument()
{
	deleteContents();
}

bool PPPGraphDoc::newDocument()
{
	
	/////////////////////////////////////////////////
	// TODO: Add your document initialization code here
	/////////////////////////////////////////////////
	b_modified=false;
	m_path=QDir::homeDirPath();
	m_title="Untitled";
	return true;
}

bool PPPGraphDoc::openDocument(const char* filename, const char* format)
{
	QFileInfo fileInfo(filename);
	m_title=fileInfo.fileName();
	m_path=fileInfo.absFilePath();	
	/////////////////////////////////////////////////
	// TODO: Add your document opening code here
	/////////////////////////////////////////////////
	
	b_modified=false;
	return true;
}

bool PPPGraphDoc::saveDocument(const char* filename, const char* format)
{

	/////////////////////////////////////////////////
	// TODO: Add your document saving code here
	/////////////////////////////////////////////////

	b_modified=false;
	return true;
}

void PPPGraphDoc::deleteContents()
{
	/////////////////////////////////////////////////
	// TODO: Add implementation to delete the document contents
	/////////////////////////////////////////////////

}





























