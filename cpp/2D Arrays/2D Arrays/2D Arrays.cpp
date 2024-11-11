
#include "stdafx.h"

using namespace std;

struct Point
{
  double x;
  double y;

  void set(double x_in, double y_in)
  {
    x = x_in;
    y = y_in;
  }

  double get_x()
  {
    return x;
  }

  double get_y()
  {
    return y;
  }

};


vector<vector<Point>> create_points()
{
  int n_rows = 3;
  int n_cols = 4;
  vector<vector<Point>> points(n_rows, vector<Point>(n_cols));

  for (int i_row = 0; i_row < n_rows; ++i_row)
  {
    for (int i_column = 0; i_column < n_cols; ++i_column)
    {
      points[i_row][i_column].set(i_column + i_row * n_cols, -1.0 * (i_column + i_row * n_cols));
    }
  }
  cout << "points address: " << &points << endl;
  cout << "points[0] address: " << &points[0] << endl;
  cout << "First point address: " << &points[0][0] << endl;
  return points;
}


int main(int argc, char ** argv)
{
  auto points = create_points();
  cout << "points address: " << &points << endl;
  cout << "points[0] address: " << &points[0] << endl;
  cout << "First point address: " << &points[0][0] << endl;

  int n_rows = points.size();
  int n_cols = points[0].size();
  for (int i_row = 0; i_row < n_rows; ++i_row)
  {
    for (int i_column = 0; i_column < n_cols; ++i_column)
    {
      cout << points[i_row][i_column].get_x() << "," << points[i_row][i_column].get_y() << " ";
    }
    cout << endl;
  }
  return 0;
}

