
EXEEXT=

pyui_files= documentdetails.py

%.py : %.ui
	pyuic $< >$@


bin_PROGRAMS = pythonqt_test
pythonqt_test_SOURCES = pythonqt_test.py documentdetails.ui

pythonqt_test$(EXEEXT): $(pyui_files)
	echo "Done"
