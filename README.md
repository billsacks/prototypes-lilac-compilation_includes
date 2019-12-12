## Purpose of this repository

This repository tests which directories need to be included in include
paths for an atmosphere model that is linking to LILAC.

## Details of the problem

The atmosphere needs to directly use two LILAC modules: `lilac_mod` and
`lilac_atmcap`. But these use other lilac / ctsm / share modules of two
varieties: (1) subroutines that they call; (2) kind definitions used in
subroutine interfaces.

I ran into trouble compiling the test atmosphere driver with intel if my
include paths only pointed to the directory containing mod files for
CTSM, and didn't also point to the directory containing mod files for
the share code, due to the need to have r8 defined for the interface of
one of the directly-used subroutines. On the other hand, I ran into
trouble in WRF when I had an include line that pointed to a directory
containing mod files for all CTSM sources, because there were multiple
definitions of symbols (specifically, when compiling WRF's source file
that defines its version of CLM). I could see this being an issue in
general, if there ever happen to be name collisions between the
atmosphere model and CTSM module names.

## Details of what we're testing here

There are two separate test cases here:

1. `shr_kind_dependency`: This is a control case that captures the
   current situation, where the directly-used LILAC code has a
   dependency on `shr_kinds_mod` for kinds in its interface, in addition
   to dependencies on modules used for subroutines that it calls.
   
2. `no_shr_kind_dependency`: This is what I want to test: I'm hoping
   this will show that we can get away with having more limited includes
   from the atmosphere driver.
   
Both have similar subdirectory structures:

1. `shr`: has a module that defines r8 kind

2. `ctsm`: has a module that defines a subroutine, which also uses r8 in
   its interface
   
3. `lilac`: has a module that defines a subroutine, which calls the
   subroutine in `ctsm`; in the `shr_kind_dependency` version, it also
   uses r8 in its interface; in the `no_shr_kind_dependency` version, it
   does not.
   
4. `atm`: directly uses `lilac`, but not `ctsm` or `shr`

I'm hoping to show that, in the `shr_kind_dependency` case, the include
line for `atm` needs to include `shr` as well as `lilac`, but shouldn't
need to include `ctsm`. In the `no_shr_kind_dependency` case, I hope the
include line for `atm` only needs to include `lilac`.
