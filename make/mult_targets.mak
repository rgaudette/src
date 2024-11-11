LIST = one two three

all: $(LIST)

$(LIST):
	@echo $@
