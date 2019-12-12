subdirs := shr

all: $(subdirs)
$(subdirs):
	$(MAKE) -C $@

.PHONY: all $(subdirs) clean
clean:
	rm -f */*.o */*.mod
