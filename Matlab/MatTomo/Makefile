

.PHONY: dist clean

dist: clean
	tar czvf MatTomo.tgz --exclude CVS 'Docs/MatTomo Users Guide.html' \@Imod* \@MRCImage Utils

clean:
	find . -name "*~" -exec rm -rf {} \;

