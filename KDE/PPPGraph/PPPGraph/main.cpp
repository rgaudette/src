
#include "pppgraph.h"
 
int main(int argc, char* argv[]) { 
  KApplication app(argc,argv,"pppgraph");
 
  if (app.isRestored())
    { 
      RESTORE(PPPGraphApp);
    }
  else 
    {
      PPPGraphApp* pppgraph = new PPPGraphApp;
      pppgraph->show();
      if(argc > 1){
      	pppgraph->openDocumentFile(argv[1]);
			}
    }
  return app.exec();
}  
 













