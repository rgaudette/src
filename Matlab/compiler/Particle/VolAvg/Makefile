mce = volavg_mce

$(mce): $(mce).m

include ../../buildEnv
include ../particleBuildEnv

install_sub: install_mce
	cp -p volume_average $(InstallDir)/bin
	cp -p volume_average.tmpl $(InstallDir)/templates
	cp -p volume_average.stmpl $(InstallDir)/templates

clean: clean_mcc clean_mce
