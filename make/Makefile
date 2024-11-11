
LIST = one two three

all: $(LIST)

#all:
#	@for i in $(LIST); \
#	do \
#		echo $$i; \
#	done

.ONESHELL:
.PHONY: singleshell
singleshell: 
	@for i in $(LIST); \
	do \
		echo $$i; \
	done

$(LIST):
  echo $@
