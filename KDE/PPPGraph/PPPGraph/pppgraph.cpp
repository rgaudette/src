
// include files for QT
#include <qdir.h>
#include <qstrlist.h>
#include <qprinter.h>
#include <qpainter.h>

// include files for KDE
#include <kiconloader.h>
#include <kmsgbox.h>
#include <kfiledialog.h>

// application specific includes
#include <pppgraph.h>
#include "pppgraphview.h"
#include "pppgraphdoc.h"
#include "resource.h"


PPPGraphApp::PPPGraphApp()
{
	config=kapp->getConfig();
	
  ///////////////////////////////////////////////////////////////////
  // call inits to invoke all other construction parts
  initMenuBar();
  initToolBar();
  initStatusBar();
  initKeyAccel();
  initDocument();
  initView();
	
  readOptions();

  ///////////////////////////////////////////////////////////////////
  // disable menu and toolbar items at startup
  disableCommand(ID_FILE_SAVE);
  disableCommand(ID_FILE_SAVE_AS);
  disableCommand(ID_FILE_PRINT);
 	
  disableCommand(ID_EDIT_CUT);
  disableCommand(ID_EDIT_COPY);
  disableCommand(ID_EDIT_PASTE);
}

PPPGraphApp::~PPPGraphApp()
{

}

void PPPGraphApp::initKeyAccel()
{
	key_accel = new KAccel( this );
	
	// file_menu accelerators
	key_accel->connectItem( KAccel::New, this, SLOT( slotFileNew() ) );
	key_accel->connectItem( KAccel::Open, this, SLOT( slotFileOpen() ) );
	key_accel->connectItem( KAccel::Save, this, SLOT( slotFileSave() ) );
	key_accel->connectItem( KAccel::Close, this, SLOT( slotFileClose() ) );
	key_accel->connectItem( KAccel::Print, this, SLOT( slotFilePrint() ) );
	key_accel->connectItem( KAccel::Quit, this, SLOT( slotFileQuit() ) );
	// edit_menu accelerators
	key_accel->connectItem( KAccel::Cut, this, SLOT( slotEditCut() ) );
	key_accel->connectItem( KAccel::Copy, this, SLOT( slotEditCopy() ) );
	key_accel->connectItem( KAccel::Paste, this, SLOT( slotEditPaste() ) );

	key_accel->connectItem( KAccel::Help, kapp, SLOT( appHelpActivated() ) );
			
	key_accel->changeMenuAccel(	file_menu, ID_FILE_NEW, KAccel::New );
	key_accel->changeMenuAccel(	file_menu, ID_FILE_OPEN, KAccel::Open );
	key_accel->changeMenuAccel(	file_menu, ID_FILE_SAVE, KAccel::Save );
	key_accel->changeMenuAccel( file_menu, ID_FILE_CLOSE, KAccel::Close );
	key_accel->changeMenuAccel(	file_menu, ID_FILE_PRINT, KAccel::Print );
	key_accel->changeMenuAccel(	file_menu, ID_FILE_QUIT, KAccel::Quit );

  key_accel->changeMenuAccel(	edit_menu, ID_EDIT_CUT, KAccel::Cut );
  key_accel->changeMenuAccel(	edit_menu, ID_EDIT_COPY, KAccel::Copy );
  key_accel->changeMenuAccel(	edit_menu, ID_EDIT_PASTE, KAccel::Paste );

  key_accel->readSettings();	
}

void PPPGraphApp::initMenuBar()
{

  ///////////////////////////////////////////////////////////////////
  // MENUBAR

  recent_files_menu = new QPopupMenu();
  connect( recent_files_menu, SIGNAL(activated(int)), SLOT(slotFileOpenRecent(int)) );

  ///////////////////////////////////////////////////////////////////
  // menuBar entry file_menu
  file_menu = new QPopupMenu();
  file_menu->insertItem(kapp->getMiniIcon(), i18n("New &Window"), ID_FILE_NEW_WINDOW );
  file_menu->insertSeparator();
  file_menu->insertItem(Icon("filenew.xpm"), i18n("&New"), ID_FILE_NEW );
  file_menu->insertItem(Icon("fileopen.xpm"), i18n("&Open..."), ID_FILE_OPEN );
  file_menu->insertItem(i18n("Open &recent"), recent_files_menu, ID_FILE_OPEN_RECENT );

  file_menu->insertItem(i18n("&Close"), ID_FILE_CLOSE );
  file_menu->insertSeparator();
  file_menu->insertItem(Icon("filefloppy.xpm") ,i18n("&Save"), ID_FILE_SAVE );
  file_menu->insertItem(i18n("Save &As..."), ID_FILE_SAVE_AS );
  file_menu->insertSeparator();
  file_menu->insertItem(Icon("fileprint.xpm"), i18n("&Print..."), ID_FILE_PRINT );
  file_menu->insertSeparator();
  file_menu->insertItem(i18n("E&xit"), ID_FILE_QUIT );
	
  ///////////////////////////////////////////////////////////////////
  // menuBar entry edit_menu
  edit_menu = new QPopupMenu();
  edit_menu->insertItem(Icon("editcut.xpm"), i18n("Cu&t"), ID_EDIT_CUT );
  edit_menu->insertItem(Icon("editcopy.xpm"), i18n("&Copy"), ID_EDIT_COPY );
  edit_menu->insertItem(Icon("editpaste.xpm"), i18n("&Paste"), ID_EDIT_PASTE );

  ///////////////////////////////////////////////////////////////////
  // menuBar entry view_menu
  view_menu = new QPopupMenu();
  view_menu->setCheckable(true);
  view_menu->insertItem(i18n("&Toolbar"), ID_VIEW_TOOLBAR);
  view_menu->insertItem(i18n("&Statusbar"), ID_VIEW_STATUSBAR );

  ///////////////////////////////////////////////////////////////////
  // menuBar entry help_menu
  QString aboutstring=kapp->appName()+" "+VERSION+"\n\n";

  help_menu = new QPopupMenu();
  help_menu = kapp->getHelpMenu(true, aboutstring );

  ///////////////////////////////////////////////////////////////////
  // MENUBAR CONFIGURATION
  // insert your popup menus with the according menubar entries in the order
  // they will appear later from left to right
  menuBar()->insertItem(i18n("&File"), file_menu);
  menuBar()->insertItem(i18n("&Edit"), edit_menu);
  menuBar()->insertItem(i18n("&View"), view_menu);

  menuBar()->insertSeparator();
  menuBar()->insertItem(i18n("&Help"), help_menu);

  ///////////////////////////////////////////////////////////////////
  // CONNECT THE MENU SLOTS WITH SIGNALS
  // for execution slots and statusbar messages

  connect(file_menu,SIGNAL(activated(int)),SLOT(commandCallback(int)));
  connect(file_menu,SIGNAL(highlighted(int)),SLOT(statusCallback(int)));

  connect(edit_menu,SIGNAL(activated(int)),SLOT(commandCallback(int)));
  connect(edit_menu,SIGNAL(highlighted(int)),SLOT(statusCallback(int)));

  connect(view_menu,SIGNAL(activated(int)),SLOT(commandCallback(int)));
  connect(view_menu,SIGNAL(highlighted(int)),SLOT(statusCallback(int)));

}

void PPPGraphApp::initToolBar()
{

  ///////////////////////////////////////////////////////////////////
  // TOOLBAR
  toolBar()->insertButton(Icon("filenew.xpm"), ID_FILE_NEW, true, i18n("New File") );
  toolBar()->insertButton(Icon("fileopen.xpm"), ID_FILE_OPEN, true, i18n("Open File") );
  toolBar()->insertButton(Icon("filefloppy.xpm"), ID_FILE_SAVE, true, i18n("Save File") );
  toolBar()->insertButton(Icon("fileprint.xpm"), ID_FILE_PRINT, true, i18n("Print") );
  toolBar()->insertSeparator();
  toolBar()->insertButton(Icon("editcut.xpm"), ID_EDIT_CUT, true, i18n("Cut") );
  toolBar()->insertButton(Icon("editcopy.xpm"), ID_EDIT_COPY, true, i18n("Copy") );
  toolBar()->insertButton(Icon("editpaste.xpm"), ID_EDIT_PASTE, true, i18n("Paste") );
  toolBar()->insertSeparator();
  toolBar()->insertButton(Icon("help.xpm"), ID_HELP_CONTENTS, SIGNAL(clicked() ),
  				kapp, SLOT( appHelpActivated() ), true,i18n("Help"));

  ///////////////////////////////////////////////////////////////////
  // INSERT YOUR APPLICATION SPECIFIC TOOLBARS HERE WITH toolBar(n)


  ///////////////////////////////////////////////////////////////////
  // CONNECT THE TOOLBAR SLOTS WITH SIGNALS - add new created toolbars by their according number
	// connect for invoking the slot actions
  connect(toolBar(), SIGNAL(clicked(int)), SLOT(commandCallback(int)));
	// connect for the status help on holing icons pressed with the mouse button
  connect(toolBar(), SIGNAL(pressed(int)), SLOT(statusCallback(int)));

}

void PPPGraphApp::initStatusBar()
{
  ///////////////////////////////////////////////////////////////////
  // STATUSBAR
	// TODO: add your own items you need for displaying current application status.
  statusBar()->insertItem(i18n("Ready."), ID_STATUS_MSG );
}

void PPPGraphApp::initDocument()
{
  doc = new PPPGraphDoc(this);
  doc->newDocument();
}

void PPPGraphApp::initView()
{ 
  ////////////////////////////////////////////////////////////////////
  // create the main widget here that is managed by KTMainWindow's view-region and
  // connect the widget to your document to display document contents.

  view = new PPPGraphView(this);
  doc->addView(view);
  setView(view);
  QString caption=kapp->getCaption();	
  setCaption(caption+": "+doc->getTitle());

}

void PPPGraphApp::enableCommand(int id_)
{
  ///////////////////////////////////////////////////////////////////
  // enable menu and toolbar functions by their ID's
  menuBar()->setItemEnabled(id_,true);
  toolBar()->setItemEnabled(id_,true);
}

void PPPGraphApp::disableCommand(int id_)
{
  ///////////////////////////////////////////////////////////////////
  // disable menu and toolbar functions by their ID's
  menuBar()->setItemEnabled(id_,false);
  toolBar()->setItemEnabled(id_,false);
}

void PPPGraphApp::addRecentFile(const char* file)
{
  if(recent_files.find(file) == -1){
    if( recent_files.count() < 5)
      recent_files.insert(0,file);
    else{
      recent_files.remove(4);
      recent_files.insert(0,file);
    }
    recent_files_menu->clear();
    for ( int i =0 ; i < (int)recent_files.count(); i++){
      recent_files_menu->insertItem(recent_files.at(i));
    }
	}
}

void PPPGraphApp::openDocumentFile(const char* _cmdl)
{
  slotStatusMsg(i18n("Opening file..."));
	doc->openDocument(_cmdl);
  slotStatusMsg(i18n("Ready."));
}


PPPGraphDoc* PPPGraphApp::getDocument() const
{
	return doc;
}

void PPPGraphApp::saveOptions()
{	
	config->setGroup("General Options");
	config->writeEntry("Geometry", size() );
  config->writeEntry("Show Toolbar", toolBar()->isVisible());
  config->writeEntry("Show Statusbar",statusBar()->isVisible());
  config->writeEntry("MenuBarPos", (int)menuBar()->menuBarPos());
  config->writeEntry("ToolBarPos",  (int)toolBar()->barPos());
	config->writeEntry("Recent Files", recent_files);
}


void PPPGraphApp::readOptions()
{
	
	config->setGroup("General Options");

	// bar status settings
	bool bViewToolbar = config->readBoolEntry("Show Toolbar", true);
	view_menu->setItemChecked(ID_VIEW_TOOLBAR, bViewToolbar);
	if(!bViewToolbar)
		enableToolBar(KToolBar::Hide);
	
  bool bViewStatusbar = config->readBoolEntry("Show Statusbar", true);
	view_menu->setItemChecked(ID_VIEW_STATUSBAR, bViewStatusbar);
	if(!bViewStatusbar)
		enableStatusBar(KStatusBar::Hide);
	
	// bar position settings
	KMenuBar::menuPosition menu_bar_pos;
	menu_bar_pos=(KMenuBar::menuPosition)config->readNumEntry("MenuBarPos", KMenuBar::Top);

  KToolBar::BarPosition tool_bar_pos;
  tool_bar_pos=(KToolBar::BarPosition)config->readNumEntry("ToolBarPos", KToolBar::Top);

	menuBar()->setMenuBarPos(menu_bar_pos);
  toolBar()->setBarPos(tool_bar_pos);
	
  // initialize the recent file list
	recent_files.setAutoDelete(TRUE);
	config->readListEntry("Recent Files",recent_files);
	
	uint i;
	for ( i =0 ; i < recent_files.count(); i++){
    recent_files_menu->insertItem(recent_files.at(i));
  }

  QSize size=config->readSizeEntry("Geometry");
	if(!size.isEmpty())
		resize(size);
}

void PPPGraphApp::saveProperties(KConfig* )
{
	if( doc->getTitle() != i18n("Untitled") && !doc->isModified()){
		return;
	}
	else{
		QString filename=doc->getPathName()+doc->getTitle();	
    config->writeEntry("filename",filename);
    config->writeEntry("modified",doc->isModified());
		
		const char* tempname = kapp->tempSaveName(filename);
		doc->saveDocument(tempname);
	}
}


void PPPGraphApp::readProperties(KConfig*)
{
	QString filename = config->readEntry("filename","");
	bool modified = config->readBoolEntry("modified",false);
  if( modified ){
  	bool b_canRecover;
		QString tempname = kapp->checkRecoverFile(filename,b_canRecover);
  	
  	if(b_canRecover){
   			doc->openDocument(tempname);
   			doc->setModified();
   			QFileInfo info(filename);
   			doc->pathName(info.absFilePath());
   			doc->title(info.fileName());
   			QFile::remove(tempname);
		}
	}
 	else if(!filename.isEmpty()){
		doc->openDocument(filename);
	}
  QString caption=kapp->getCaption();	
  setCaption(caption+": "+doc->getTitle());
}		

bool PPPGraphApp::queryClose()
{
	return doc->saveModified();
}

bool PPPGraphApp::queryExit()
{
	saveOptions();
	return true;
}

/////////////////////////////////////////////////////////////////////
// SLOT IMPLEMENTATION
/////////////////////////////////////////////////////////////////////

void PPPGraphApp::slotFileNewWindow()
{
  slotStatusMsg(i18n("Opening a new Application window..."));
	
	PPPGraphApp* new_window= new PPPGraphApp();
	new_window->show();
	
  slotStatusMsg(i18n("Ready."));
}

void PPPGraphApp::slotFileNew()
{
  slotStatusMsg(i18n("Creating new document..."));
	
	if(!doc->saveModified())
		return;
	
	doc->newDocument();		
  QString caption=kapp->getCaption();	
  setCaption(caption+": "+doc->getTitle());

  slotStatusMsg(i18n("Ready."));
}

void PPPGraphApp::slotFileOpen()
{
  slotStatusMsg(i18n("Opening file..."));
	
	if(!doc->saveModified())
		return;
	
	QString fileToOpen=KFileDialog::getOpenFileName(QDir::homeDirPath(), "", this, i18n("Open File..."));
	if(!fileToOpen.isEmpty()){
		doc->openDocument(fileToOpen);
    QString caption=kapp->getCaption();	
    setCaption(caption+": "+doc->getTitle());
		addRecentFile(fileToOpen);
	}

  slotStatusMsg(i18n("Ready."));
}

void PPPGraphApp::slotFileOpenRecent(int id_)
{
  slotStatusMsg(i18n("Opening file..."));
	
	if(!doc->saveModified())
		return;

  doc->openDocument(recent_files.at(id_));
  QString caption=kapp->getCaption();	
  setCaption(caption+": "+doc->getTitle());

  slotStatusMsg(i18n("Ready."));
}

void PPPGraphApp::slotFileSave()
{
  slotStatusMsg(i18n("Saving file..."));
	
	doc->saveDocument(doc->getPathName()+doc->getTitle());

  slotStatusMsg(i18n("Ready."));
}

void PPPGraphApp::slotFileSaveAs()
{
  slotStatusMsg(i18n("Saving file under new filename..."));

	QString newName=KFileDialog::getSaveFileName(QDir::currentDirPath(), "", this, i18n("Save As..."));
	if(!newName.isEmpty()){
		QFileInfo saveAsInfo(newName);
		doc->title(saveAsInfo.fileName());
		doc->pathName(saveAsInfo.absFilePath());
		doc->saveDocument(newName);
		addRecentFile(newName);
    QString caption=kapp->getCaption();	
    setCaption(caption+": "+doc->getTitle());
	}

  slotStatusMsg(i18n("Ready."));
}

void PPPGraphApp::slotFileClose()
{
  slotStatusMsg(i18n("Closing file..."));
	
	close();
}

void PPPGraphApp::slotFilePrint()
{
  slotStatusMsg(i18n("Printing..."));

  QPrinter printer;
  if (printer.setup(this)){
			view->print(&printer);
	}

  slotStatusMsg(i18n("Ready."));
}

void PPPGraphApp::slotFileQuit()
{
	saveOptions();
	// close the first window, the list makes the next one the first again.
	// This ensures that queryClose() is called on each window to ask for closing
	KTMainWindow* w;
	if(memberList){
		for(w=memberList->first(); w; w=memberList->first()){
			// only close the window if the closeEvent is accepted. If the user presses Cancel on the saveModified() dialog,
			// the window and the application stay open.
			if(!w->close())
				break;
		}
	}	
}

void PPPGraphApp::slotEditCut()
{
  slotStatusMsg(i18n("Cutting selection..."));

  slotStatusMsg(i18n("Ready."));
}

void PPPGraphApp::slotEditCopy()
{
  slotStatusMsg(i18n("Copying selection to Clipboard..."));

  slotStatusMsg(i18n("Ready."));
}

void PPPGraphApp::slotEditPaste()
{
  slotStatusMsg(i18n("Inserting Clipboard contents..."));

  slotStatusMsg(i18n("Ready."));
}

void PPPGraphApp::slotViewToolBar()
{
  ///////////////////////////////////////////////////////////////////
  // turn Toolbar on or off
	if( view_menu->isItemChecked(ID_VIEW_TOOLBAR))
	  view_menu->setItemChecked(ID_VIEW_TOOLBAR, false);
	else
		view_menu->setItemChecked(ID_VIEW_TOOLBAR, true);
		
  enableToolBar();

  slotStatusMsg(i18n("Ready."));
}

void PPPGraphApp::slotViewStatusBar()
{
  ///////////////////////////////////////////////////////////////////
  //turn Statusbar on or off
	if( view_menu->isItemChecked(ID_VIEW_STATUSBAR))
	  view_menu->setItemChecked(ID_VIEW_STATUSBAR, false);
	else
		view_menu->setItemChecked(ID_VIEW_STATUSBAR, true);

  enableStatusBar();

  slotStatusMsg(i18n("Ready."));
}


void PPPGraphApp::slotStatusMsg(const char *text)
{
  ///////////////////////////////////////////////////////////////////
  // change status message permanently
  statusBar()->clear();
  statusBar()->changeItem(text, ID_STATUS_MSG );
}


void PPPGraphApp::slotStatusHelpMsg(const char *text)
{
  ///////////////////////////////////////////////////////////////////
  // change status message of whole statusbar temporary (text, msec)
  statusBar()->message(text, 2000);
}



void PPPGraphApp::commandCallback(int id_){
  switch (id_){
    case ID_FILE_NEW_WINDOW:
    	slotFileNewWindow();
    	break;
    case ID_FILE_NEW:
    	slotFileNew();
    	break;
    case ID_FILE_OPEN:
    	slotFileOpen();
    	break;
    case ID_FILE_SAVE:
    	slotFileSave();
    	break;
    case ID_FILE_SAVE_AS:
    	slotFileSaveAs();
    	break;
    case ID_FILE_CLOSE:
    	slotFileClose();
    	break;
    case ID_FILE_PRINT:
    	slotFilePrint();
    	break;
    case ID_FILE_QUIT:
    	slotFileQuit();
    	break;

    case ID_EDIT_CUT:
    	slotEditCut();
    	break;
    case ID_EDIT_COPY:
    	slotEditCopy();
    	break;
    case ID_EDIT_PASTE:
    	slotEditPaste();
    	break;
  
    case ID_VIEW_TOOLBAR:
    	slotViewToolBar();
    	break;
    case ID_VIEW_STATUSBAR:
    	slotViewStatusBar();
    	break;
    default:
    	break;
  }
}

void PPPGraphApp::statusCallback(int id_){
  switch (id_){
    case ID_FILE_NEW_WINDOW:
    	slotStatusHelpMsg(i18n("Opens a new application window"));
    	break;
    case ID_FILE_NEW:
 	  	slotStatusHelpMsg(i18n("Creates a new document"));
 	  	break;
    case ID_FILE_OPEN:
 	  	slotStatusHelpMsg(i18n("Opens an existing document"));
 	  	break;
    case ID_FILE_OPEN_RECENT:
 	  	slotStatusHelpMsg(i18n("Opens a recently used file"));
 	  	break;
    case ID_FILE_SAVE:
 	  	slotStatusHelpMsg(i18n("Save the actual document"));
 	  	break;
    case ID_FILE_SAVE_AS:
 	  	slotStatusHelpMsg(i18n("Save the document as..."));
 	  	break;
    case ID_FILE_CLOSE:
    	slotStatusHelpMsg(i18n("Closes the actual file"));
    	break;
    case ID_FILE_PRINT:
    	slotStatusHelpMsg(i18n("Prints the current document"));
    	break;
    case ID_FILE_QUIT:{
    	QString caption=kapp->getCaption();
    	slotStatusHelpMsg(i18n("Exits "+ caption));
    	break;
    }
    case ID_EDIT_CUT:
    	slotStatusHelpMsg(i18n("Cuts the selected section and puts it to the clipboard"));
    	break;
    case ID_EDIT_COPY:
    	slotStatusHelpMsg(i18n("Copys the selected section to the clipboard"));
    	break;
    case ID_EDIT_PASTE:
    	slotStatusHelpMsg(i18n("Pastes the clipboard contents to actual position"));
    	break;

    case ID_VIEW_TOOLBAR:
    	slotStatusHelpMsg(i18n("Enables / disables the actual Toolbar"));
    	break;
    case ID_VIEW_STATUSBAR:
    	slotStatusHelpMsg(i18n("Enables / disables the actual Statusbar"));
    	break;
		default:
			break;
  }
}



























