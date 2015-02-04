!        generated by tapenade     (inria, tropics team)
!  tapenade 3.10 (r5363) -  9 sep 2014 09:53
!
!  differentiation of xhalo_block in forward (tangent) mode (with options i4 dr8 r8):
!   variations   of useful results: *x
!   with respect to varying inputs: *x
!   rw status of diff variables: *x:in-out
!   plus diff mem management of: x:in
!
!      ******************************************************************
!      *                                                                *
!      * file:          xhalo.f90                                       *
!      * author:        edwin van der weide,c.a.(sandy) mader            *
!      * starting date: 02-23-2003                                      *
!      * last modified: 08-12-2009                                      *
!      *                                                                *
!      ******************************************************************
!
subroutine xhalo_block_d()
!
!      ******************************************************************
!      *                                                                *
!      * xhalo determines the coordinates of the nodal halo's.          *
!      * first it sets all halo coordinates by simple extrapolation,    *
!      * then the symmetry planes are treated (also the unit normal of  *
!      * symmetry planes are determined) and finally an exchange is     *
!      * made for the internal halo's.                                  *
!      *                                                                *
!      ******************************************************************
!
  use blockpointers
  use bctypes
  use communication
  use inputtimespectral
  implicit none
!
!      local variables.
!
  integer(kind=inttype) :: mm, i, j, k
  integer(kind=inttype) :: ibeg, iend, jbeg, jend, iimax, jjmax
  logical :: err
  real(kind=realtype) :: length, dot
  real(kind=realtype) :: dotd
  real(kind=realtype), dimension(3) :: v1, v2, norm
  real(kind=realtype), dimension(3) :: v1d
  intrinsic sqrt
  real(kind=realtype) :: arg1
! extrapolation in i-direction.
  do k=1,kl
    do j=1,jl
      xd(0, j, k, 1) = two*xd(1, j, k, 1) - xd(2, j, k, 1)
      x(0, j, k, 1) = two*x(1, j, k, 1) - x(2, j, k, 1)
      xd(0, j, k, 2) = two*xd(1, j, k, 2) - xd(2, j, k, 2)
      x(0, j, k, 2) = two*x(1, j, k, 2) - x(2, j, k, 2)
      xd(0, j, k, 3) = two*xd(1, j, k, 3) - xd(2, j, k, 3)
      x(0, j, k, 3) = two*x(1, j, k, 3) - x(2, j, k, 3)
      xd(ie, j, k, 1) = two*xd(il, j, k, 1) - xd(nx, j, k, 1)
      x(ie, j, k, 1) = two*x(il, j, k, 1) - x(nx, j, k, 1)
      xd(ie, j, k, 2) = two*xd(il, j, k, 2) - xd(nx, j, k, 2)
      x(ie, j, k, 2) = two*x(il, j, k, 2) - x(nx, j, k, 2)
      xd(ie, j, k, 3) = two*xd(il, j, k, 3) - xd(nx, j, k, 3)
      x(ie, j, k, 3) = two*x(il, j, k, 3) - x(nx, j, k, 3)
    end do
  end do
! extrapolation in j-direction.
  do k=1,kl
    do i=0,ie
      xd(i, 0, k, 1) = two*xd(i, 1, k, 1) - xd(i, 2, k, 1)
      x(i, 0, k, 1) = two*x(i, 1, k, 1) - x(i, 2, k, 1)
      xd(i, 0, k, 2) = two*xd(i, 1, k, 2) - xd(i, 2, k, 2)
      x(i, 0, k, 2) = two*x(i, 1, k, 2) - x(i, 2, k, 2)
      xd(i, 0, k, 3) = two*xd(i, 1, k, 3) - xd(i, 2, k, 3)
      x(i, 0, k, 3) = two*x(i, 1, k, 3) - x(i, 2, k, 3)
      xd(i, je, k, 1) = two*xd(i, jl, k, 1) - xd(i, ny, k, 1)
      x(i, je, k, 1) = two*x(i, jl, k, 1) - x(i, ny, k, 1)
      xd(i, je, k, 2) = two*xd(i, jl, k, 2) - xd(i, ny, k, 2)
      x(i, je, k, 2) = two*x(i, jl, k, 2) - x(i, ny, k, 2)
      xd(i, je, k, 3) = two*xd(i, jl, k, 3) - xd(i, ny, k, 3)
      x(i, je, k, 3) = two*x(i, jl, k, 3) - x(i, ny, k, 3)
    end do
  end do
! extrapolation in k-direction.
  do j=0,je
    do i=0,ie
      xd(i, j, 0, 1) = two*xd(i, j, 1, 1) - xd(i, j, 2, 1)
      x(i, j, 0, 1) = two*x(i, j, 1, 1) - x(i, j, 2, 1)
      xd(i, j, 0, 2) = two*xd(i, j, 1, 2) - xd(i, j, 2, 2)
      x(i, j, 0, 2) = two*x(i, j, 1, 2) - x(i, j, 2, 2)
      xd(i, j, 0, 3) = two*xd(i, j, 1, 3) - xd(i, j, 2, 3)
      x(i, j, 0, 3) = two*x(i, j, 1, 3) - x(i, j, 2, 3)
      xd(i, j, ke, 1) = two*xd(i, j, kl, 1) - xd(i, j, nz, 1)
      x(i, j, ke, 1) = two*x(i, j, kl, 1) - x(i, j, nz, 1)
      xd(i, j, ke, 2) = two*xd(i, j, kl, 2) - xd(i, j, nz, 2)
      x(i, j, ke, 2) = two*x(i, j, kl, 2) - x(i, j, nz, 2)
      xd(i, j, ke, 3) = two*xd(i, j, kl, 3) - xd(i, j, nz, 3)
      x(i, j, ke, 3) = two*x(i, j, kl, 3) - x(i, j, nz, 3)
    end do
  end do
  v1d = 0.0_8
!
!          **************************************************************
!          *                                                            *
!          * mirror the halo coordinates adjacent to the symmetry       *
!          * planes                                                     *
!          *                                                            *
!          **************************************************************
!
! loop over boundary subfaces.
loopbocos:do mm=1,nbocos
! the actual correction of the coordinates only takes
! place for symmetry planes.
    if (bctype(mm) .eq. symm) then
! set some variables, depending on the block face on
! which the subface is located.
      norm(1) = bcdata(mm)%symnorm(1)
      norm(2) = bcdata(mm)%symnorm(2)
      norm(3) = bcdata(mm)%symnorm(3)
      arg1 = norm(1)**2 + norm(2)**2 + norm(3)**2
      length = sqrt(arg1)
! compute the unit normal of the subface.
      norm(1) = norm(1)/length
      norm(2) = norm(2)/length
      norm(3) = norm(3)/length
! see xhalo_block for comments for below:
      if (length .gt. eps) then
        select case  (bcfaceid(mm)) 
        case (imin) 
          ibeg = jnbeg(mm)
          iend = jnend(mm)
          iimax = jl
          jbeg = knbeg(mm)
          jend = knend(mm)
          jjmax = kl
          if (ibeg .eq. 1) ibeg = 0
          if (iend .eq. iimax) iend = iimax + 1
          if (jbeg .eq. 1) jbeg = 0
          if (jend .eq. jjmax) jend = jjmax + 1
          do j=jbeg,jend
            do i=ibeg,iend
              v1d(1) = xd(1, i, j, 1) - xd(2, i, j, 1)
              v1(1) = x(1, i, j, 1) - x(2, i, j, 1)
              v1d(2) = xd(1, i, j, 2) - xd(2, i, j, 2)
              v1(2) = x(1, i, j, 2) - x(2, i, j, 2)
              v1d(3) = xd(1, i, j, 3) - xd(2, i, j, 3)
              v1(3) = x(1, i, j, 3) - x(2, i, j, 3)
              dotd = two*(norm(1)*v1d(1)+norm(2)*v1d(2)+norm(3)*v1d(3))
              dot = two*(v1(1)*norm(1)+v1(2)*norm(2)+v1(3)*norm(3))
              xd(0, i, j, 1) = xd(2, i, j, 1) + norm(1)*dotd
              x(0, i, j, 1) = x(2, i, j, 1) + dot*norm(1)
              xd(0, i, j, 2) = xd(2, i, j, 2) + norm(2)*dotd
              x(0, i, j, 2) = x(2, i, j, 2) + dot*norm(2)
              xd(0, i, j, 3) = xd(2, i, j, 3) + norm(3)*dotd
              x(0, i, j, 3) = x(2, i, j, 3) + dot*norm(3)
            end do
          end do
        case (imax) 
          ibeg = jnbeg(mm)
          iend = jnend(mm)
          iimax = jl
          jbeg = knbeg(mm)
          jend = knend(mm)
          jjmax = kl
          if (ibeg .eq. 1) ibeg = 0
          if (iend .eq. iimax) iend = iimax + 1
          if (jbeg .eq. 1) jbeg = 0
          if (jend .eq. jjmax) jend = jjmax + 1
          do j=jbeg,jend
            do i=ibeg,iend
              v1d(1) = xd(il, i, j, 1) - xd(nx, i, j, 1)
              v1(1) = x(il, i, j, 1) - x(nx, i, j, 1)
              v1d(2) = xd(il, i, j, 2) - xd(nx, i, j, 2)
              v1(2) = x(il, i, j, 2) - x(nx, i, j, 2)
              v1d(3) = xd(il, i, j, 3) - xd(nx, i, j, 3)
              v1(3) = x(il, i, j, 3) - x(nx, i, j, 3)
              dotd = two*(norm(1)*v1d(1)+norm(2)*v1d(2)+norm(3)*v1d(3))
              dot = two*(v1(1)*norm(1)+v1(2)*norm(2)+v1(3)*norm(3))
              xd(ie, i, j, 1) = xd(nx, i, j, 1) + norm(1)*dotd
              x(ie, i, j, 1) = x(nx, i, j, 1) + dot*norm(1)
              xd(ie, i, j, 2) = xd(nx, i, j, 2) + norm(2)*dotd
              x(ie, i, j, 2) = x(nx, i, j, 2) + dot*norm(2)
              xd(ie, i, j, 3) = xd(nx, i, j, 3) + norm(3)*dotd
              x(ie, i, j, 3) = x(nx, i, j, 3) + dot*norm(3)
            end do
          end do
        case (jmin) 
          ibeg = inbeg(mm)
          iend = inend(mm)
          iimax = il
          jbeg = knbeg(mm)
          jend = knend(mm)
          jjmax = kl
          if (ibeg .eq. 1) ibeg = 0
          if (iend .eq. iimax) iend = iimax + 1
          if (jbeg .eq. 1) jbeg = 0
          if (jend .eq. jjmax) jend = jjmax + 1
          do j=jbeg,jend
            do i=ibeg,iend
              v1d(1) = xd(i, 1, j, 1) - xd(i, 2, j, 1)
              v1(1) = x(i, 1, j, 1) - x(i, 2, j, 1)
              v1d(2) = xd(i, 1, j, 2) - xd(i, 2, j, 2)
              v1(2) = x(i, 1, j, 2) - x(i, 2, j, 2)
              v1d(3) = xd(i, 1, j, 3) - xd(i, 2, j, 3)
              v1(3) = x(i, 1, j, 3) - x(i, 2, j, 3)
              dotd = two*(norm(1)*v1d(1)+norm(2)*v1d(2)+norm(3)*v1d(3))
              dot = two*(v1(1)*norm(1)+v1(2)*norm(2)+v1(3)*norm(3))
              xd(i, 0, j, 1) = xd(i, 2, j, 1) + norm(1)*dotd
              x(i, 0, j, 1) = x(i, 2, j, 1) + dot*norm(1)
              xd(i, 0, j, 2) = xd(i, 2, j, 2) + norm(2)*dotd
              x(i, 0, j, 2) = x(i, 2, j, 2) + dot*norm(2)
              xd(i, 0, j, 3) = xd(i, 2, j, 3) + norm(3)*dotd
              x(i, 0, j, 3) = x(i, 2, j, 3) + dot*norm(3)
            end do
          end do
        case (jmax) 
          ibeg = inbeg(mm)
          iend = inend(mm)
          iimax = il
          jbeg = knbeg(mm)
          jend = knend(mm)
          jjmax = kl
          if (ibeg .eq. 1) ibeg = 0
          if (iend .eq. iimax) iend = iimax + 1
          if (jbeg .eq. 1) jbeg = 0
          if (jend .eq. jjmax) jend = jjmax + 1
          do j=jbeg,jend
            do i=ibeg,iend
              v1d(1) = xd(i, jl, j, 1) - xd(i, ny, j, 1)
              v1(1) = x(i, jl, j, 1) - x(i, ny, j, 1)
              v1d(2) = xd(i, jl, j, 2) - xd(i, ny, j, 2)
              v1(2) = x(i, jl, j, 2) - x(i, ny, j, 2)
              v1d(3) = xd(i, jl, j, 3) - xd(i, ny, j, 3)
              v1(3) = x(i, jl, j, 3) - x(i, ny, j, 3)
              dotd = two*(norm(1)*v1d(1)+norm(2)*v1d(2)+norm(3)*v1d(3))
              dot = two*(v1(1)*norm(1)+v1(2)*norm(2)+v1(3)*norm(3))
              xd(i, je, j, 1) = xd(i, ny, j, 1) + norm(1)*dotd
              x(i, je, j, 1) = x(i, ny, j, 1) + dot*norm(1)
              xd(i, je, j, 2) = xd(i, ny, j, 2) + norm(2)*dotd
              x(i, je, j, 2) = x(i, ny, j, 2) + dot*norm(2)
              xd(i, je, j, 3) = xd(i, ny, j, 3) + norm(3)*dotd
              x(i, je, j, 3) = x(i, ny, j, 3) + dot*norm(3)
            end do
          end do
        case (kmin) 
          ibeg = inbeg(mm)
          iend = inend(mm)
          iimax = il
          jbeg = jnbeg(mm)
          jend = jnend(mm)
          jjmax = jl
          if (ibeg .eq. 1) ibeg = 0
          if (iend .eq. iimax) iend = iimax + 1
          if (jbeg .eq. 1) jbeg = 0
          if (jend .eq. jjmax) jend = jjmax + 1
          do j=jbeg,jend
            do i=ibeg,iend
              v1d(1) = xd(i, j, 1, 1) - xd(i, j, 2, 1)
              v1(1) = x(i, j, 1, 1) - x(i, j, 2, 1)
              v1d(2) = xd(i, j, 1, 2) - xd(i, j, 2, 2)
              v1(2) = x(i, j, 1, 2) - x(i, j, 2, 2)
              v1d(3) = xd(i, j, 1, 3) - xd(i, j, 2, 3)
              v1(3) = x(i, j, 1, 3) - x(i, j, 2, 3)
              dotd = two*(norm(1)*v1d(1)+norm(2)*v1d(2)+norm(3)*v1d(3))
              dot = two*(v1(1)*norm(1)+v1(2)*norm(2)+v1(3)*norm(3))
              xd(i, j, 0, 1) = xd(i, j, 2, 1) + norm(1)*dotd
              x(i, j, 0, 1) = x(i, j, 2, 1) + dot*norm(1)
              xd(i, j, 0, 2) = xd(i, j, 2, 2) + norm(2)*dotd
              x(i, j, 0, 2) = x(i, j, 2, 2) + dot*norm(2)
              xd(i, j, 0, 3) = xd(i, j, 2, 3) + norm(3)*dotd
              x(i, j, 0, 3) = x(i, j, 2, 3) + dot*norm(3)
            end do
          end do
        case (kmax) 
          ibeg = inbeg(mm)
          iend = inend(mm)
          iimax = il
          jbeg = jnbeg(mm)
          jend = jnend(mm)
          jjmax = jl
          if (ibeg .eq. 1) ibeg = 0
          if (iend .eq. iimax) iend = iimax + 1
          if (jbeg .eq. 1) jbeg = 0
          if (jend .eq. jjmax) jend = jjmax + 1
          do j=jbeg,jend
            do i=ibeg,iend
              v1d(1) = xd(i, j, kl, 1) - xd(i, j, nz, 1)
              v1(1) = x(i, j, kl, 1) - x(i, j, nz, 1)
              v1d(2) = xd(i, j, kl, 2) - xd(i, j, nz, 2)
              v1(2) = x(i, j, kl, 2) - x(i, j, nz, 2)
              v1d(3) = xd(i, j, kl, 3) - xd(i, j, nz, 3)
              v1(3) = x(i, j, kl, 3) - x(i, j, nz, 3)
              dotd = two*(norm(1)*v1d(1)+norm(2)*v1d(2)+norm(3)*v1d(3))
              dot = two*(v1(1)*norm(1)+v1(2)*norm(2)+v1(3)*norm(3))
              xd(i, j, ke, 1) = xd(i, j, nz, 1) + norm(1)*dotd
              x(i, j, ke, 1) = x(i, j, nz, 1) + dot*norm(1)
              xd(i, j, ke, 2) = xd(i, j, nz, 2) + norm(2)*dotd
              x(i, j, ke, 2) = x(i, j, nz, 2) + dot*norm(2)
              xd(i, j, ke, 3) = xd(i, j, nz, 3) + norm(3)*dotd
              x(i, j, ke, 3) = x(i, j, nz, 3) + dot*norm(3)
            end do
          end do
        end select
      end if
    end if
  end do loopbocos
end subroutine xhalo_block_d
