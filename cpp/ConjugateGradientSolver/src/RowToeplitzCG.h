#pragma once

class RowToeplitzCG
{
  public:
    RowToeplitzCG(int n_rows_max, int n_impulse_max, int n_restart = 50);
    ~RowToeplitzCG(void);

    int solve_normal_eq(const float * row,
                        int n_row_elements,
                        int n_rows,
                        const float * b,
                        float * est_x,
                        int i_max,
                        float epsilon);

    void updateResidual(const float * row,
                        int n_row_elements,
                        int n_rows,
                        float * est_x,
                        int n_cols,
                        const float * b);

  private:
    int n_restart;
    int n_rows_max;
    int n_impulse_max;

    float * d;
    float * r;
    float * q;
    float * temp1;
    float * temp2;

    float * a_d;
    float * b_normal;


    // The maximum number of elements must be specified during construction, so that we don't need implement any alloc
    // calls during solving or setting
    RowToeplitzCG(void);
};