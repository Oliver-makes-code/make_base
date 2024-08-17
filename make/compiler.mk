COMPILER := $(or $(COMPILER),clang)

ifeq ($(COMPILER),clang)
	CC = clang
	CXX = clang++
else ifeq ($(COMPILER),gcc)
	CC = gcc
	CXX = g++
else
	_ := $(error Unsupported compiler)
endif
