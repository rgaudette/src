class StationaryHaarTransformer2D
{
public:
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

private:
  // Maximum values, used for allocating memory in the constructor
  int _max_levels;
  int _max_width;
  int _max_height;
  int _n_rows;
  int _n_cols;

  // This contains the Haar decomposition coefficients. It is accessed via the form coeffs[level][subband]
  IPPImage<float> * * * _coeffs;

}

// Construct the StationaryHaarTransformer2D object, using the largest dimensions used by this object
//
// @author Rick Gaudette
StationaryHaarTransformer2D::
StationaryHaarTransformer2D(int max_levels, int max_height, int max_width) :
_max_levels(max_levels), _max_height(max_height), _max_width(max_width)
{
  try
  {
    _coeffs = new IPPImage<float> ** [max_levels];
    for (int level = 0; level < max_levels; ++level)
    {
      _coeffs[level] = new IPPImage<float> * [4];

      _coeffs[level][LL] = new IPPImage<float>(max_width, max_height);
      _coeffs[level][LH] = new IPPImage<float>(max_width, max_height);
      _coeffs[level][HL] = new IPPImage<float>(max_width, max_height);
      _coeffs[level][HH] = new IPPImage<float>(max_width, max_height);
    }

    _column_approx = new IPPImage<float>(max_width, max_height);
    _column_detail = new IPPImage<float>(max_width, max_height);
    _row_temp_1 = new float[max_width];
    _row_temp_2 = new float[max_width];
    _column_buffer = new float[max_height];
    _approx_buffer = new float[max_height];
    _detail_buffer = new float[max_height];
  }
  catch (bad_alloc &)
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

int main(int argc, char * argv[])
{
	return 0;
}

