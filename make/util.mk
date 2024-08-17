# recursively filds files
rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2)$(filter $(subst *,%,$2),$d))

ofile_ext=$(patsubst $(SRC_DIR)/%.$2,$(OBJ_DIR)/%.o,$(call rwildcard,$1,*.$2))

ofile=$(call ofile_ext,$1,cpp) $(call ofile_ext,$1,c) $(call ofile_ext,$1,s)

mkdir=$(if $(wildcard $(call prepare_filepath,$1)),,mkdir $(call prepare_filepath,$1))

# makes unix paths into windows paths
make_windows = $(subst /,\,$1)

null =
space = $(null) $(null)
define \n


endef

# splits a list into newlines
split_newline = $(subst $(space),$(\n),$1)

# returns $2 if $1 exists, else $3
find_file = $(or $(and $(wildcard $1),$2),$3)

make_s = $(patsubst $(OBJ_DIR)/%.o,$(SRC_DIR)/%.s,$1)
make_c = $(patsubst $(OBJ_DIR)/%.o,$(SRC_DIR)/%.c,$1)
make_cpp = $(patsubst $(OBJ_DIR)/%.o,$(SRC_DIR)/%.cpp,$1)

source_file = $(call find_file,$(call make_cpp,$1),$(call make_cpp,$1),$(call find_file,$(call make_c,$1),$(call make_c,$1),$(call find_file,$(call make_s,$1),$(call make_s,$1),$(null))))
compiler = $(call find_file,$(call make_cpp,$1),$(CXX),$(call find_file,$(call make_c,$1),$(CC),$(call find_file,$(call make_s,$1),$(AS),echo)))
flags = $(call find_file,$(call make_cpp,$1),$(CXXFLAGS),$(call find_file,$(call make_c,$1),$(CFLAGS),$(call find_file,$(call make_s,$1),$(ASFLAGS),)))
