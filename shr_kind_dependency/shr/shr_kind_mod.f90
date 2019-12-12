module shr_kind_mod

  implicit none
  private

  public :: do_something

  integer, parameter, public :: shr_kind_r8 = selected_real_kind(12)

contains
  subroutine do_something(x)
    ! Included to avoid empty library file
    integer :: x

    print *, x
  end subroutine do_something

end module shr_kind_mod
