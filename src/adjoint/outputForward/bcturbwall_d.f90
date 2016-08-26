!        generated by tapenade     (inria, tropics team)
!  tapenade 3.10 (r5363) -  9 sep 2014 09:53
!
!  differentiation of bcturbwall in forward (tangent) mode (with options i4 dr8 r8):
!   variations   of useful results: *bvtj1 *bvtj2 *bvtk1 *bvtk2
!                *bvti1 *bvti2
!   with respect to varying inputs: *bvtj1 *bvtj2 *w *rlv *bvtk1
!                *bvtk2 *bvti1 *bvti2
!   plus diff mem management of: bvtj1:in bvtj2:in w:in rlv:in
!                bvtk1:in bvtk2:in bvti1:in bvti2:in bcdata:in
subroutine bcturbwall_d(nn)
!
!       bcturbwall applies the implicit treatment of the viscous       
!       wall boundary condition for the turbulence model used to the   
!       given subface nn.                                              
!       it is assumed that the pointers in blockpointers are           
!       already set to the correct block.                              
!
  use blockpointers
  use flowvarrefstate
  use inputphysics
  use constants
  use paramturb
  implicit none
!
!      subroutine arguments.
!
  integer(kind=inttype), intent(in) :: nn
!
!      local variables.
!
  integer(kind=inttype) :: i, j, ii, jj, iimax, jjmax
  real(kind=realtype) :: tmpd, tmpe, tmpf, nu
  real(kind=realtype) :: nud
  real(kind=realtype), dimension(:, :, :, :), pointer :: bmt
  real(kind=realtype), dimension(:, :, :), pointer :: bvt, ww2
  real(kind=realtype), dimension(:, :), pointer :: rlv2, dd2wall
  intrinsic min
  intrinsic max
  integer(kind=inttype) :: y12
  integer(kind=inttype) :: y11
  integer(kind=inttype) :: y10
  integer(kind=inttype) :: y9
  integer(kind=inttype) :: y8
  integer(kind=inttype) :: y7
  integer(kind=inttype) :: y6
  integer(kind=inttype) :: y5
  integer(kind=inttype) :: y4
  integer(kind=inttype) :: y3
  integer(kind=inttype) :: y2
  integer(kind=inttype) :: y1
!        ================================================================
! determine the turbulence model used and loop over the faces
! of the subface and set the values of bmt and bvt for an
! implicit treatment.
  select case  (turbmodel) 
  case (spalartallmaras, spalartallmarasedwards) 
! spalart-allmaras type of model. value at the wall is zero,
! so simply negate the internal value.
    select case  (bcfaceid(nn)) 
    case (imin) 
      do j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
        do i=bcdata(nn)%icbeg,bcdata(nn)%icend
          bmti1(i, j, itu1, itu1) = one
        end do
      end do
    case (imax) 
      do j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
        do i=bcdata(nn)%icbeg,bcdata(nn)%icend
          bmti2(i, j, itu1, itu1) = one
        end do
      end do
    case (jmin) 
      do j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
        do i=bcdata(nn)%icbeg,bcdata(nn)%icend
          bmtj1(i, j, itu1, itu1) = one
        end do
      end do
    case (jmax) 
      do j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
        do i=bcdata(nn)%icbeg,bcdata(nn)%icend
          bmtj2(i, j, itu1, itu1) = one
        end do
      end do
    case (kmin) 
      do j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
        do i=bcdata(nn)%icbeg,bcdata(nn)%icend
          bmtk1(i, j, itu1, itu1) = one
        end do
      end do
    case (kmax) 
      do j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
        do i=bcdata(nn)%icbeg,bcdata(nn)%icend
          bmtk2(i, j, itu1, itu1) = one
        end do
      end do
    end select
  case (komegawilcox, komegamodified, mentersst) 
!        ================================================================
! k-omega type of models. k is zero on the wall and thus the
! halo value is the negative of the first internal cell.
! for omega the situation is a bit more complicated.
! theoretically omega is infinity, but it is set to a large
! value, see menter's paper. the halo value is constructed
! such that the wall value is correct. make sure that i and j
! are limited to physical dimensions of the face for the wall
! distance. due to the usage of the dd2wall pointer and the
! fact that the original d2wall array starts at 2, there is
! an offset of -1 present in dd2wall.
    select case  (bcfaceid(nn)) 
    case (imin) 
      iimax = jl
      jjmax = kl
      do j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
        if (j .gt. jjmax) then
          y1 = jjmax
        else
          y1 = j
        end if
        if (2 .lt. y1) then
          jj = y1
        else
          jj = 2
        end if
        do i=bcdata(nn)%icbeg,bcdata(nn)%icend
          if (i .gt. iimax) then
            y2 = iimax
          else
            y2 = i
          end if
          if (2 .lt. y2) then
            ii = y2
          else
            ii = 2
          end if
          nud = (rlvd(2, i, j)*w(2, i, j, irho)-rlv(2, i, j)*wd(2, i, j&
&           , irho))/w(2, i, j, irho)**2
          nu = rlv(2, i, j)/w(2, i, j, irho)
          tmpd = one/(rkwbeta1*d2wall(2, ii, jj)**2)
          bmti1(i, j, itu1, itu1) = one
          bmti1(i, j, itu2, itu2) = one
          bvti1d(i, j, itu2) = two*60.0_realtype*tmpd*nud
          bvti1(i, j, itu2) = two*60.0_realtype*nu*tmpd
        end do
      end do
    case (imax) 
      iimax = jl
      jjmax = kl
      do j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
        if (j .gt. jjmax) then
          y3 = jjmax
        else
          y3 = j
        end if
        if (2 .lt. y3) then
          jj = y3
        else
          jj = 2
        end if
        do i=bcdata(nn)%icbeg,bcdata(nn)%icend
          if (i .gt. iimax) then
            y4 = iimax
          else
            y4 = i
          end if
          if (2 .lt. y4) then
            ii = y4
          else
            ii = 2
          end if
          nud = (rlvd(jl, i, j)*w(il, i, j, irho)-rlv(jl, i, j)*wd(il, i&
&           , j, irho))/w(il, i, j, irho)**2
          nu = rlv(jl, i, j)/w(il, i, j, irho)
          tmpd = one/(rkwbeta1*d2wall(il, ii, jj)**2)
          bmti2(i, j, itu1, itu1) = one
          bmti2(i, j, itu2, itu2) = one
          bvti2d(i, j, itu2) = two*60.0_realtype*tmpd*nud
          bvti2(i, j, itu2) = two*60.0_realtype*nu*tmpd
        end do
      end do
    case (jmin) 
      iimax = il
      jjmax = kl
      do j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
        if (j .gt. jjmax) then
          y5 = jjmax
        else
          y5 = j
        end if
        if (2 .lt. y5) then
          jj = y5
        else
          jj = 2
        end if
        do i=bcdata(nn)%icbeg,bcdata(nn)%icend
          if (i .gt. iimax) then
            y6 = iimax
          else
            y6 = i
          end if
          if (2 .lt. y6) then
            ii = y6
          else
            ii = 2
          end if
          nud = (rlvd(i, 2, j)*w(i, 2, j, irho)-rlv(i, 2, j)*wd(i, 2, j&
&           , irho))/w(i, 2, j, irho)**2
          nu = rlv(i, 2, j)/w(i, 2, j, irho)
          tmpd = one/(rkwbeta1*d2wall(ii, 2, jj)**2)
          bmtj1(i, j, itu1, itu1) = one
          bmtj1(i, j, itu2, itu2) = one
          bvtj1d(i, j, itu2) = two*60.0_realtype*tmpd*nud
          bvtj1(i, j, itu2) = two*60.0_realtype*nu*tmpd
        end do
      end do
    case (jmax) 
      iimax = il
      jjmax = kl
      do j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
        if (j .gt. jjmax) then
          y7 = jjmax
        else
          y7 = j
        end if
        if (2 .lt. y7) then
          jj = y7
        else
          jj = 2
        end if
        do i=bcdata(nn)%icbeg,bcdata(nn)%icend
          if (i .gt. iimax) then
            y8 = iimax
          else
            y8 = i
          end if
          if (2 .lt. y8) then
            ii = y8
          else
            ii = 2
          end if
          nud = (rlvd(i, jl, j)*w(i, jl, j, irho)-rlv(i, jl, j)*wd(i, jl&
&           , j, irho))/w(i, jl, j, irho)**2
          nu = rlv(i, jl, j)/w(i, jl, j, irho)
          tmpd = one/(rkwbeta1*d2wall(ii, jl, jj)**2)
          bmtj2(i, j, itu1, itu1) = one
          bmtj2(i, j, itu2, itu2) = one
          bvtj2d(i, j, itu2) = two*60.0_realtype*tmpd*nud
          bvtj2(i, j, itu2) = two*60.0_realtype*nu*tmpd
        end do
      end do
    case (kmin) 
      iimax = il
      jjmax = jl
      do j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
        if (j .gt. jjmax) then
          y9 = jjmax
        else
          y9 = j
        end if
        if (2 .lt. y9) then
          jj = y9
        else
          jj = 2
        end if
        do i=bcdata(nn)%icbeg,bcdata(nn)%icend
          if (i .gt. iimax) then
            y10 = iimax
          else
            y10 = i
          end if
          if (2 .lt. y10) then
            ii = y10
          else
            ii = 2
          end if
          nud = (rlvd(i, j, 2)*w(i, j, 2, irho)-rlv(i, j, 2)*wd(i, j, 2&
&           , irho))/w(i, j, 2, irho)**2
          nu = rlv(i, j, 2)/w(i, j, 2, irho)
          tmpd = one/(rkwbeta1*d2wall(ii, jj, 2)**2)
          bmtk1(i, j, itu1, itu1) = one
          bmtk1(i, j, itu2, itu2) = one
          bvtk1d(i, j, itu2) = two*60.0_realtype*tmpd*nud
          bvtk1(i, j, itu2) = two*60.0_realtype*nu*tmpd
        end do
      end do
    case (kmax) 
      iimax = il
      jjmax = jl
      do j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
        if (j .gt. jjmax) then
          y11 = jjmax
        else
          y11 = j
        end if
        if (2 .lt. y11) then
          jj = y11
        else
          jj = 2
        end if
        do i=bcdata(nn)%icbeg,bcdata(nn)%icend
          if (i .gt. iimax) then
            y12 = iimax
          else
            y12 = i
          end if
          if (2 .lt. y12) then
            ii = y12
          else
            ii = 2
          end if
          nud = (rlvd(i, j, kl)*w(i, j, kl, irho)-rlv(i, j, kl)*wd(i, j&
&           , kl, irho))/w(i, j, kl, irho)**2
          nu = rlv(i, j, kl)/w(i, j, kl, irho)
          tmpd = one/(rkwbeta1*d2wall(ii, jj, kl)**2)
          bmtk2(i, j, itu1, itu1) = one
          bmtk2(i, j, itu2, itu2) = one
          bvtk2d(i, j, itu2) = two*60.0_realtype*tmpd*nud
          bvtk2(i, j, itu2) = two*60.0_realtype*nu*tmpd
        end do
      end do
    end select
  case (ktau) 
!        ================================================================
! k-tau model. both k and tau are zero at the wall, so the
! negative value of the internal cell is taken for the halo.
    select case  (bcfaceid(nn)) 
    case (imin) 
      do j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
        do i=bcdata(nn)%icbeg,bcdata(nn)%icend
          bmti1(i, j, itu1, itu1) = one
          bmti1(i, j, itu2, itu2) = one
        end do
      end do
    case (imax) 
      do j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
        do i=bcdata(nn)%icbeg,bcdata(nn)%icend
          bmti2(i, j, itu1, itu1) = one
          bmti2(i, j, itu2, itu2) = one
        end do
      end do
    case (jmin) 
      do j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
        do i=bcdata(nn)%icbeg,bcdata(nn)%icend
          bmtj1(i, j, itu1, itu1) = one
          bmtj1(i, j, itu2, itu2) = one
        end do
      end do
    case (jmax) 
      do j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
        do i=bcdata(nn)%icbeg,bcdata(nn)%icend
          bmtj2(i, j, itu1, itu1) = one
          bmtj2(i, j, itu2, itu2) = one
        end do
      end do
    case (kmin) 
      do j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
        do i=bcdata(nn)%icbeg,bcdata(nn)%icend
          bmtk1(i, j, itu1, itu1) = one
          bmtk1(i, j, itu2, itu2) = one
        end do
      end do
    case (kmax) 
      do j=bcdata(nn)%jcbeg,bcdata(nn)%jcend
        do i=bcdata(nn)%icbeg,bcdata(nn)%icend
          bmtk2(i, j, itu1, itu1) = one
          bmtk2(i, j, itu2, itu2) = one
        end do
      end do
    end select
  end select
end subroutine bcturbwall_d
