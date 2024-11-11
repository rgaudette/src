mce = stalkinit_mce

$(mce): $(mce).m

include ../../buildEnv
include ../particleBuildEnv

install_sub: install_mce
	cp -p stalk_init $(InstallDir)/bin
	cp -p stalk_init.tmpl $(InstallDir)/templates
	cp -p stalk_init.stmpl $(InstallDir)/templates

clean: clean_mcc clean_mce
