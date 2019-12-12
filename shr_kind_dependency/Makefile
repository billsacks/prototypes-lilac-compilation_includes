subdirs := shr ctsm lilac atm_lib atm

all: $(subdirs)
ctsm: shr
lilac: ctsm shr
atm: atm_lib lilac
$(subdirs):
	$(MAKE) -C $@

.PHONY: all $(subdirs) clean
clean:
	rm -f */*.o */*.mod */*.a */*.exe
