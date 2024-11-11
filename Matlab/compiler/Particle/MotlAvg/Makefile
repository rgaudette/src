mce = motlavg_mce

$(mce): $(mce).m

include ../../buildEnv
include ../particleBuildEnv

install_sub: install_mce
	cp -p motl_average $(InstallDir)/bin
	cp -p motl_average.tmpl $(InstallDir)/templates
	cp -p motl_average.stmpl $(InstallDir)/templates

clean: clean_mcc clean_mce
