subdirs := shr ctsm lilac atm

all: $(subdirs)
ctsm: shr
lilac: ctsm shr
atm: lilac
$(subdirs):
	$(MAKE) -C $@

.PHONY: all $(subdirs) clean
clean:
	rm -f */*.o */*.mod
