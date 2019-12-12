module atm

  use lilac, only : call_lilac
  implicit none

  public :: atm_driver

contains

  subroutine atm_driver(x)
    real*8, intent(in) :: x

    call call_lilac(x)
  end subroutine atm_driver
end module atm
