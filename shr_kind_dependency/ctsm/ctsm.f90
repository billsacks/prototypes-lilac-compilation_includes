module ctsm

  use shr_kind_mod, only : r8
  implicit none

  public :: call_ctsm

contains

  subroutine call_ctsm(x)
    real(r8) :: x

    print *, x
  end subroutine call_ctsm
end module ctsm
