subdirs := shr ctsm

all: $(subdirs)
ctsm: shr
$(subdirs):
	$(MAKE) -C $@

.PHONY: all $(subdirs) clean
clean:
	rm -f */*.o */*.mod
