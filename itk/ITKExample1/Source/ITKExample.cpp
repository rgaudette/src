// ITKExample.cpp : A simple app to read in an image, apply a filter, and write out the result.
//

#include <iostream>
#include "boost/filesystem/operations.hpp"
#include "boost/filesystem/path.hpp"
#include <string>
#include <vector>

#include "itkImage.h"
#include "itkImageFileReader.h"
#include "itkImageFileWriter.h"
#include "itkGradientMagnitudeImageFilter.h"
#include "itkMedianImageFilter.h"

using namespace std;
using namespace boost::filesystem;
using namespace itk;

const int N_DIMS = 2;
typedef unsigned short USPixelType;
typedef float FLTPixelType;
typedef Image<USPixelType, N_DIMS> Image2D_US;
typedef Image<FLTPixelType, N_DIMS> Image2D_FLT;
typedef ImageFileReader< Image2D_US >  ImageReader;
typedef ImageFileWriter< Image2D_US >  ImageWriter;
typedef GradientMagnitudeImageFilter<Image2D_FLT, Image2D_FLT>  GradientMagFilter;

void usage(const char * command) {
	cerr << "Usage: " << command << " input_image output_image" << endl;
	exit(-1);
}

int main(int argc, char * argv[])
{
	cerr << argc << endl;

	if(argc < 3) {
		usage(argv[0]);
	}


	// Create a image file reader to start the pipeline
	ImageReader::Pointer reader = ImageReader::New();
	reader->SetFileName(argv[1]);

	cout << "reader class name: " << reader->GetNameOfClass() << endl;
	MetaDataDictionary mdd =  reader->GetMetaDataDictionary();
	std::vector<string> keys = mdd.GetKeys();
	cout << "MetaData dictionary length: " << keys.size() << endl;

	std::vector<string>::const_iterator iter_vs = keys.begin();
	for (std::vector<string>::const_iterator iter = iter_vs; iter_vs < keys.end(); ++iter_vs) {
		cout << * iter_vs << endl;
	}

	// Create a gradient magnitude image filter and add to the pipeline
	//GradientMagFilter::Pointer gradient_mag_filter = GradientMagFilter::New();
	//gradient_mag_filter->SetInput(reader->GetOutput());
	//gradient_mag_filter->
    

	// Create a image file writer
	ImageWriter::Pointer writer = ImageWriter::New();
	writer->SetFileName(argv[2]);
	writer->SetInput(reader->GetOutput());

	try {
		writer->Update();
	}
	catch(ExceptionObject & exception) {
		cerr << "Exception caught on pipeline update" << endl;
		exception.Print(cerr);
	}

	return 0;
}

