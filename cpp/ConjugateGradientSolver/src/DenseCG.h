#pragma once

template <typename T> class MKLMatrix;

class DenseCG
{
public:
  DenseCG(int max_elements, int n_restart = 50);
  ~DenseCG(void);
  void setA(float * mat_A, int n_rows, int n_cols, int step_bytes);
  void setA(MKLMatrix<float> & matrix);
  void setB(float * b, int n_rows);
  int solve(float * est_x, int i_max, float epsilon);
  int solve_normal_eq_ipp(float * est_x, int i_max, float epsilon);
  int solve_normal_eq_blas(float * est_x, int i_max, float epsilon = sqrt(numeric_limits<float>::min()));

private:  
  int n_restart;
  float * mat_A;
  float * b;
  int n_elements;
  
  float * d;
  float * r;
  float * q;
  float * temp1;
  float * temp2;

  float * a_d;
  float * b_normal;

  int max_elements;
  int step_bytes_A;
  int n_rows;
  int n_cols;

  // The maximum number of elements must be specified during construction, so that we don't need implement any alloc
  // calls during solving or setting
  DenseCG(void);  

};
