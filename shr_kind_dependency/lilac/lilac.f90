module lilac

  use shr_kind_mod, only : r8
  use ctsm, only : call_ctsm
  implicit none

  public :: call_lilac

contains

  subroutine call_lilac(x)
    real(r8), intent(in) :: x

    call call_ctsm(x)
  end subroutine call_lilac
end module lilac
