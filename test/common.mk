##### compilation parameters

GDB:=gdb

UNITTEST_DIR:=$(UNIT_TEST_DIR)
PERFORMANCE_DIR:=$(PERF_TEST_DIR)

LD_LIBRARY_PATH:=$(LD_LIBRARY_PATH):$(MAIN_DIR)/lib

LDFLAGS+=$(LIB_PATHS) $(LIBS) -lpthread -lc -ldl 

INCLUDE+=$(SRC_DIR) $(INC_DIR)

DEBUG_CPPFLAGS:=-g3 -ggdb3 -fno-eliminate-unused-debug-types

# removed -Wconversion because it's too noisy
CPPFLAGS+=-fPIC -Wall -Wformat=2 -Wsign-promo -Wcast-qual $(DEBUG_CPPFLAGS)
