libshr.a: shr_kind_mod.o
	ar -r $@ $^

shr_kind_mod.o: shr_kind_mod.f90
	$(FC) -c $<

