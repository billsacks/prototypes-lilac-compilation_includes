atm.exe: atm.o
	$(FC) -o $@ $^ -L../atm_lib -latm -L../lilac -llilac -L../ctsm -lctsm -L../shr -lshr

atm.o: atm.f90
	$(FC) -I../atm_lib -I../lilac -I../ctsm -I../shr -c $<
