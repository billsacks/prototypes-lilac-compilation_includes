module lilac

  use lilac_internal, only : lilac_internal_in, lilac_internal_out
  implicit none
  private

  public :: lilac_in, lilac_out

contains

  subroutine lilac_in(x)
    real*8, intent(in) :: x

    call lilac_internal_in(x)
  end subroutine lilac_in

  subroutine lilac_out(x)
    real*8, intent(out) :: x

    call lilac_internal_out(x)
  end subroutine lilac_out
end module lilac
