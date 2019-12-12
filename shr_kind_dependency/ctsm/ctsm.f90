module ctsm

  use shr_kind_mod, only : r8 => shr_kind_r8
  implicit none
  private

  public :: ctsm_in
  public :: ctsm_out

contains

  subroutine ctsm_in(x)
    real(r8), intent(in) :: x

    print *, x
  end subroutine ctsm_in

  subroutine ctsm_out(x)
    real(r8), intent(out) :: x

    x = 17
  end subroutine ctsm_out
end module ctsm
