SUBDIRS = calcSSNR FairReference ImodSort MotlAvg StalkInit VolAvg VolRotate

.PHONY: subdirs $(SUBDIRS)

# target dependent variables
clean: makeArg = clean
dist: makeArg = dist
install: makeArg = install
install_beta: makeArg = install_beta
install_test: makeArg = install_test

# Default target all subdirs
subdirs: $(SUBDIRS)

include ../buildEnv
include particleBuildEnv

clean: $(SUBDIRS)
	rm -rf dist *~ semantic.cache

dist:  $(SUBDIRS) install_sub

install: $(SUBDIRS) install_sub

install_beta: $(SUBDIRS) install_sub

install_test: $(SUBDIRS) install_sub

install_sub: mkdirs
	cp particle.cfg $(InstallDir)


$(SUBDIRS):
	$(MAKE) -C $@ $(makeArg)
