! atmosphere's version of ctsm

module ctsm

  implicit none
  private

  public :: ctsm_in
  public :: ctsm_out

contains

  subroutine ctsm_in(x)
    integer, intent(in) :: x

    print *, "atmosphere's version: ", x
  end subroutine ctsm_in

  subroutine ctsm_out(x)
    integer, intent(out) :: x

    x = 170
  end subroutine ctsm_out
end module ctsm
