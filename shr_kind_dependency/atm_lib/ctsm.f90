! atmosphere's version of ctsm

module ctsm

  implicit none
  private

  public :: ctsm_in
  public :: ctsm_out

contains

  subroutine ctsm_in(x)
    real*8, intent(in) :: x

    print *, "atmosphere's version: ", x
  end subroutine ctsm_in

  subroutine ctsm_out(x)
    real*8, intent(out) :: x

    x = 170
  end subroutine ctsm_out
end module ctsm
