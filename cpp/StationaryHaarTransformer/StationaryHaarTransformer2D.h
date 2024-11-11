#pragma once

#include <boost/array.hpp>
#include <vector>

#include "IPPImage.h"

// TODO move these into the class
using namespace std;
// Swtich to std array once we are totally off of VS2003
//using namespace std::tr1;
using namespace boost;

class StationaryHaarTransformer2D
{
  public:

    // This enumeration specified the subband indices in the decomposition structure. The first character specifies the
    // filter along the rows, and the second specifies filter along the columns.  This is the typical convention to
    // describe the subbands.  Note that some authors will use an alternate convention i.e. the meaning of HL and LH
    // are swapped.
    enum Subband
    {
      LL = 0,
      LH = 1,
      HL = 2,
      HH = 3,
      end_of_subbands
    };

    StationaryHaarTransformer2D(int max_levels, int max_height, int max_width);
    ~StationaryHaarTransformer2D(void);

    void analyze(IPPImage<float> * image, int n_levels);
    void synthesize(IPPImage<float> * image);
    void set_shrinkage_weights(float global_weight,
                               vector<float> subband_weight,
                               vector<float> diagonal_weight,
                               float pixel_gain);

    void set_shrinkage_thresholds(vector<array<float, 4> > thresholds);

    void hard_shrink(void);
    void soft_shrink(void);
    void soft_shrink_approximation_weighted(void);
    IPPImage<float> * get_subband(int level, Subband subband)
    {
      return coeffs[level][subband];
    }

  // RJG switch back to private when done debugging  
  public:
    // Maximum values, used for allocating memory in the constructor
    int max_levels;
    int max_width;
    int max_height;

    // The number of analysis levels
    int analysis_levels;

    // This contains the Haar decomposition coefficients. It is accessed via the form coeffs[level][subband]
    IPPImage<float> * * * coeffs;

    vector<array<float, 4> > thresholds;

    // These two images are used as temporary buffers when decomposing or reconstructing an image.
    IPPImage<float> * column_approx;
    IPPImage<float> * column_detail;

    // These three buffers are used for temporarily converting between a column of image data and a contiguous array
    float * row_temp_1;
    float * row_temp_2;
    float * column_buffer;
    float * approx_buffer;
    float * detail_buffer;

    void analyze_columns(IPPImage<float> * approx,
                         IPPImage<float> * column_approx,
                         IPPImage<float> * column_detail,
                         int level);
    
    void analyze_columns_unoptimized0(IPPImage<float> * approx,
                                      IPPImage<float> * column_approx,
                                      IPPImage<float> * column_detail,
                                      int level);

    void analyze_columns_unoptimized1(IPPImage<float> * approx,
                                      IPPImage<float> * column_approx,
                                      IPPImage<float> * column_detail,
                                      int level);

    void analyze_rows(IPPImage<float> * column_subband,
                      IPPImage<float> * row_approx,
                      IPPImage<float> * row_detail,
                      int level);

    void synthesize_rows(IPPImage<float> * row_approx,
                         IPPImage<float> * row_detail,
                         IPPImage<float> * column_subband,
                         int level);
    void synthesize_columns(IPPImage<float> * column_approx,
                            IPPImage<float> * column_detail,
                            IPPImage<float> * recon,
                            int level);
    void synthesize_columns_unoptimized0(IPPImage<float> * column_approx,
                                         IPPImage<float> * column_detail,
                                         IPPImage<float> * recon,
                                         int level);
    void hard_shrink_array(float threshold, IPPImage<float> * subband);
    void soft_shrink_array(float threshold, IPPImage<float> * subband);
    void soft_shrink_approximation_weighted_array(float threshold, 
      IPPImage<float> * subband, 
      IPPImage<float> * approx);

    void validate_analyze_args(int n_levels, IPPImage<float> * image);
    void validate_set_shrinkage_weights_args(float global_weight,
                                             float pixel_gain,
                                             vector<float> & subband_weight,
                                             vector<float> & diagonal_weight);
    void validate_set_shrinkage_thresholds_args(vector<array<float, 4> > & thresholds_in);


    // Debugging functions
    void print_coefficient_memory_locations();

    // Prevent access to the default constructor, copy constructors and assignment operator
    StationaryHaarTransformer2D(void);
    StationaryHaarTransformer2D(const StationaryHaarTransformer2D & arg);
    StationaryHaarTransformer2D & operator=(const StationaryHaarTransformer2D & arg);

};
