DEPENDENCY_ROOT ?= ${HOME}/sandbox/3rdParty

ifndef OS
	OS:= $(shell uname -s)
endif

ifeq ($(OS),Linux)
	PARALLEL:=$(shell echo $$((`grep -c ^processor /proc/cpuinfo` / 2 + 1)))
	ifeq ($(CC),gcc)
		COMPILER:=$(shell gcc --version | head -n1  | awk '{print $$3}' | awk -F. '{print $$1 $$2}')
	else
		COMPILER:= $(CC)
	endif
else ifeq ($(OS),Darwin)
	PARALLEL:=$(shell sysctl hw.ncpu | awk '{print $$2}')
	ifeq ($(CC),cc)
		#COMPILER:=$(shell llvm-gcc --version | head -n 1 | grep -o "clang-[0-9.-]*")
		COMPILER:=clang-600
	else
		COMPILER:= $(CC)
	endif
else
	$(error Unsupported operating system)
endif

MAKEOPTS:=-j $(PARALLEL)

ARCH_TAG:=x86_64
ARCH:=64
ARCH_FLAG:=-m$(ARCH)

OSVER:=$(shell expr `uname -r` : '\([0-9][0-9]*\.[0-9][0-9]*\).*')
PLATFORM:=$(OS)-$(OSVER)-$(ARCH_TAG)-$(COMPILER)

# build/Darwin-13.4-x86_64-gcc-4.8
# build/Darwin-13.4-x86_64-clang-3.5
BUILD_DIR:=$(MAIN_DIR)/build/$(OS_TAG)

# where common packages live
# 3Party/Darwin-13.4-x86_64-gcc-4.8
# 3Party/Darwin-13.4-x86_64-clang-3.5
ifndef PKG_ROOT
	PKG_ROOT:=$(DEPENDENCY_ROOT)/$(PLATFORM)
endif

# version of packages on which the build depends
include $(MAIN_DIR)/version.mk

INCLUDE += \
$(PKG_ROOT)/boost/$(boost_VER)/include \
$(PKG_ROOT)/gmock/$(gmock_VER)/include

LD:=$(CXX)
LDFLAGS+=$(ARCH_FLAG)
CPPFLAGS+=$(ARCH_FLAG)
CXXFLAGS+=-std=c++11

INC_DIR:=$(MAIN_DIR)/include
SRC_DIR:=$(MAIN_DIR)/src
BIN_DIR:=$(MAIN_DIR)/bin
LIB_DIR:=$(MAIN_DIR)/lib
TEST_DIR:=$(MAIN_DIR)/test

UNIT_TEST_DIR:=$(TEST_DIR)/unittest
PERF_TEST_DIR:=$(TEST_DIR)/performance

# TODO: fix this
LIBS+=$(LIB_PATHS)

empty:=
space:= $(empty) $(empty)
LD_LIBRARY_PATH:=$(LD_LIBRARY_PATH):$(subst $(space),,$(subst  -L,:,$(filter -L%,$(LIBS)))):$(subst $(space),,$(subst  -L,:,$(filter -L%,$(LIB_PATHS))))
