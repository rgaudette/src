/***********************************************************/
/*                                                         */
/* This file contains the following functions:             */
/*                                                         */
/*     gammp(): Incomplete Gamma Function                  */
/*     gammln(): Natural Log of the Gamma Function         */
/*                                                         */
/***********************************************************/

#include "gamma.h"
#include <math.h>

double gammp(double a, double x)

{
        double gamser,gammcf;

        if (x < (a+1.0)) {
                gser(&gamser,a,x);
                return gamser;
        } else {
                gcf(&gammcf,a,x);
                return 1.0-gammcf;
        }
}


void gser(double *gamser,double a,double x)
{
        int n;
        double sum,del,ap;
        double gammln();
        double gln;

        gln=gammln(a);

        ap=a;
        del=sum=1.0/a;
        for (n=1;n<=ITMAX;n++)
          {
           ap += 1.0;
           del *= x/ap;
           sum += del;
           if (fabs(del) < fabs(sum)*EPS)
             {
              *gamser=sum*pow(x,a)*exp(-x-gln);
               return;
             }
          }
}


void gcf(double *gammcf,double a,double x)
{
        int n;
        double gold=0.0,g,fac=1.0,b1=1.0;
        double b0=0.0,anf,ana,an,a1,a0=1.0;
        double gln;
        double gammln();

        gln=gammln(a);
        a1=x;
        for (n=1;n<=ITMAX;n++) {
                an=(double) n;
                ana=an-a;
                a0=(a1+a0*ana)*fac;
                b0=(b1+b0*ana)*fac;
                anf=an*fac;
                a1=x*a0+anf*a1;
                b1=x*b0+anf*b1;
                if (a1) {
                        fac=1.0/a1;
                        g=b1*fac;
                        if (fabs((g-gold)/g) < EPS) {
                                *gammcf=exp(-x+a*log(x)-gln)*g;
                                return;
                        }
                        gold=g;
                }
        }
}



double gammln(double xx)
{
        double x,y,tmp,ser;
        static double cof[6]={76.18009173,-86.50532033,24.01409824,
                -1.231739572,0.120865097e-2,-0.53952394e-5};
        int j;

        y=x=xx;
        tmp=x+5.5;
        tmp -= (x+0.5)*log(tmp);
        ser=1.0;
        for (j=0;j<=5;j++) {
                ser += cof[j]/++y;
        }
        return -tmp+log(2.50662827463*ser/x);
}
