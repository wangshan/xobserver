.PHONY: all clean distclean test check depend unittest unittest-depend unittest-check performance performance-depend performance-check

MAIN_DIR=..

include $(MAIN_DIR)/common.mk

UNITTEST_DIR:=$(UNIT_TEST_DIR)
PERFORMANCE_DIR:=$(PERF_TEST_DIR)


all:
	$(MAKE) $(MAKEOPTS) -C $(UNITTEST_DIR) $@
	$(MAKE) $(MAKEOPTS) -C $(PERFORMANCE_DIR) $@

clean:
	$(MAKE) -C $(UNITTEST_DIR) $@
	$(MAKE) -C $(PERFORMANCE_DIR) $@

distclean: clean

depend: unittest-depend performance-depend

unittest-depend:
	$(MAKE) -C $(UNITTEST_DIR) depend

performance-depend:
	$(MAKE) -C $(PERFORMANCE_DIR) depend

test: unittest performance

unittest:
	$(MAKE) $(MAKEOPTS) -C $(UNITTEST_DIR) test

performance:
	$(MAKE) $(MAKEOPTS) -C $(PERFORMANCE_DIR) test

unittest-check:
	$(MAKE) $(MAKEOPTS) -C $(UNITTEST_DIR) check

performance-check:
	$(MAKE) $(MAKEOPTS) -C $(PERFORMANCE_DIR) check

check: unittest-check performance-check
