// Smart Pointers.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <tuple>
#include <algorithm>

using namespace std;

struct AClass
{
  int a;
  int * ptr_int;

  AClass() : a(-1){};

  AClass(int a_in) : a(a_in)
  {
    cout << "constructing AClass at: " << this << " with value " << a << endl;
  }

  void set(int a_in)
  {
    a = a_in;
    cout << "setting AClass at: " << this << " with value " << a << endl;
  }

  ~AClass()
  {
    cout << "destroying AClass at: " << this << " with value " << a << endl;
  }
};


struct Holder
{
  vector<AClass *> vec_ptr;
  vector<unique_ptr<AClass[]>> vec_unique_ptr_array;
  vector<shared_ptr<AClass>> vec_shared_ptr;
  vector<vector<AClass>> vec_vec;
  vector<vector<AClass>> vec_vec_2;
  //vector<vector<int>> vec_vec_i(0, vector<int>(0));
  //std::vector<std::vector<int>> container1(5, std::vector<int>(2));
  void fill_vector_unique()
  {
    vec_ptr.push_back(make_unique<AClass>(1).get());
    vec_ptr.push_back(make_unique<AClass>(2).get());
  }

  void fill_vector_shared()
  {
    vec_shared_ptr.push_back(make_shared<AClass>(1));
    vec_shared_ptr.push_back(make_shared<AClass>(2));
  }

//  void fill_array_shared()
//  {
//    shared_ptr<AClass[]> a = make_shared<AClass[]>(3);
//  }

  void fill_vec_vec(int n_rows, int n_cols)
  {
    vec_vec.reserve(n_rows);
    for (int idx_row = 0; idx_row < n_rows; ++idx_row)
    {
      vector<AClass> row;
      vec_vec.reserve(n_cols);
      vec_vec.push_back(row);
      for (int idx_column = 0; idx_column < n_cols; ++idx_column)
      {
        AClass a_class(0);
        vec_vec[idx_row].push_back(a_class);
        vec_vec[idx_row][idx_column].set(idx_column + idx_row * n_cols);
      }
    }
  }

  void copy_vec_vec(vector<vector<AClass>> vvi)
  {
    vec_vec_2.insert(vec_vec_2.cbegin(), vec_vec.begin(), vec_vec.end());
//    for (auto row_in : vvi)
//    {
//      vector<AClass> row(row_in.size());
//      vec_vec.push_back(row);
//      for (auto a_class : row_in)
//      {
//
//      }
//    }
  }


};

void print_vec_vec(vector<vector<AClass>> const & vvi)
{
  for (int idx_row = 0; idx_row < vvi.size(); ++idx_row)
  {
    for (int idx_column = 0; idx_column < vvi[idx_row].size(); ++idx_column)
    {
      cout << vvi[idx_row][idx_column].a << ", ";
    }
    cout << endl;
  }
}


void id_vec_vec(vector<vector<AClass>> const & vvi)
{
  cout << "root: " << &vvi[0] << endl;
  for (auto&& row : vvi)
  {
    cout << "  row: " << &row[0] << endl;
    for (auto&& element : row)
    {
      cout << "    element: " << & element << endl;
    }
  }
}

unique_ptr<float []> create_and_fill_array(int n_elem)
{
  auto arr = make_unique<float[]>(n_elem);

  for(int i = 0; i < n_elem; ++i)
  {
    arr[i] = i;
  }
  return arr;
}

unique_ptr<AClass []> create_and_fill_with_AClass(int n_elem)
{
  auto arr_AClass = make_unique <AClass []> (n_elem);
  for (int i = 0; i < n_elem; ++i)
  {
    arr_AClass[i].set(i);
  }
  return arr_AClass;
}

int main()
{
  Holder h;
//  h.fill_vector_unique();
//  cout << "after fill_vector_unique" << endl;
//
//  h.fill_vector_shared();
//  cout << "after fill_vector_shared" << endl;

//  h.fill_array_shared();
//  cout << "after fill_array_shared" << endl;
//  h.fill_vec_vec(1,2);
//  cout << "after fill_vec_vec" << endl;
//  print_vec_vec(h.vec_vec);
//  cout << "after copy_vec_vec" << endl;
//  h.copy_vec_vec(h.vec_vec);
//  print_vec_vec(h.vec_vec_2);
//  id_vec_vec(h.vec_vec);
//  id_vec_vec(h.vec_vec_2);
//  h.vec_vec_2[0][0].set(-1);
//  h.vec_vec_2[0][1].set(-2);
//  print_vec_vec(h.vec_vec);
//  print_vec_vec(h.vec_vec_2);
//  id_vec_vec(h.vec_vec);
//  id_vec_vec(h.vec_vec_2);

  unique_ptr<float[]> main_arr;
  int n_elem = 4;
  cout << "create_and_fill_array" << endl;
  main_arr = create_and_fill_array(n_elem);
  cout << "main_arr contents" << endl;
  for (int i = 0; i < n_elem; ++i)
  {
    cout << main_arr[i] << endl;;
  }


  unique_ptr<AClass[]> arr_AClass;
  cout << "create_and_fill_with_AClass" << endl;
  arr_AClass = create_and_fill_with_AClass(n_elem);
  cout << "arr_AClass contents" << endl;
  for (int i = 0; i < n_elem; ++i)
  {
    cout << "AClass at: " << & arr_AClass[i] << " with value:  " << arr_AClass[i].a << endl;;
  }

  cout << "empty unique_ptr get()" << endl;
  unique_ptr<float[]> empty;
  cout << empty.get() << endl;
  return 0;
}

