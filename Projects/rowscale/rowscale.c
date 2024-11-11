#include <mex.h>


void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
     mxArray  *array_ptr;
 double    value_in_first_array, value_in_second_array; 
 
 /* Get the value of the first element in both input arrays. */ 
   value_in_first_array = mxGetScalar(prhs[0]); 
   value_in_second_array = mxGetScalar(prhs[1]); 
   if (value_in_first_array > value_in_second_array)
     mexPrintf("%g is greater than %g.\n", 
                 value_in_first_array, value_in_second_array);  
   else 
     mexPrintf("%g is not greater than %g.\n", 
                 value_in_first_array, value_in_second_array);
}
/* END */
