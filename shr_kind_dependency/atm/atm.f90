module atm

  use lilac, only : lilac_in, lilac_out
  implicit none

  public :: atm_driver

contains

  subroutine atm_driver()
    real*8 :: x

    x = 3

    call lilac_in(x)
    call lilac_out(x)

    print *, x
  end subroutine atm_driver
end module atm
