! Program: cmdline
!
! A simple fortran application to test interaction with a C++ module that parses
! command line and config file arguments into callable dictionary

!      program cmdline
!      implicit none
      
      integer iArg 
      character*32 arg
      character*32 result

!     Intialize the command line parser
      call initialize()

      do iArg=1,iargc(),1
         call getarg(iArg, arg)
         call addargument(arg, 32, result, 32)
      enddo
      end
!      end program cmdline
