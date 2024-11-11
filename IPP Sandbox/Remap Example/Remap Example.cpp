#include <stdio.h>
#include "ipp.h"
#include "utilities.hpp"


// TODO this should really fill in a struct
Ipp32f  * allocate_ipp_image(int n_columns, int n_rows, IppiSize & size, IppiRect & rect, int & n_elements, int & step_bytes)
{
  size.width = n_columns;
  size.height = n_rows;

  rect.x = 0;
  rect.y = 0;
  rect.width = n_columns;
  rect.height = n_rows;

  n_elements = n_rows * n_columns;

  step_bytes =  n_columns * sizeof(Ipp32f);

  return new Ipp32f[n_elements];
}


void ramp_image(int n_elements, Ipp32f *& src )
{
  for (int i = 0; i < n_elements; i++)
  {
    src[i] = (Ipp32f) i;
  }
}

// Create ramp in Y, constant in X image
void ramp_y(int n_columns, int n_rows, Ipp32f *& src )
{
  int index = 0;
  for (int i = 0; i < n_rows; i++)
  {
    for (int j = 0; j < n_columns; j++)
    {
      src[index] = (Ipp32f) i;
      index ++;
    }
  }
}

// Create ramp in X, constant in Y image
void ramp_x(int n_columns, int n_rows, Ipp32f *& src )
{
  int index = 0;
  for (int i = 0; i < n_rows; i++)
  {
    for (int j = 0; j < n_columns; j++)
    {
      src[index] = (Ipp32f) j;
      index ++;
    }
  }
}

void bad_example()
{
  IppStatus status;

  int n_rows = 4;
  int n_columns = 4;
  IppiSize src_size = {n_columns, n_rows};
  IppiRect src_rect = {0, 0, n_columns, n_rows};
  // This image produces NaN (-1.#R printed) results when remapped at x = 3.5, y = -0.5
  // this is true with IPPI_INTER_NN or IPPI_INTER_CUBIC under release x64, other configurations produce different
  // results
  Ipp32f src[4 * 4] = {0, 1, 2, 3,
                       4, 5, 6, 7,
                       8, 9, 0, 1,
                       2, 3, 4, 5
                      };
  int src_step_bytes = n_columns * sizeof(Ipp32f);
  printf("Source image:\n");
  print_matrix(src, src_size.height, src_size.width);

  int map_rows = 5;
  int map_columns = 5;
  Ipp32f px_map[5 * 5] = { -0.5F, 0.5F, 1.5F, 2.5F, 3.5F,
                           -0.5F, 0.5F, 1.5F, 2.5F, 3.5F,
                           -0.5F, 0.5F, 1.5F, 2.5F, 3.5F,
                           -0.5F, 0.5F, 1.5F, 2.5F, 3.5F
                         };
  Ipp32f py_map[5 * 5] = { -0.5F, -0.5F, -0.5F, -0.5F, -0.5F,
                           0.5F, 0.5F, 0.5F, 0.5F, 0.5F,
                           1.5F, 1.5F, 1.5F, 1.5F, 1.5F,
                           2.5F, 2.5F, 2.5F, 2.5F, 2.5F,
                           3.5F, 3.5F, 3.5F, 3.5F, 3.5F
                         };
  int map_step_bytes = map_columns * sizeof(Ipp32f);

  Ipp32f dst[5 * 5] = { -2.0F, -2.0F, -2.0F, -2.0F, -2.0F,
                        -2.0F, -2.0F, -2.0F, -2.0F, -2.0F,
                        -2.0F, -2.0F, -2.0F, -2.0F, -2.0F,
                        -2.0F, -2.0F, -2.0F, -2.0F, -2.0F,
                        -2.0F, -2.0F, -2.0F, -2.0F, -2.0F
                      };
  IppiSize dst_size = {map_columns, map_rows};

  status = ippiRemap_32f_C1R(src, src_size, src_step_bytes, src_rect,
                             px_map, map_step_bytes,
                             py_map, map_step_bytes,
                             dst, map_step_bytes, dst_size, IPPI_INTER_CUBIC);

  printf("\nippiRemap status: %d\n", status);
  printf("Destination image:\n");
  print_matrix(dst, dst_size.height, dst_size.width);
}


void interpolate_past_boundary()
{

  IppStatus status;

  int n_rows = 6;
  int n_columns = 6;

  IppiSize src_size;
  IppiRect src_rect;
  int n_elements;
  int src_step_bytes;
  Ipp32f * src = allocate_ipp_image(n_columns, n_rows, src_size, src_rect, n_elements, src_step_bytes);

  //ramp_image(n_elements, src);
  ramp_y(n_columns, n_rows, src);


  printf("Source image:\n");
  print_matrix(src, src_size.height, src_size.width);

  // Interpolate only within the source sample boundaries
  int n_rows_dest = n_rows - 1;
  int n_cols_dest = n_columns - 1;
  int n_elements_dest = n_rows_dest * n_cols_dest;
  IppiSize dest_size = {n_cols_dest, n_rows_dest};
  Ipp32f * dest_x = new Ipp32f[n_elements_dest];
  Ipp32f * dest_y = new Ipp32f[n_elements_dest];
  for (int i = 0; i < n_rows_dest; i++)
  {
    for (int j = 0; j < n_cols_dest; j++)
    {
      int k = i * n_cols_dest + j;
      dest_x[k] = j + 0.5F;
      dest_y[k] = i + 0.5F;
    }
  }
  Ipp32f * dest = new Ipp32f[n_elements_dest];
  int dest_step_bytes =  n_cols_dest * sizeof(Ipp32f);

  status = ippiRemap_32f_C1R(src, src_size, src_step_bytes, src_rect,
                             dest_x, dest_step_bytes,
                             dest_y, dest_step_bytes,
                             dest, dest_step_bytes, dest_size, IPPI_INTER_LINEAR);

  printf("\nippiRemap status: %d\n", status);
  printf("Destination image:\n");
  print_matrix(dest, dest_size.height, dest_size.width);

}

void inside_outside_comparison()
{
  IppStatus status;

  int n_rows = 7;
  int n_columns = 6;

  IppiSize src_size = {n_columns, n_rows};
  IppiRect src_rect = {0, 0, n_columns, n_rows};
  // This image produces NaN (-1.#R printed) results when remapped at x = 3.5, y = -0.5
  // this is true with IPPI_INTER_NN or IPPI_INTER_CUBIC under release x64, other configurations produce different
  // results
  //Ipp32f src[4 * 4] = {0, 1, 2, 3,
  //                     4, 5, 6, 7,
  //                     8, 9, 0, 1,
  //                     2, 3, 4, 5
  //                    };

  int n_elements = n_rows * n_columns;
  Ipp32f * src = new Ipp32f[n_elements];

  for (int i = 0; i < n_elements; i++)
  {
    src[i] = (Ipp32f) i;
  }

  int src_step_bytes =  n_columns * sizeof(Ipp32f);

  printf("Source image:\n");
  print_matrix(src, src_size.height, src_size.width);

  // Interpolate only within the source sample boundaries
  int n_rows_all_in = n_rows - 1;
  int n_cols_all_in = n_columns - 1;
  int n_elements_all_in = n_rows_all_in * n_cols_all_in;
  IppiSize dst_all_in_size = {n_cols_all_in, n_rows_all_in};
  Ipp32f * dst_all_in_x = new Ipp32f[n_elements_all_in];
  Ipp32f * dst_all_in_y = new Ipp32f[n_elements_all_in];
  for (int i = 0; i < n_rows_all_in; i++)
  {
    for (int j = 0; j < n_cols_all_in; j++)
    {
      int k = i * n_cols_all_in + j;
      dst_all_in_x[k] = j + 0.5F;
      dst_all_in_y[k] = i + 0.5F;
    }
  }
  Ipp32f * dst_all_in = new Ipp32f[n_elements_all_in];
  int dst_all_in_step_bytes =  n_cols_all_in * sizeof(Ipp32f);

  status = ippiRemap_32f_C1R(src, src_size, src_step_bytes, src_rect,
                             dst_all_in_x, dst_all_in_step_bytes,
                             dst_all_in_y, dst_all_in_step_bytes,
                             dst_all_in, dst_all_in_step_bytes, dst_all_in_size, IPPI_INTER_CUBIC);

  printf("\nippiRemap status: %d\n", status);
  printf("All in Destination image:\n");
  print_matrix(dst_all_in, dst_all_in_size.height, dst_all_in_size.width);

  // Interpolate outside of the source sample boundaries
  int n_rows_some_out = n_rows + 1;
  int n_cols_some_out = n_columns + 1;
  int n_elements_some_out = n_rows_some_out * n_cols_some_out;
  IppiSize dst_some_out_size = {n_cols_some_out, n_rows_some_out};
  Ipp32f * dst_some_out_x = new Ipp32f[n_elements_some_out];
  Ipp32f * dst_some_out_y = new Ipp32f[n_elements_some_out];
  for (int i = 0; i < n_rows_some_out; i++)
  {
    for (int j = 0; j < n_cols_some_out; j++)
    {
      int k = i * n_cols_some_out + j;
      dst_some_out_x[k] = j - 0.5F;
      dst_some_out_y[k] = i - 0.5F;
    }
  }
  Ipp32f * dst_some_out = new Ipp32f[n_elements_some_out];
  int dst_some_out_step_bytes =  n_cols_some_out * sizeof(Ipp32f);


  status = ippiRemap_32f_C1R(src, src_size, src_step_bytes, src_rect,
                             dst_some_out_x, dst_some_out_step_bytes,
                             dst_some_out_y, dst_some_out_step_bytes,
                             dst_some_out, dst_some_out_step_bytes, dst_some_out_size, IPPI_INTER_NN);
  printf("\nippiRemap status: %d\n", status);
  printf("Some out Destination image:\n");
  print_matrix(dst_some_out, dst_some_out_size.height, dst_some_out_size.width);
}

int main(int argc, char * argv[])
{
  const IppLibraryVersion * lib = ippiGetLibVersion();
  printf("IPP library version: %s %s %d.%d build number: %d.%d\n\n",
         lib->Name, lib->Version, lib->major, lib->minor, lib->majorBuild, lib->build);


  //bad_example();

  //inside_outside_comparison();

  interpolate_past_boundary();
}

