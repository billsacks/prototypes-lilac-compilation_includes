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

module ctsm
  implicit none
  private

  public :: ctsm_in

contains

  subroutine ctsm_in(x)
    integer, intent(in) :: x

    print *, 'atm driver ctsm_in: ', x
  end subroutine ctsm_in
end module ctsm

program atm_program
  use atm, only : atm_driver
  use ctsm, only : ctsm_in
  implicit none

  call atm_driver()
  call ctsm_in(42)
end program atm_program
