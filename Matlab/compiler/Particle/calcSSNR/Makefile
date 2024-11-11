mce = calcSSNR_mce

$(mce): $(mce).m

include ../../buildEnv
include ../particleBuildEnv

install_sub: install_mce
	cp -p calcSSNR $(InstallDir)/bin
	cp -p calcSSNR.tmpl $(InstallDir)/templates
	cp -p calcSSNR.stmpl $(InstallDir)/templates

clean: clean_mcc clean_mce
