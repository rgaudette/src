/**************************************************************/
/*                                                            */
/* Program: gen_gauss_cdf.c                                   */
/* Author: David Hoag                                         */
/* Date: 1/14/95                                              */
/*                                                            */
/* Purpose: Generate Cumulative Distribution Function (CDF)   */
/*          of the Generalized Gaussian distribution using    */
/*          the Incomplete Gamma Function. The density is     */
/*          defined as:                                       */
/*                                                            */
/*                 p(x) = a*exp(-abs(b*x)^c)                  */
/*                                                            */
/*          where: a = b*c/(2*gamma(1/c))                     */
/*                 b = sqrt(gamma(3/c)/gamma(1/c)) / sigma    */
/*                                                            */
/*          It also writes both the cdf and pdf to MATLAB     */
/*          files.                                            */
/*                                                            */
/**************************************************************/

#include <stdio.h>
#include <math.h>
#define SIGMA 1
#define NUM_SAMPLES 10001 
#define UP_ENDPT 20

/* Declare return values of functions */
double gammp();
double gammln();

main(int argc, char **argv)
{
float a,b,c;
FILE *matlab_fp;
int i;
float delta, center_pt, rand_number, gen_gauss_rv;
float pdf[NUM_SAMPLES], cdf[NUM_SAMPLES];

/* Read in exponent */
c = atof(argv[1]);

b = 1/SIGMA*sqrt(exp(gammln(3/c)-gammln(1/c)));
a = b*c/(2*exp(gammln(1/c)));

printf("a=%f , b=%f\n\n",a ,b); 

/* Open MATLAB file for the pdf and cdf data */
matlab_fp = fopen("gen_gauss.m","w");

fprintf(matlab_fp,"data = [\n");

/* Compute pdf and cdf for the random variable. First compute
those for the point X=0, then compute the rest in a symmetric
fashion about the zero point. */

delta = (float) (2*UP_ENDPT)/(float) (NUM_SAMPLES-1);
center_pt = (float) (NUM_SAMPLES-1)/2;

cdf[(int) center_pt]=.5 + .5*gammp(1/c,pow(b,c)*pow(0.0,c));
pdf[(int) center_pt]= a*exp(-pow((b*0.0),c));

for (i=1;i<=center_pt;i++)
    {
    cdf[(int) center_pt+i] = .5 + .5*gammp(1/c,pow(b,c)*pow(delta*i,c)); 
    cdf[(int) center_pt-i] = .5 - .5*gammp(1/c,pow(b,c)*pow(delta*i,c));
    pdf[(int) center_pt+i] = a*exp(-pow((b*delta*i),c)); 
    pdf[(int) center_pt-i] = a*exp(-pow((b*delta*i),c));
    }

/* Generate MATLAB data */  
for (i=0;i<NUM_SAMPLES;i++)
    fprintf(matlab_fp,"%1.6f %1.8f %1.8f\n",(-center_pt+i)*delta, cdf[i], pdf[i]);

fprintf(matlab_fp,"]; \nx = data(:,1); \ncdf = data(:,2); \npdf = data(:,3);");
fclose(matlab_fp);
} 
