
#ifndef PPPGRAPHDOC_H
#define PPPGRAPHDOC_H

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif 

// include files for QT
#include <qobject.h>
#include <qstring.h>
#include <qlist.h>

// forward declaration of the PPPGraph classes
class PPPGraphView;

/**	PPPGraphDoc provides a document object for a document-view model.
  *
	* The PPPGraphDoc class provides a document object that can be used in conjunction with the classes PPPGraphApp and PPPGraphView
	* to create a document-view model for standard KDE applications based on KApplication and KTMainWindow. Thereby, the document object
	* is created by the PPPGraphApp instance and contains the document structure with the according methods for manipulation of the document
	* data by PPPGraphView objects. Also, PPPGraphDoc contains the methods for serialization of the document data from and to files.
	*
	* @author Source Framework Automatically Generated by KDevelop, (c) The KDevelop Team. 	
	* @version KDevelop version 0.4 code generation
	*/
class PPPGraphDoc : public QObject
{
  Q_OBJECT

 public:
  /** Constructor for the fileclass of the application */
  PPPGraphDoc(QWidget* parent, const char *name=0);
  /** Destructor for the fileclass of the application */
  ~PPPGraphDoc();
	/** adds a view to the document which represents the document contents. Usually this is your main view. */
  void addView(PPPGraphView* m_pView);
	/** removes a view from the list of currently connected views */
	void removeView(PPPGraphView* m_pView);
  /** sets the modified flag for the document after a modifying action on the view connected to the document.*/
  void setModified(bool modified=true){ b_modified=modified; }
	/** returns if the document is modified or not. Use this to determine if your document needs saving by the user on closing.*/
  bool isModified(){ return b_modified;}
	/** "save modified" - asks the user for saving if the document is modified */
	bool saveModified();	
	/** deletes the document's contents */
	void deleteContents();
	/** initializes the document generally */
	bool newDocument();
	/** closes the acutal document */
	void closeDocument();
	/** loads the document by filename and format and emits the updateViews() signal */
  bool openDocument(const char* filename, const char* format=0);
  /** saves the document under filename and format.*/	
  bool saveDocument(const char* filename, const char* format=0);
	/** sets the path to the file connected with the document */
	void pathName(const char* path_name);
	/** returns the pathname of the current document file*/
	const QString& getPathName() const;
	/** sets the filename of the document */
	void title(const char* title);
	/** returns the title of the document */
	const QString& getTitle() const;
	
 public slots:
 	/** calls repaint() on all views connected to the document object and is called by the view by which the document has been changed.
 	  * As this view normally repaints itself, it is excluded from the paintEvent. */
 	void slotUpdateAllViews(PPPGraphView* pSender);
 	
 public:	
 	/** the list of the views currently connected to the document */
	static QList<PPPGraphView>* viewList;	
 private:
 	/** the modified flag of the current document */
 	bool b_modified;
	QString m_title;
	QString m_path;

};

#endif // PPPGRAPHDOC_H




















