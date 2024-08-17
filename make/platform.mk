ifeq ($(OS),Windows_NT)
-include make/platform/windows.mk
else ifeq ($(OS),Darwin)
-include make/platform/macos.mk
else
-include make/platform/linux.mk
endif

DEFINES += -D $(OS_TYPE)
