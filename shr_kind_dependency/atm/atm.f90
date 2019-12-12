module atm

  use lilac, only : lilac_in, lilac_out
  implicit none
  private

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


program atm_program
  use atm, only : atm_driver
  implicit none

  call atm_driver()
end program atm_program
