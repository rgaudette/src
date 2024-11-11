#include <cmath>
#include <iostream>
#include <sstream>

#include "mkl.h"

#include "StationaryHaarTransformer1D.h"
#include "Exception.h"
#include "MemoryAllocationException.h"

#include "StationaryHaarTransformer2D.h"

StationaryHaarTransformer2D::
StationaryHaarTransformer2D(int max_levels, int max_height, int max_width) :
  max_levels(max_levels), max_height(max_height), max_width(max_width)
{
  try
  {
    coeffs = new IPPImage<float> ** [max_levels];
    for (int level = 0; level < max_levels; ++level)
    {
      coeffs[level] = new IPPImage<float> * [4];

      coeffs[level][LL] = new IPPImage<float>(max_width, max_height);
      coeffs[level][LH] = new IPPImage<float>(max_width, max_height);
      coeffs[level][HL] = new IPPImage<float>(max_width, max_height);
      coeffs[level][HH] = new IPPImage<float>(max_width, max_height);
    }

    column_approx = new IPPImage<float>(max_width, max_height);
    column_detail = new IPPImage<float>(max_width, max_height);
    // RJG cache line experiment
    //column_buffer = new float[16 * max_height];
    row_temp_1 = new float[max_width];
    row_temp_2 = new float[max_width];
    column_buffer = new float[max_height];
    approx_buffer = new float[max_height];
    detail_buffer = new float[max_height];
  }
  catch (std::bad_alloc &)
  {
    stringstream msg;
    msg << "Unable to allocate required memory in constructor: max levels: " << max_levels
        << " max height: " << max_height
        << " max width: " << max_width << endl
        << "File: " << __FILE__ << endl
        << "Line: " << __LINE__;
    cerr << msg.str() << endl;
    throw MemoryAllocationException(__FILE__, __LINE__);
  }
}


StationaryHaarTransformer2D::
~StationaryHaarTransformer2D(void)
{
  delete column_approx;
  delete column_detail;
  delete[] column_buffer;
  delete[] approx_buffer;
  delete[] detail_buffer;

  for (int level = 0; level < max_levels; ++level)
  {
    delete coeffs[level][LL];
    delete coeffs[level][LH];
    delete coeffs[level][HL];
    delete coeffs[level][HH];
    delete coeffs[level];
  }
  delete[] coeffs;
}


void StationaryHaarTransformer2D::
analyze(IPPImage<float> * image, int n_levels)
{
  validate_analyze_args(n_levels, image);
  //print_coefficient_memory_locations();

  analysis_levels = n_levels;
  IPPImage<float> * approx = image;
  for (int level = 0; level < n_levels; ++level)
  {
    analyze_columns(approx, column_approx, column_detail, level);
    analyze_rows(column_approx, coeffs[level][LL], coeffs[level][HL], level);
    analyze_rows(column_detail, coeffs[level][LH], coeffs[level][HH], level);
    approx = coeffs[level][LL];
  }
}

// Compute a single level stationary Haar wavelet transform analysis of the columns, given an IPP image.
// In order to speed up the processing, the processing is actually done across each row, instead of down each column.
// This provides a moderate improvement in speed in the single threaded case but a large improvement when multiple
// threads/processes are competing for cache resources.
void StationaryHaarTransformer2D::
analyze_columns(IPPImage<float> * approx,
                IPPImage<float> * column_approx,
                IPPImage<float> * column_detail,
                int level)
{
  int n_columns = approx->getWidthInPixels();
  int n_rows = approx->getLengthInPixels();

  const int shift = 1 << level;
  const int overlapped = n_rows - shift;
  for (int i_row = 0; i_row < overlapped; ++i_row)
  {
    float * approx_1 = approx->getImageBufferAtLine(i_row);
    float * approx_2 = approx->getImageBufferAtLine(i_row + shift);
    float * approx_out = column_approx->getImageBufferAtLine(i_row);
    float * detail_out = column_detail->getImageBufferAtLine(i_row);

    vsAdd(n_columns, approx_1, approx_2, approx_out);
    vsSub(n_columns, approx_1, approx_2, detail_out);

    //for (int i_column = 0; i_column < n_columns; ++i_column)
    //{
    //  detail_out[i_column] = approx_1[i_column] - approx_2[i_column];
    //  approx_out[i_column] = approx_1[i_column] + approx_2[i_column];
    //}
  }

  for (int i_row = overlapped, j = 0; i_row < n_rows; ++i_row, ++j)
  {
    float * approx_1 = approx->getImageBufferAtLine(i_row);
    float * approx_2 = approx->getImageBufferAtLine(j);
    float * approx_out = column_approx->getImageBufferAtLine(i_row);
    float * detail_out = column_detail->getImageBufferAtLine(i_row);

    vsAdd(n_columns, approx_1, approx_2, approx_out);
    vsSub(n_columns, approx_1, approx_2, detail_out);
    //for (int i_column = 0; i_column < n_columns; ++i_column)
    //{
    //  detail_out[i_column] = approx_1[i_column] - approx_2[i_column];
    //  approx_out[i_column] = approx_1[i_column] + approx_2[i_column];
    //}
  }
}
void StationaryHaarTransformer2D::
analyze_columns_unoptimized0(IPPImage<float> * approx,
                             IPPImage<float> * column_approx,
                             IPPImage<float> * column_detail,
                             int level)
{
  int n_columns = approx->getWidthInPixels();
  int n_rows = approx->getLengthInPixels();
  int row_step = approx->getStepBytesParameter() / sizeof(float);

  for (int i_column = 0; i_column < n_columns; ++i_column)
  {
    // Copy out the approx column into the column buffer
    float * ptr_approx = approx->getPixelPtr(i_column, 0);
    for (int i_row = 0; i_row < n_rows; ++i_row)
    {
      column_buffer[i_row] = * ptr_approx;
      ptr_approx += row_step;
    }

    StationaryHaarTransformer1D::unit_haar_one_level_analysis(column_buffer,
                                                              approx_buffer,
                                                              detail_buffer,
                                                              n_rows,
                                                              level);

    // Copy out the approximation and detail buffers into the resultant approximation and detail columns
    float * ptr_column_approx = column_approx->getPixelPtr(i_column, 0);
    float * ptr_column_detail = column_detail->getPixelPtr(i_column, 0);
    for (int i_row = 0; i_row < n_rows; ++i_row)
    {
      * ptr_column_approx = approx_buffer[i_row];
      ptr_column_approx += row_step;
      * ptr_column_detail = detail_buffer[i_row];
      ptr_column_detail += row_step;
    }
  }
}

void StationaryHaarTransformer2D::
analyze_columns_unoptimized1(IPPImage<float> * approx,
                             IPPImage<float> * column_approx,
                             IPPImage<float> * column_detail,
                             int level)
{
  int n_columns = approx->getWidthInPixels();
  int n_rows = approx->getLengthInPixels();
  int row_step = approx->getStepBytesParameter() / sizeof(float);

  for (int i_column = 0; i_column < n_columns; ++i_column)
  {
    // Copy out the approx column into the column buffer
    int blk_rem = i_column % 16;
    if (blk_rem == 0)
    {
      int blk_cols = std::min(n_columns - i_column, 16);

      for (int i_row = 0; i_row < n_rows; ++i_row)
      {
        float * ptr_approx = approx->getPixelPtr(i_column, i_row);
        for (int ic_offset = 0; ic_offset < blk_cols; ++ic_offset)
        {
          column_buffer[ic_offset * 16 + i_row] = * ptr_approx;
          ++ ptr_approx;
        }
      }
    }

    StationaryHaarTransformer1D::unit_haar_one_level_analysis(&column_buffer[blk_rem * 16],
                                                              approx_buffer,
                                                              detail_buffer,
                                                              n_rows,
                                                              level);

    // Copy out the approximation and detail buffers into the resultant approximation and detail columns
    float * ptr_column_approx = column_approx->getPixelPtr(i_column, 0);
    float * ptr_column_detail = column_detail->getPixelPtr(i_column, 0);
    for (int i_row = 0; i_row < n_rows; ++i_row)
    {
      * ptr_column_approx = approx_buffer[i_row];
      ptr_column_approx += row_step;
      * ptr_column_detail = detail_buffer[i_row];
      ptr_column_detail += row_step;
    }
  }
}


void StationaryHaarTransformer2D::
analyze_rows(IPPImage<float> * column_subband,
             IPPImage<float> * row_approx,
             IPPImage<float> * row_detail,
             int level)
{
  int n_columns = column_subband->getWidthInPixels();
  int n_rows = column_subband->getLengthInPixels();
  for (int i_row = 0; i_row < n_rows; ++i_row)
  {
    float * row_in = column_subband->getImageBufferAtLine(i_row);
    float * approx_out = row_approx->getImageBufferAtLine(i_row);
    float * detail_out = row_detail->getImageBufferAtLine(i_row);
    StationaryHaarTransformer1D::unit_haar_one_level_analysis(row_in, approx_out, detail_out, n_columns, level);
  }
}


void StationaryHaarTransformer2D::
synthesize(IPPImage<float> * recon)
{
  for (int level = analysis_levels - 1; level > 0; --level)
  {
    synthesize_rows(coeffs[level][LH], coeffs[level][HH], column_detail, level);
    synthesize_rows(coeffs[level][LL], coeffs[level][HL], column_approx, level);
    synthesize_columns(column_approx, column_detail, coeffs[level - 1][LL], level);
  }
  // This final synthesis step places the result into the output array
  synthesize_rows(coeffs[0][LH], coeffs[0][HH], column_detail, 0);
  synthesize_rows(coeffs[0][LL], coeffs[0][HL], column_approx, 0);
  synthesize_columns(column_approx, column_detail, recon, 0);
}


void StationaryHaarTransformer2D::
synthesize_rows(IPPImage<float> * row_approx,
                IPPImage<float> * row_detail,
                IPPImage<float> * column_subband,
                int level)
{
  int n_columns = column_subband->getWidthInPixels();
  int n_rows = column_subband->getLengthInPixels();
  for (int i_row = 0; i_row < n_rows; ++i_row)
  {
    float * approx_in = row_approx->getImageBufferAtLine(i_row);
    float * detail_in = row_detail->getImageBufferAtLine(i_row);
    float * row_out = column_subband->getImageBufferAtLine(i_row);
    StationaryHaarTransformer1D::unit_haar_one_level_synthesis(approx_in, detail_in, row_out, n_columns, level);
  }
}


void StationaryHaarTransformer2D::
synthesize_columns(IPPImage<float> * column_approx,
                   IPPImage<float> * column_detail,
                   IPPImage<float> * recon,
                   int level)
{
  const float scale = 0.25;
  int n_columns = recon->getWidthInPixels();
  int n_rows = recon->getLengthInPixels();

  const int shift = 1 << level;
  const int overlapped = n_rows - shift;
  for (int i_row = 0, j_row = n_rows - shift; i_row < shift; ++i_row, ++j_row)
  {
    float * approx_1 = column_approx->getImageBufferAtLine(i_row);
    float * approx_2 = column_approx->getImageBufferAtLine(j_row);
    float * detail_1 = column_detail->getImageBufferAtLine(i_row);
    float * detail_2 = column_detail->getImageBufferAtLine(j_row);
    float * recon_out = recon->getImageBufferAtLine(i_row);
    for (int i_column = 0; i_column < n_columns; ++i_column)
    {
      recon_out[i_column] = scale * (approx_1[i_column] + detail_1[i_column] + approx_2[i_column] - detail_2[i_column]);
    }
  }
  for (int i_row = shift, j_row = 0; i_row < n_rows; ++i_row, ++j_row)
  {

    float * approx_1 = column_approx->getImageBufferAtLine(i_row);
    float * approx_2 = column_approx->getImageBufferAtLine(j_row);
    float * detail_1 = column_detail->getImageBufferAtLine(i_row);
    float * detail_2 = column_detail->getImageBufferAtLine(j_row);
    float * recon_out = recon->getImageBufferAtLine(i_row);
    for (int i_column = 0; i_column < n_columns; ++i_column)
    {
      recon_out[i_column] = scale * (approx_1[i_column] + detail_1[i_column] + approx_2[i_column] - detail_2[i_column]);
    }
  }
}

void StationaryHaarTransformer2D::
synthesize_columns_unoptimized0(IPPImage<float> * column_approx,
                                IPPImage<float> * column_detail,
                                IPPImage<float> * recon,
                                int level)
{
  int n_columns = recon->getWidthInPixels();
  int n_rows = recon->getLengthInPixels();
  int row_step = recon->getStepBytesParameter() / sizeof(float);

  for (int i_column = 0; i_column < n_columns; ++i_column)
  {

    // Copy the approximation and detail buffers into the approximation and detail column buffers
    float * ptr_column_approx = column_approx->getPixelPtr(i_column, 0);
    float * ptr_column_detail = column_detail->getPixelPtr(i_column, 0);
    for (int i_row = 0; i_row < n_rows; ++i_row)
    {
      approx_buffer[i_row] = * ptr_column_approx;
      ptr_column_approx += row_step;
      detail_buffer[i_row] = * ptr_column_detail;
      ptr_column_detail += row_step;
    }

    StationaryHaarTransformer1D::unit_haar_one_level_synthesis(approx_buffer,
                                                               detail_buffer,
                                                               column_buffer,
                                                               n_rows,
                                                               level);

    // Copy the resulting to the recon column
    // Copy out the approx column into the column buffer
    float * ptr_recon = recon->getPixelPtr(i_column, 0);
    for (int i_row = 0; i_row < n_rows; ++i_row)
    {
      * ptr_recon = column_buffer[i_row];
      ptr_recon += row_step;
    }
  }
}


//  Set the wavelet shrinkage thresholds by providing function weights to several aspects of the wavelet transform.
//
void StationaryHaarTransformer2D::
set_shrinkage_weights(float global_weight,
                      vector<float> subband_weight,
                      vector<float> diagonal_weight,
                      float pixel_gain)
{
  validate_set_shrinkage_weights_args(global_weight, pixel_gain, subband_weight, diagonal_weight);

  size_t n_levels = subband_weight.size();

  float level_invariant_weight = pow(global_weight, 2.0F) * pixel_gain;
  thresholds.resize(n_levels);
  for (int level = 0; level < n_levels; ++level)
  {
    float cardinal_axis_weight = level_invariant_weight * pow(0.5F, level + 1) * pow(subband_weight[level], 2.0F);
    thresholds[level][HL] = cardinal_axis_weight;
    thresholds[level][LH] = cardinal_axis_weight;
    thresholds[level][HH] = diagonal_weight[level] * cardinal_axis_weight;
    cout << "level:  " << level 
      << " HL: " << thresholds[level][HL] 
      << " LH: " << thresholds[level][LH] 
      << " HH: " << thresholds[level][HH] << endl;
  }
}


// Set the wavelet shrinkage thresholds directly
void StationaryHaarTransformer2D::
set_shrinkage_thresholds(vector<array<float, 4> > thresholds_in)
{
  thresholds.resize(thresholds_in.size());
  thresholds = thresholds_in;
}


void StationaryHaarTransformer2D::
hard_shrink()
{
  validate_set_shrinkage_thresholds_args(thresholds);

  for (int level = 0; level < analysis_levels; ++level)
  {
    hard_shrink_array(thresholds[level][LH], coeffs[level][LH]);
    hard_shrink_array(thresholds[level][HL], coeffs[level][HL]);
    hard_shrink_array(thresholds[level][HH], coeffs[level][HH]);
  }
}


void StationaryHaarTransformer2D::
hard_shrink_array(float threshold, IPPImage<float> * subband)
{
  int n_cols = subband->getWidthInPixels();
  int n_rows = subband->getLengthInPixels();
  for (int i_row = 0; i_row < n_rows; ++i_row)
  {
    float * row = subband->getImageBufferAtLine(i_row);
    for (int i_column = 0; i_column < n_cols; ++i_column)
    {
      if (fabs(row[i_column]) < threshold)
      {
        row[i_column] = 0.0F;
      }
    }
  }
}


void StationaryHaarTransformer2D::
soft_shrink()
{
  for (int level = 0; level < analysis_levels; ++level)
  {
    soft_shrink_array(thresholds[level][LH], coeffs[level][LH]);
    soft_shrink_array(thresholds[level][HL], coeffs[level][HL]);
    soft_shrink_array(thresholds[level][HH], coeffs[level][HH]);
  }
}


void StationaryHaarTransformer2D::
soft_shrink_array(float threshold, IPPImage<float> * subband)
{
  validate_set_shrinkage_thresholds_args(thresholds);

  int n_cols = subband->getWidthInPixels();
  int n_rows = subband->getLengthInPixels();
  for (int i_row = 0; i_row < n_rows; ++i_row)
  {
    float * row = subband->getImageBufferAtLine(i_row);
    for (int i_column = 0; i_column < n_cols; ++i_column)
    {
      if (fabs(row[i_column]) < threshold)
      {
        row[i_column] = 0.0F;
      }
      else
      {
        if (row[i_column] > 0.0F)
        {
          row[i_column] -= threshold;
        }
        else
        {
          row[i_column] += threshold;
        }
      }
    }
  }
}


void StationaryHaarTransformer2D::
soft_shrink_approximation_weighted()
{
  for (int level = 0; level < analysis_levels; ++level)
  {
    soft_shrink_approximation_weighted_array(thresholds[level][LH], coeffs[level][LH], coeffs[level][LL]);
    soft_shrink_approximation_weighted_array(thresholds[level][HL], coeffs[level][HL], coeffs[level][LL]);
    soft_shrink_approximation_weighted_array(thresholds[level][HH], coeffs[level][HH], coeffs[level][LL]);
  }
}
// Note: the function does not ensure that the approximation coefficients or weight is positive for efficiency reasons.
// Ensure that both of these values are >= 0.
void StationaryHaarTransformer2D::
soft_shrink_approximation_weighted_array(float weight, IPPImage<float> * subband, IPPImage<float> * approx)
{
  validate_set_shrinkage_thresholds_args(thresholds);

  // RJG: TODO vectorize this code
  int n_cols = subband->getWidthInPixels();
  int n_rows = subband->getLengthInPixels();
  for (int i_row = 0; i_row < n_rows; ++i_row)
  {
    float * detail_row = subband->getImageBufferAtLine(i_row);
    float * approx_row = approx->getImageBufferAtLine(i_row);
    cblas_scopy(n_cols, approx_row, 1, row_temp_1, 1);
    cblas_sscal(n_cols, weight, row_temp_1, 1);
    //for (int i_column = 0; i_column < n_cols; ++i_column)
    //{
    //  row_temp_1[i_column] = approx_row[i_column] * weight;
    //}
    // RJG consider using the low accuracy version here as it is 1/2 the number of clocks
    vsSqrt(n_cols, row_temp_1, row_temp_2);
    //vmsSqrt(n_cols, row_temp_1, row_temp_2, VML_LA);
    //vsAbs(n_cols, detail_row, row_temp_1);
    //for (int i_column = 0; i_column < n_cols; ++i_column)
    //{
    //  if (row_temp_1[i_column] < row_temp_2[i_column])
    //  {
    //    detail_row[i_column] = 0.0F;
    //  }
    //  else
    //  {
    //    if (detail_row[i_column] > 0.0F)
    //    {
    //      detail_row[i_column] -= row_temp_2[i_column];
    //    }
    //    else
    //    {
    //      detail_row[i_column] += row_temp_2[i_column];
    //    }
    //  }
    //}

    for (int i_column = 0; i_column < n_cols; ++i_column)
    {
      if (fabs(detail_row[i_column]) < row_temp_2[i_column])
      {
        detail_row[i_column] = 0.0F;
      }
      else
      {
        if (detail_row[i_column] > 0.0F)
        {
          detail_row[i_column] -= row_temp_2[i_column];
        }
        else
        {
          detail_row[i_column] += row_temp_2[i_column];
        }
      }
    }
    
    //for (int i_column = 0; i_column < n_cols; ++i_column)
    //{
    //  float shrink = sqrt(approx_row[i_column] * weight);
    //  
    //  if (fabs(detail_row[i_column]) < shrink)
    //  {
    //    detail_row[i_column] = 0.0F;
    //  }
    //  else
    //  {
    //    if (detail_row[i_column] > 0.0F)
    //    {
    //      detail_row[i_column] -= shrink;
    //    }
    //    else
    //    {
    //      detail_row[i_column] += shrink;
    //    }
    //  }
    //}

  }
}

void StationaryHaarTransformer2D::
print_coefficient_memory_locations()
{
  cerr << "-------------------------------" << endl;
  cerr << "coeffs: " << coeffs << endl;
  for (int level = 0; level < max_levels; ++level)
  {
    cerr << "coeffs[" << level << " ]: " << coeffs[level] << endl;
    cerr << "coeffs[" << level << " ][" << LL << "]: " << coeffs[level][LL] << endl;
    cerr << "image buffer: " << coeffs[level][LL]->getImageBuffer() << endl;
    cerr << "coeffs[" << level << " ][" << LH << "]: " << coeffs[level][LH] << endl;
    cerr << "image buffer: " << coeffs[level][LL]->getImageBuffer() << endl;
    cerr << "coeffs[" << level << " ][" << HL << "]: " << coeffs[level][HL] << endl;
    cerr << "image buffer: " << coeffs[level][HL]->getImageBuffer() << endl;
    cerr << "coeffs[" << level << " ][" << HH << "]: " << coeffs[level][HH] << endl;
    cerr << "image buffer: " << coeffs[level][HH]->getImageBuffer() << endl;
  }
}


void StationaryHaarTransformer2D::
validate_analyze_args(int n_levels, IPPImage<float> * image)
{
  // Verify that the number of levels and size of the image does not exceed the amount allocated memory
  if (n_levels > max_levels)
  {
    stringstream msg;
    msg << "Number of levels requested: " << n_levels << " exceeds max allocated: " <<  max_levels << endl
        << "File: " << __FILE__ << endl
        << "Line: " << __LINE__;
    cerr << msg.str() << endl;
    throw Exception(msg.str());
  }
  if (image->getWidthInPixels() > max_width)
  {
    stringstream msg;
    msg << "Image width: " << image->getWidthInPixels() << " exceeds max allocated: " <<  max_width << endl
        << "File: " << __FILE__ << endl
        << "Line: " << __LINE__;
    cerr << msg.str() << endl;
    throw Exception(msg.str());
  }
  if (image->getLengthInPixels() > max_height)
  {
    stringstream msg;
    msg << "Image height: " << image->getLengthInPixels() << " exceeds max allocated: " <<  max_height << endl
        << "File: " << __FILE__ << endl
        << "Line: " << __LINE__;
    cerr << msg.str() << endl;
    throw Exception(msg.str());
  }

  // Make sure the size of the image is compatible with the number of levels requested
  if (image->getWidthInPixels() != image->getWidthInPixels() >> n_levels << n_levels)
  {
    stringstream msg;
    msg << "The image width is not an integer multiple of 2^n_levels. Levels requested: " << n_levels
        << " width : " <<  image->getWidthInPixels() << endl
        << "File: " << __FILE__ << endl
        << "Line: " << __LINE__;
    cerr << msg.str() << endl;
    throw Exception(msg.str());
  }
  if (image->getLengthInPixels() != image->getLengthInPixels() >> n_levels << n_levels)
  {
    stringstream msg;
    msg << "The image length is not an integer multiple of 2^n_levels. Levels requested: " << n_levels
        << " width : " <<  image->getLengthInPixels() << endl
        << "File: " << __FILE__ << endl
        << "Line: " << __LINE__;
    cerr << msg.str() << endl;
    throw Exception(msg.str());
  }
}


void StationaryHaarTransformer2D::
validate_set_shrinkage_weights_args(float global_weight,
                                    float pixel_gain,
                                    vector<float> & subband_weight,
                                    vector<float> & diagonal_weight)
{
  if (global_weight < 0.0F)
  {
    stringstream msg;
    msg << "The global weight is less than zero: " << global_weight << endl
        << "File: " << __FILE__ << endl
        << "Line: " << __LINE__;
    cerr << msg.str() << endl;
    throw Exception(msg.str());
  }

  if (pixel_gain < 0.0F)
  {
    stringstream msg;
    msg << "The pixel gain is less than zero: " << pixel_gain << endl
        << "File: " << __FILE__ << endl
        << "Line: " << __LINE__;
    cerr << msg.str() << endl;
    throw Exception(msg.str());
  }
}

void StationaryHaarTransformer2D::
validate_set_shrinkage_thresholds_args(vector<array<float, 4> > & thresholds_in)
{
  // Verify that number of threshold arrays matches the number of levels
  if (thresholds_in.size() != analysis_levels)
  {
    stringstream msg;
    msg << "The threshold array structure does not have the correct number of levels. Expected: " << analysis_levels
        << " received : " << (int) thresholds_in.size() << endl
        << "File: " << __FILE__ << endl
        << "Line: " << __LINE__;
    cerr << msg.str() << endl;
    throw Exception(msg.str());
  }
}
