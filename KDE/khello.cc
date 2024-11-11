#include <kapp.h>
#include <ktmainwindow.h>

int main(int argc, char *argv[])
{  
  KApplication a(argc, argv);
  KTMainWindow *w = new KTMainWindow();
  w->setGeometry(100,100,200,100);
  a.setMainWidget(w);
  w->show();
  return a.exec();
}
