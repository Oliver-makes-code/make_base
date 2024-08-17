OS_TYPE := WINDOWS

prepare_filepath=$(call make_windows,$1)

LIBS += $(LIBS_WINDOWS)

RM := del

COPY := copy
