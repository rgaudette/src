my_var = "A string"
V1 = True
V2 = "true"

ifeq ($(my_var),  "A string")
	test = $(V1) $(V2)
else
	test = "false"
endif

.PHONY: all

all:
	@echo $(test)
