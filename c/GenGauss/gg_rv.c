/**************************************************************/
/*                                                            */
/* Program: gen_gauss_rv.c                                    */
/* Author: David Hoag                                         */
/* Date: 1/14/95                                              */
/*                                                            */
/* Purpose: Generates generalized Gaussian random numbers .   */
/*                                                            */
/**************************************************************/

#include <stdio.h>
#include <math.h>
#include <stdlib.h>

#define SIGMA 1
#define NUM_SAMPLES 20001  /* Used to set resolution of cdf HAS TO BE ODD*/
#define NUM_RV 400000        /* Number of r.v.'s to generate  */ 
#define UP_ENDPT 20

/* Declare return values of functions */
double gammp();
double gammln();
float randnum();

int main(int argc, char **argv) {
  char name[] = "data";
  double a,b,c;
  FILE *matlab_fp;
  int i,j,flag;
  int type, nrows, ncols, imag, len;
  double dtemp;
  double delta, center_pt, rand_number, gen_gauss_rv;
  double cdf[NUM_SAMPLES];
  long int seed;

  /* Read in exponent and normalizing values*/
  c = atof(argv[1]);
  b = 1/SIGMA*sqrt(exp(gammln(3/c)-gammln(1/c)));
  a = b*c/(2*exp(gammln(1/c)));

  printf("a=%f , b=%f\n\n",a ,b); 

  /* Open MATLAB file for the pdf and cdf data */
  matlab_fp = fopen("gauss_rv.mat","w");
  if(matlab_fp == NULL) {
    fprintf(stderr, "Unable to open data file\n");
    exit(-1);
  }

  /**
   **  Write out a big endian MATLAB header
   **/
#ifdef __i386__
  type = 0;
#else
  type = 1000;
#endif
  fwrite(&type, sizeof(int), 1, matlab_fp);
  nrows = 1;
  fwrite(&nrows, sizeof(int), 1, matlab_fp);
  ncols = NUM_RV;
  fwrite(&ncols, sizeof(int), 1, matlab_fp);
  imag = 0;
  fwrite(&imag, sizeof(int), 1, matlab_fp);
  len = 5;
  fwrite(&len, sizeof(int), 1, matlab_fp);
  fwrite(&name, sizeof(char), len, matlab_fp);

  /* Compute cdf for the random variable. First compute
     those for the point X=0, then compute the rest in a symmetric
     fashion about the zero point. */

  delta = (double) (2*UP_ENDPT)/(double) (NUM_SAMPLES-1);
  center_pt = (double) (NUM_SAMPLES-1)/2;

  cdf[(int) center_pt]=.5 + .5*gammp(1/c,pow(b,c)*pow(0.0,c));

  for (i=1;i<=center_pt;i++) {
    cdf[(int) center_pt+i] = .5 + .5*gammp(1/c,pow(b,c)*pow(delta*i,c)); 
    cdf[(int) center_pt-i] = .5 - .5*gammp(1/c,pow(b,c)*pow(delta*i,c));
  }

  printf("%f\n", cdf[NUM_SAMPLES-1]);

  /* Seed the uniform random number generator */
  seed = 1000;

  /* Generate the random numbers. Draw a random number from a uniform
     distribution and transform this into a generalized Gaussian number
     using the cdf lookup table. */
  for(j = 0; j < NUM_RV; j++) {
    rand_number = randnum(&seed);

    /* Initialize flag to 0. Flag=1 indicates that the generalized
       Gaussian random variable has been generated.  */
    flag = 0;

    if (rand_number < cdf[0]) {
      flag = 1;
      gen_gauss_rv = (double) (-UP_ENDPT);
    }
    
    if (rand_number > cdf[NUM_SAMPLES-1]) {
      flag = 1;
      gen_gauss_rv = (double) UP_ENDPT;
    }

    i=0;
    while ((flag != 1) || (i != NUM_SAMPLES)) {
      if ((rand_number >= cdf[i]) && (rand_number < cdf[i+1])) {
	flag = 1;
	/* Use linear interpolation to approximate the random number */
	gen_gauss_rv = (rand_number - cdf[i])/(cdf[i+1]-cdf[i])*delta +
	  (-center_pt+i)*delta;
      }
      i++;
    }

    /**
     **  Write out random number to matlab file
     **/
    dtemp = gen_gauss_rv;
    fwrite(&dtemp, sizeof(double), 1, matlab_fp);
  }

  fclose(matlab_fp);
  return(0);
} 


