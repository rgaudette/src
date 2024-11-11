#include <iostream.h>
#include "..\CMat.h"

void main(int argc, char * arg[]){

    CMat m1(3,3), m3(3,3);
    m1.RandUniform();
    m1.Show();

    int nc = 3;
    int nr = 3;
    CMat m2(nc, nr);
    m2.RandUniform();
    m2.Show();

    m2.Add(m1);
    m2.Show();

    m3 = m2;
    m3.Show();
}
