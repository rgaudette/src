mce = imodsort_mce

$(mce): $(mce).m

include ../../buildEnv
include ../particleBuildEnv

install_sub: install_mce
	cp -p imodsortpts $(InstallDir)/bin

clean: clean_mcc clean_mce
