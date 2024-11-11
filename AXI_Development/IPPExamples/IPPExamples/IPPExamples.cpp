#include <iostream>

#include "IPPImage.h"
#include "ImageCollection32f.h"

using namespace std;
void print_ipp(const IPPImage<float> & ippImage)
{
  int step = ippImage.getStepBytesParameter();
  cout  << "% Width: " << ippImage.getWidthInPixels() << endl;
  cout << "% Length: " << ippImage.getLengthInPixels() << endl;
  cout << "% Step bytes: " << step << endl;
  
  for (int i = 0; i < ippImage.getLengthInPixels(); i++)
  {
    for (int j = 0; j < ippImage.getWidthInPixels(); j++)
    {
        cout << setw(3) << *(ippImage.getPixelPtr(j, i)) << " ";
    }
    cout << endl;
  }
}

int main(int argc, char * argv[])
{
  int full_width = 10;
  int full_height = 5;
  ImageCollection32f * img_coll = new ImageCollection32f(full_width, full_height, 3);
  IPPImage<float> im1(img_coll->getWidth(), img_coll->getHeight(), img_coll->getImage(), img_coll->getStep());

  im1.reset(full_width, full_height, 0.0F);
  print_ipp(im1);

  // setImage can be used to assign an IPPImage to a portion of an existing image

  // Create an image object that represents the upper left corner of the image
  IPPImage<float> im1_ulc;
  im1_ulc.setImage(2, 2, im1.getPixelPtr(), im1.getStepBytesParameter());
  print_ipp(im1_ulc);

  // Create an image object that represents the lower right corner of the image
  IPPImage<float> im1_lrc;
  
  int x = full_width - 3;
  int y = full_height - 3;
  im1_lrc.setImage(3, 3, im1.getPixelPtr(x, y), im1.getStepBytesParameter());
  print_ipp(im1_lrc);

  float k = 0.0F;
  for (int i = 0; i < im1.getLengthInPixels(); i++)
  {
    float * row = im1.getImageBufferAtLine(i);
    for (int j = 0; j < im1.getWidthInPixels(); j++)
    {
      row[j] = k;
      k = k + 1.0F;
    }
    cout << endl;
  }
  
  print_ipp(im1);
  print_ipp(im1_ulc);
  print_ipp(im1_lrc);

  // Create a small image than is stored in the collection
  IPPImage<float> im2(img_coll->getWidth() - 5 , img_coll->getHeight() - 2, img_coll->getImage(), img_coll->getStep());
    print_ipp(im2);
  return 0;
}

