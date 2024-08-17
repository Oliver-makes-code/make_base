-include make/util.mk

-include make/platform.mk

-include make/compiler.mk

ASFLAGS = 
CFLAGS = -O3 $(DEFINES) $(foreach DIR,$(INCLUDE_DIRS),-I$(DIR)) -MMD -g
CXXFLAGS = $(CFLAGS) -std=c++20

LDLIBS = $(foreach LIB,$(LIBS),-l$(LIB))
LDFLAGS = -L. -O3 -g

OBJECTS = $(call ofile,$(SRC_DIR))

EXE = $(if $(BUILD_DIR),$(BUILD_DIR)/)$(PROGRAM)

.DEFAULT_GOAL = $(EXE)

$(OBJ_DIR)/%.o:
	-$(call mkdir,$(dir $@))
	$(call compiler,$@) $(call flags,$@) -c -o $@ $(call source_file,$@)

$(EXE): $(OBJECTS)
	-$(call mkdir,$(dir $@))
	-$(if $(call rwildcard,$(LIB_DIR),*),$(COPY) $(call rwildcard,$(LIB_DIR),*) $(patsubst $(LIB_DIR)%,$(BUILD_DIR)%,$(call rwildcard,$(LIB_DIR),*)))
	$(if $(foreach OBJ,$(OBJECTS),$(wildcard $(OBJ))),$(CXX) -o $(EXE) $(OBJECTS) $(LDFLAGS) $(LDLIBS))

clean:
	-$(RM) $(OBJECTS) $(OBJECTS:%.o=%.d) $(EXE) $(patsubst $(LIB_DIR)%,$(BUILD_DIR)%,$(call rwildcard,$(LIB_DIR),*))

run: $(EXE)
	./$(EXE)

cleanbuild: clean $(EXE)
cleanrun: clean run

-include $(foreach OBJ,$(OBJECTS:%.o=%.d),$(wildcard $(OBJ)))
