# Shows an example of how to copy multiple files to multiple source when
# the source file is newer

SOURCES = file1.txt file2.txt
SOURCE_DIR = src_dir
DEST_DIR = dest_dir_1
SRC_PATHS = $(addprefix $(SOURCE_DIR)/, $(SOURCES))
DEST_PATHS = $(addprefix $(DEST_DIR)/, $(SOURCES))

.PHONY: all
all: $(DEST_PATHS)

$(DEST_PATHS): $(DEST_DIR)/%: $(SOURCE_DIR)/%
	cp $< $@

#vpath %.txt $(SOURCE_DIR)
.PHONY: print_var
print_var:
	@echo $(SOURCES)
	@echo $(SOURCE_DIR)
	@echo $(DEST_DIR)
	@echo $(SRC_PATHS)
	@echo $(DEST_PATHS)
