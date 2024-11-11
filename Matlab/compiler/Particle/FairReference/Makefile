mce = fairReference_mce

$(mce): $(mce).m

include ../../buildEnv
include ../particleBuildEnv

install_sub: install_mce
	cp -p fairReference $(InstallDir)/bin
	cp -p fairReference.tmpl $(InstallDir)/templates
	cp -p fairReference.stmpl $(InstallDir)/templates

clean: clean_mcc clean_mce
