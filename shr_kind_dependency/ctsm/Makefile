libctsm.a: ctsm.o
	ar -r $@ $^

ctsm.o: ctsm.f90
	$(FC) -I../shr -c $<
