#include <iostream>
#include "mkl.h"

#include "IPPImage.h"

using namespace std;
template <class U> 
void print_image(const IPPImage<U> & ippImage)
{
  int step = ippImage.getStepBytesParameter();
  cout << "% Width: " << ippImage.getWidthInPixels() << std::endl;
  cout << "% Length: " << ippImage.getLengthInPixels() << std::endl;
  cout << "% Step bytes: " << step << std::endl;

  for (int i = 0; i < ippImage.getLengthInPixels(); i++)
  {
    for (int j = 0; j < ippImage.getWidthInPixels(); j++)
    {
      // if U is char type then cast to int to stop ascii characters from being printed
      if(sizeof(U) == sizeof(unsigned char))
        cout << std::setw(3) << static_cast<int>(*(ippImage.getPixelPtr(j, i))) << " ";
      else
        cout << std::setw(3) << *(ippImage.getPixelPtr(j, i)) << " ";
    }
    cout << std::endl;
  }
}

int main(int argc, char * argv[])
{
  int n_rows = 4;
  int n_cols = 3;

  IPPImage<float> img(n_cols, n_rows);
  int i = 0;
  for (int ir = 0; ir < n_rows; ++ir)
  {
    float * row = img.getImageBufferAtLine(ir);
    cout << "row pointer: " << row << endl;
    for (int ic = 0; ic < n_cols; ++ic)
    {
      row[ic] = i;
      i++;
    }
  }
  print_image(img); 
  
  float * x = (float *) MKL_malloc(n_cols, 64);
  for (int ic = 0; ic < n_cols; ++ic)
  {
    x[ic] = 1.0F;
  }

  float * b = (float *) MKL_malloc(n_rows, 64);

  float * img_buf = img.getImageBuffer();
  int lda = (img.getImageBufferAtLine(1) - img.getImageBufferAtLine(0));
  cout << "lda: " << lda << endl;
  cblas_sgemv(CblasRowMajor, CblasNoTrans, n_rows, n_cols, 1.0F, img.getImageBuffer(), lda, x, 1, 0.0F, b, 1);

  for (int ir = 0; ir < n_rows; ++ir)
  {
    cout << b[ir] << endl;
  }  

  return 0;
}

