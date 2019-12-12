module lilac_internal

  use shr_kind_mod, only : r8 => shr_kind_r8
  use ctsm, only : ctsm_in, ctsm_out

  implicit none
  private

  public :: lilac_internal_in, lilac_internal_out

contains

  subroutine lilac_internal_in(x)
    real(r8), intent(in) :: x

    call ctsm_in(x)
  end subroutine lilac_internal_in

  subroutine lilac_internal_out(x)
    real(r8), intent(out) :: x

    call ctsm_out(x)
  end subroutine lilac_internal_out

end module lilac_internal
