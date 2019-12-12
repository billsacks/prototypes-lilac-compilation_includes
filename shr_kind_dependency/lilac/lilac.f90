module lilac

  use shr_kind_mod, only : r8 => shr_kind_r8
  use ctsm, only : ctsm_in, ctsm_out
  implicit none
  private

  public :: lilac_in, lilac_out

contains

  subroutine lilac_in(x)
    real(r8), intent(in) :: x

    call ctsm_in(x)
  end subroutine lilac_in

  subroutine lilac_out(x)
    real(r8), intent(out) :: x

    call ctsm_out(x)
  end subroutine lilac_out
end module lilac
