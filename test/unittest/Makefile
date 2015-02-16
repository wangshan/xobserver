.PHONY: all test depend check checkmain gdbcheckmain clean distclean vars

MAIN_DIR=../..

include $(MAIN_DIR)/common.mk
include $(TEST_DIR)/common.mk

###### target and source definition

BUILD_DIR:=$(BUILD_DIR)/unittest

PROG_SOURCES:=$(wildcard $(UNIT_TEST_DIR)/[a-zA-Z]*.cpp)
PROG_OBJECTS:=$(addprefix $(BUILD_DIR)/,$(notdir $(PROG_SOURCES:.cpp=.o)))
PROG_DEPENDS:=$(addprefix $(BUILD_DIR)/,$(notdir $(PROG_SOURCES:.cpp=.d)))

PROG_INCLUDE:=$(INCLUDE)
PROG_LIB_DIR:=
PROG_LIBS:=	

CPPFLAGS+=$(foreach includedir,$(PROG_INCLUDE),-I$(includedir))
LDFLAGS+=$(foreach libdir,$(PROG_LIB_DIR),-L$(libdir))
LDFLAGS+=$(foreach lib, $(PROG_LIBS),-l$(lib))

testmain=testmain-$(PLATFORM) 

all: test

test: $(testmain)

$(testmain): $(BUILD_DIR)/testmain.o
	$(LD) $< $(LDFLAGS) -o $@

check: checkmain 

checkmain: $(testmain)
	$(call runcheck,./$<)

gdbcheckmain: $(testmain)
	$(call rungdbcheck,./$<)

runcheck=LD_LIBRARY_PATH=$(LD_LIBRARY_PATH) $(1) --gtest_output=xml:testresults.xml --gtest_repeat=$(REPEAT) $(TESTS)
rungdbcheck=LD_LIBRARY_PATH=$(LD_LIBRARY_PATH) $(GDB) --args $(1) --gtest_output=xml:testresults.xml --gtest_repeat=$(REPEAT) $(TESTS)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%.d: %.cpp | $(BUILD_DIR)
	$(CXX) -MM $(CPPFLAGS) $(CXXFLAGS) -MT $(BUILD_DIR)/$*.o -o $@ $<

$(BUILD_DIR)/%.o: %.cpp $(BUILD_DIR)/%.d | $(BUILD_DIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

depend: $(PROG_DEPENDS)

clean: 
	$(RM) $(testmain)
	$(RM) $(PROG_OBJECTS)
	$(RM) testresults.xml

distclean: clean
	$(RM) $(PROG_DEPENDS)

vars:
	@echo LD_LIBRARY_PATH=$(LD_LIBRARY_PATH)
	ldd $(testmain)

# build dependency except when doing cleaning
ifneq (,$(filter-out depend clean distclean vars,$(MAKECMDGOALS)))
  include $(PROG_DEPENDS)
endif
