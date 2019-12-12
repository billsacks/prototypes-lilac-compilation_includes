atm.exe: atm.o
	$(FC) -o $@ $^ -L../lilac -llilac -L../ctsm -lctsm -L../shr -lshr

atm.o: atm.f90
	$(FC) -I../lilac -I../ctsm -I../shr -c $<
