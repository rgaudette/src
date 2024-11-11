#include <assert.h>
#include <cstdlib>
#include <cmath>
#include <direct.h>
#include <exception>
#include <fstream>
#include <istream>
#include <stdio.h>
#include <string>

#include "ipp.h"

#include "Exception.h"
#include "IPPImage.h"
#include "ImageUtil.h"
#include "IPPLibException.h"

#include "StationaryHaarTransformer1D.h"
#include "StationaryHaarTransformer1D.cpp"
#include "StationaryHaarTransformer2D.h"
#include "StationaryHaarTransformer2D.cpp"

using namespace std;


void print_vector(Ipp32f * vector, int length)
{
  for (int i = 0; i < length; ++i)
  {
    printf("%0.2f, ", vector[i]);
  }
  printf("\n");
}


bool all_equal(IPPImage<float> * img1, IPPImage<float> * img2, float precision = 1.0E-14)
{
  assert(img1->getWidthInPixels() == img2->getWidthInPixels());
  assert(img1->getLengthInPixels() == img2->getLengthInPixels());

  bool state = true;

  for (int row = 0; row < img1->getLengthInPixels(); ++row)
  {
    float * row1 = img1->getImageBufferAtLine(row);
    float * row2 = img2->getImageBufferAtLine(row);
    for (int column = 0; column < img1->getWidthInPixels(); ++column)
    {
      float abs_diff = fabs(row1[column] - row2[column]);
      state &= abs_diff < precision;
    }
  }
  return state;
}


bool driver()
{
  int n_rows = 32;
  // but if this is less than or equal to n_rows the test runs, if they are equal it passes
  int n_columns = 64;

  IPPImage<float> image(n_columns, n_rows);
  float * row;
  for (int i_row = 0; i_row < n_rows; ++i_row)
  {
    row = image.getImageBufferAtLine(i_row);
    for (int i_column = 0; i_column < n_columns; ++i_column)
    {
      row[i_column] = float(rand()) / (float(RAND_MAX) + 1.0F);
    }
  }
  
  IPPImage<float> recon(n_columns, n_rows);

  int n_levels = 1;
  StationaryHaarTransformer2D sht_2d_1l(n_levels, n_rows, n_columns);
  sht_2d_1l.analyze(& image, n_levels);
  sht_2d_1l.synthesize(& recon);
  bool all_are_equal = all_equal(& image, & recon);
  //cerr << "result: " << all_are_equal << endl;

  //n_levels = 2;
  //StationaryHaarTransformer2D sht_2d_2l(n_levels, n_rows, n_columns);
  //sht_2d_2l.analyze(& image, n_levels);
  //sht_2d_2l.synthesize(& recon);
  //ASSERT_TRUE(all_equal(& image, & recon));

  //n_levels = 3;
  //StationaryHaarTransformer2D sht_2d_3l(n_levels, n_rows, n_columns);
  //sht_2d_3l.analyze(& image, n_levels);
  //sht_2d_3l.synthesize(& recon);
  //ASSERT_TRUE(all_equal(& image, & recon));

  //n_levels = 4;
  //StationaryHaarTransformer2D sht_2d_4l(n_levels, n_rows, n_columns);
  //sht_2d_4l.analyze(& image, n_levels);
  //sht_2d_4l.synthesize(& recon);
  //ASSERT_TRUE(all_equal(& image, & recon));
  return all_are_equal;

}

int main(int argc, char * argv[])
{
  bool state = driver();
  cerr << "driver returned: " << state << endl;
	return 0;
}

