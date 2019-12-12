lilac.a: lilac.o lilac_internal.o
	ar -r $@ $^

lilac.o: lilac_internal.o

lilac_internal.o: lilac_internal.f90
	$(FC) -I../shr -I../ctsm -c $<

lilac.o: lilac.f90
	$(FC) -I../shr -I../ctsm -c $<
