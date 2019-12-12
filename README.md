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

The original intent was to have two separate test cases here:

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

However, I have ended up not creating the `no_shr_kind_dependency`
directory, because with pgi I ran into trouble even with the indirect
use of ctsm code in the `shr_kind_dependency` case; this wouldn't have
changed in the `no_shr_kind_dependency` case.

## Compiling

To compile one of the tests, cd to the appropriate test directory, then
run something like:

`make FC=gfortran all`

## Results

### `shr_kind_dependency`

#### gfortran 8.2.0 on my Mac

Works with only `-I../lilac` in the compilation of atm.

This is true in commits 0803cdc, 41f7e06 and 01c96e4.

#### ifort 19.0.2 on cheyenne

In commit 0803cdc, works with only `-I../lilac` in the compilation of
atm.

However, in commit 41f7e06, which makes some tweaks to be more close to
the actual code, I am able to reproduce the error:

```
atm.f90(3): error #7002: Error in opening the compiled module file.  Check INCLUDE paths.   [SHR_KIND_MOD]
  use lilac, only : lilac_in, lilac_out
------^
```

I determined that the problem is the rename of `shr_kind_r8` to `r8`
(see branch `rename_shr_kind`).

But in commit 01c96e4 this works again. The difference in this commit
is that module visibility is private by default.

#### pgi 19.3 on cheyenne

In commit 01c96e4 this does NOT work. I get:

```
pgf90 -I../lilac -c atm.f90
PGF90-F-0004-Unable to open MODULE file ctsm.mod (atm.f90: 4)
```

So pgi seems to want us to include modules indirectly used by the
directly-used lilac modules.

Commit 1282a63, where I split lilac into a separate internal module,
doesn't help: I was hoping that I could satisfy pgi by having the atm
build include everything that it needed directly and 1-level indirectly,
but I get the same error as before - so it seems we need to include
further levels of indirect uses.

In 86c7661, pgi works (and gnu and intel still work, too): this adds
`-I../ctsm` and `-I../shr` to the atm include line.

## Conclusions

If we have symbol renames in use statements, then we need to be careful
to make modules have default private visibility. This default private
visibility is good practice in general, and we should do it regardless.

However, even with this, pgi still wants us to include modules
indirectly used by the directly-used lilac modules.

## Exploring link-time issues

### Collision at link-time

If I introduce the following diffs (see branch link_issues):

```diff
diff --git a/shr_kind_dependency/atm/atm.f90 b/shr_kind_dependency/atm/atm.f90
index 97f4349..9b79bc4 100644
--- a/shr_kind_dependency/atm/atm.f90
+++ b/shr_kind_dependency/atm/atm.f90
@@ -20,10 +20,26 @@ subroutine atm_driver()
   end subroutine atm_driver
 end module atm

+module ctsm
+  implicit none
+  private
+
+  public :: ctsm_in
+
+contains
+
+  subroutine ctsm_in(x)
+    integer, intent(in) :: x
+
+    print *, 'atm driver ctsm_in: ', x
+  end subroutine ctsm_in
+end module ctsm

 program atm_program
   use atm, only : atm_driver
+  use ctsm, only : ctsm_in
   implicit none

   call atm_driver()
+  call ctsm_in(42)
 end program atm_program
```

Then I get a failure at link-time (with gfortran):

```
gfortran -o atm.exe atm.o -L../lilac -llilac -L../ctsm -lctsm -L../shr -lshr
duplicate symbol '___ctsm_MOD_ctsm_in' in:
    atm.o
    ../ctsm/libctsm.a(ctsm.o)
ld: 1 duplicate symbol for architecture x86_64
collect2: error: ld returned 1 exit status
make[1]: *** [atm.exe] Error 1
make: *** [atm] Error 2
```

I get this same failure regardless of whether the -I line for atm
includes ../ctsm or not. i.e., I get this failure even with this
additional diff:

```diff
diff --git a/shr_kind_dependency/atm/Makefile b/shr_kind_dependency/atm/Makefile
index c9cb7fb..eec55a6 100644
--- a/shr_kind_dependency/atm/Makefile
+++ b/shr_kind_dependency/atm/Makefile
@@ -2,4 +2,4 @@ atm.exe: atm.o
        $(FC) -o $@ $^ -L../lilac -llilac -L../ctsm -lctsm -L../shr -lshr

 atm.o: atm.f90
-       $(FC) -I../lilac -I../ctsm -I../shr -c $<
+       $(FC) -I../lilac -c $<
```

The issue is resolved if I rename the module in ctsm (even without
renaming the file). The issue is also resolved if subroutines are named
differently: it appears that the issue arises if there are collisions in
the module+subroutine name combination.

### Avoiding collision at link-time

In branch link_issues2 I avoid the collision at link-time by putting the
atmosphere's ctsm code into its own library, and having the same
interface as the real ctsm code. This links the executable, but at
runtime, the wrong thing happens: lilac ends up calling the atmosphere's
version rather than its own.

I then made another commit where I changed the interface of the
subroutines in the atmosphere's ctsm. This still avoids the link issues,
but operates even more incorrectly:

```
$ atm/atm.exe
 atmosphere's version:            0
   3.0000000000000755
 atmosphere's version:          402
         170
```
