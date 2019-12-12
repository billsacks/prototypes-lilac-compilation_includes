subdirs := shr ctsm lilac

all: $(subdirs)
ctsm: shr
lilac: ctsm shr
$(subdirs):
	$(MAKE) -C $@

.PHONY: all $(subdirs) clean
clean:
	rm -f */*.o */*.mod
