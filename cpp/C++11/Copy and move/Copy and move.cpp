#include "stdafx.h"

#include <iostream>
#include <tuple>
#include <vector>
#include <memory>

using namespace std;
template <typename T>
using TupleOfVectors = tuple <vector<T>, vector<T>, vector<T> >;


template <typename T>
TupleOfVectors<T> & func(TupleOfVectors<T> & arg)
{
  TupleOfVectors<T> & ret = arg;
  return ret;
}


struct AStruct
{
  int a;
  float b;
};


unique_ptr<AStruct[]> fill_AStruct(int n_structs)
{
  unique_ptr<AStruct[]> a_structs = unique_ptr<AStruct[]> {new AStruct[n_structs]};
  for (int i = 0; i < n_structs; i++)
  {
    a_structs[i].a = i;
    a_structs[i].b = 10.0 * i;
  }

  for (int i = 0; i < n_structs; i++)
  {
    cout << "a_struct: " << i << " : " << &a_structs[i] << endl;
  }

  return a_structs;
}

int main()
{
  vector<float> v1 = {1.0, 2.0};
  cout << "vector v1 pointer: " << &v1 << endl;
  cout << "vector v1[0] pointer : " << &(v1[0]) << endl;
  cout << "vector v1[1] pointer : " << &(v1[1]) << endl;

  vector<float> v2 = {3.0, 4.0};
  cout << "vector v2 pointer: " << &v2 << endl;
  cout << "vector v2[0] pointer : " << &(v2[0]) << endl;
  cout << "vector v2[1] pointer : " << &(v2[1]) << endl;

  vector<float> v3 = {5.0, 6.0};
  cout << "vector v3 pointer: " << &v3 << endl;
  cout << "vector v3[0] pointer : " << &(v3[0]) << endl;
  cout << "vector v3[1] pointer : " << &(v3[1]) << endl;

  TupleOfVectors<float> tov = make_tuple(v1, v2, v3);
  cout << "tov tuple pointer: " << &tov << endl;

  TupleOfVectors<float>  & ret = func(tov);
  cout << "ret tuple pointer: " << &ret << endl;

  int n_structs = 2;
  unique_ptr<AStruct[]> m_structs = fill_AStruct( n_structs);
  for (int i = 0; i < n_structs; i++)
  {
    cout << "a_struct: " << i << " : " << &m_structs[i] << endl;
  }


  return 0;
}

