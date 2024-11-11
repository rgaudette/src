####### kdevelop will overwrite this part!!! (begin)##########
bin_PROGRAMS = pppgraph
pppgraph_SOURCES = pppgraphview.cpp pppgraphdoc.cpp pppgraph.cpp main.cpp 
pppgraph_LDADD   =  -lkfile -lkfm -lkdeui -lkdecore -lqt -lXext -lX11 $(LIBSOCKET)

SUBDIRS = docs 

EXTRA_DIST = main.cpp pppgraph.cpp pppgraph.h pppgraphdoc.cpp pppgraphdoc.h pppgraphview.cpp pppgraphview.h resource.h pppgraph.kdelnk pppgraph.xpm mini-pppgraph.xpm 

install-data-local:
	$(mkinstalldirs) $(kde_appsdir)/Applications/
	$(INSTALL_DATA) pppgraph.kdelnk $(kde_appsdir)/Applications/pppgraph.kdelnk
	$(mkinstalldirs) $(kde_icondir)/
	$(INSTALL_DATA) pppgraph.xpm $(kde_icondir)/pppgraph.xpm
	$(mkinstalldirs) $(kde_minidir)/
	$(INSTALL_DATA) mini-pppgraph.xpm $(kde_minidir)/pppgraph.xpm

uninstall-local:
	-rm -f $(kde_appsdir)/Applications/pppgraph.kdelnk
	-rm -f $(kde_icondir)/pppgraph.xpm
	-rm -f $(kde_minidir)/pppgraph.xpm

####### kdevelop will overwrite this part!!! (end)############
# this 10 paths are KDE specific. Use them:
# kde_htmldir       Where your docs should go to. (contains lang subdirs)
# kde_appsdir       Where your application file (.kdelnk) should go to. 
# kde_icondir       Where your icon should go to.
# kde_minidir       Where your mini icon should go to.
# kde_datadir       Where you install application data. (Use a subdir)
# kde_locale        Where translation files should go to.(contains lang subdirs)
# kde_cgidir        Where cgi-bin executables should go to.
# kde_confdir       Where config files should go to.
# kde_mimedir       Where mimetypes should go to.
# kde_toolbardir    Where general toolbar icons should go to.
# kde_wallpaperdir  Where general wallpapers should go to.

# set the include path for X, qt and KDE
INCLUDES= $(all_includes)
# claim, which subdirectories you want to install
# you can add here more. This one gets installed 
bin_PROGRAMS = pppgraph 

pppgraph_METASOURCES = USE_AUTOMOC

# the library search path. 
pppgraph_LDFLAGS = $(all_libraries) $(KDE_RPATH)

# them while "make clean", use CLEANFILES
DISTCLEANFILES = $(pppgraph_METASOURCES)

# make messages.po. Move this one to ../po/ and "make merge" in po
# the -x is for skipping messages already translated in kdelibs
messages:
	$(XGETTEXT) -C -ki18n -x $(KDEDIR)/include/kde.pot `find . -name \*.h -o -name \*.cpp -o -name \*.cc` -o ../po/pppgraph.pot 

