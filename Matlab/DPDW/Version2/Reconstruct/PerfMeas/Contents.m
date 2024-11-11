%DPDW Reconstruction Performance Measures
%-----------------------------------------------------------------------------
%BCKERR         Mean square background error
%CALCERR        2-norm of the error normalized by the object function 2-norm
%DEPTHERR       2-norm of the error as a function of depth
%MSE            Mean Square Error per pixel
%OBJCTRERR      Center of mass error for a set of object function estimates
%OBJECT_ERR     2-norm of the error over the object relative to obj. fct. 2-norm
%PEAKOBJCTRERR  Center of mass difference between largest objects
%PVERR          Peak value error
%PVOBJERR       Peak value error over the object region
%SELOBJCTRERR   Center of mass difference between specified objects
%RESIDUAL       2-norm of the residual
%
%
%Utiltiy functions
%-----------------------------------------------------------------------------
%FINDBIGOBJ     Find the indices of the biggest object
%FINDOBJECT     Find the indices of the specified object
%FINDOBJLIST    Find the object voxel list
%FINDOBJPEAK    Find the subscripts for the peak value in a 3D object function
%OBJCTR         Compute the center of mass of an an object
%RECOBJSRCH     Recursive object search