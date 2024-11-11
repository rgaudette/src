#include "pch.h"
#include <iostream>
#include <vector>

using namespace std;


// A structure with an array
// * the move constructor needs to copy the pointer from the argument object
// * to be safe the move constructor modifies the argument to null the pointer
template<typename T>
class StructWithAnArray
{
    int n_elements = 0;
    T * arr = nullptr;

  public:
    // Default constructor
    StructWithAnArray()
    {
      cout << "Default constructing StructWithAnArray @: " << this << " arr @: " << arr << endl;
      n_elements = 0;
      arr = nullptr;
    }

    // Parameterized constructor
    StructWithAnArray(T n) : n_elements(n)
    {
      arr = new T[n_elements];
      cout << "Parameterized constructing StructWithAnArray @: " << this << " arr @: " << arr << endl;
    }

    // Copy constructor
    StructWithAnArray(StructWithAnArray const & rhs) : n_elements(rhs.n_elements)
    {
      arr = new T[n_elements];
      copy(rhs.arr, rhs.arr + n_elements, arr);
      cout << "Copy constructing StructWithAnArray @: " << this << " arr @: " << arr << endl;
    }

    // Move constructor
    StructWithAnArray(StructWithAnArray && rhs) noexcept :
      n_elements(rhs.n_elements), arr(rhs.arr)
    {
      rhs.n_elements = 0;
      rhs.arr = nullptr;
      cout << "Move constructing StructWithAnArray @: " << this << " arr @: " << arr << endl;
    }

    ~StructWithAnArray()
    {
      cout << "Deleting StructWithAnArray @: " << this << " arr @: " << arr << endl;
      delete[] arr;
      arr = nullptr;
    }

    void allocate(T n)
    {
      delete[] arr;
      n_elements = n;
      arr = new T[n_elements];
      cout << "allocating StructWithAnArray @: " << this << " arr @: " << arr << endl;
    }


    T * get_arr()
    {
      return arr;
    }

    template<typename T1>
    friend std::ostream & operator<<(std::ostream & stream, StructWithAnArray<T1> const & obj);
};

template<typename T>
std::ostream & operator<<(std::ostream & stream, StructWithAnArray<T> const & obj)
{
  cout << endl;
  cout << "arr(@: " << &(obj.arr) << ")" << ": ";
  for (int i = 0; i < obj.n_elements; ++i)
  {
    cout << obj.arr[i] << " ";
  }
  cout << endl;

  return stream;
}


// A structure with a STL container, the move constructor just needs to call move on the container
template<typename T>
struct StructWithAVector
{
  int raw_attribute;
  vector<T> vec;
  StructWithAVector()
  {
    cout << "Default constructing StructWithAVector @: " << this << " vec @: " << & vec << endl;
  }

  // Copy constructor
  StructWithAVector(StructWithAVector const & rhs) : vec(rhs.vec)
  {
    cout << "Copy constructing StructWithAVector @: " << this << " vec @: " << &vec << endl;
  }

  // Move constructor
  StructWithAVector(StructWithAVector && rhs) : vec(move(rhs.vec))
  {
    cout << "Move constructing StructWithAVector @: " << this << " vec @: " << &vec << endl;
  }

  ~StructWithAVector()
  {
    cout << "Deleting StructWithAVector @: " << this << " vec @: " << &vec << " vec.data: " << vec.data() << endl;
  }

  // template<typename T1>
  // friend std::ostream & operator<<(std::ostream & stream, StructWithAVector<T1> const & obj);
};

template<typename T>
std::ostream & operator<<(std::ostream & stream, StructWithAVector<T> const & obj)
{
  cout << endl;
  cout << "vec(@: " << &(obj.vec) << ")" << " ";
  cout << "vec.data : " << obj.vec.data() << ": ";
  for (const auto & element : obj.vec)
  {
    cout << element << " ";
  }
  cout << endl;

  return stream;
}


template<typename T>
struct CompoundStruct
{
  StructWithAVector<T> struct_with_a_vector;
  StructWithAnArray<T> struct_with_an_array;

  CompoundStruct()
  {
    cout << "Default constructing CompoundStruct @: " << this
         << " struct_with_a_vector @: " << &struct_with_a_vector
         << " struct_with_an_array @: " << &struct_with_an_array << endl;
  }

  // Copy constructor
  CompoundStruct(CompoundStruct const & rhs) noexcept :
    struct_with_a_vector(rhs.struct_with_a_vector),
    struct_with_an_array(rhs.struct_with_an_array)
  {
    cout << "Copy constructing CompoundStruct @: " << this
         << " struct_with_a_vector @: " << &struct_with_a_vector
         << " struct_with_an_array @: " << &struct_with_an_array << endl;
  }

  // Copy assignment operator

  // Move constructor
  CompoundStruct(CompoundStruct && rhs) noexcept:
    struct_with_a_vector(move(rhs.struct_with_a_vector)),
    struct_with_an_array(move(rhs.struct_with_an_array))
  {
    cout << "Move constructing CompoundStruct @: " << this
         << " struct_with_a_vector @: " << &struct_with_a_vector
         << " struct_with_an_array @: " << &struct_with_an_array << endl;
  }
  // template<typename T1>
  // friend std::ostream & operator<<(std::ostream & stream, CompoundStruct<T1> const & obj);
};

template<typename T>
std::ostream & operator<<(std::ostream & stream, CompoundStruct<T> const & obj)
{
  cout << endl;
  cout << "struct_with_a_vector(@: " << &(obj.struct_with_a_vector) << ")" << ": " << obj.struct_with_a_vector << endl;
  cout << "struct_with_an_array(@: " << &(obj.struct_with_an_array) << ")" << ": " << obj.struct_with_an_array << endl;
  return stream;
}



int main()
{
  CompoundStruct<int> cs_original;
  cout << endl;
  cout << " default cs_original(@: " << &cs_original << ")" << ": " << cs_original << endl;

  cs_original.struct_with_a_vector.vec.push_back(-1);
  cs_original.struct_with_a_vector.vec.push_back(-2);
  cs_original.struct_with_a_vector.vec.push_back(-3);

  cs_original.struct_with_an_array.allocate(4);
  cs_original.struct_with_an_array.get_arr()[0] = 1;
  cs_original.struct_with_an_array.get_arr()[1] = 2;
  cs_original.struct_with_an_array.get_arr()[2] = 3;
  cs_original.struct_with_an_array.get_arr()[3] = 4;

  cout << endl;
  cout << "set cs_original(@: " << &cs_original << ")" << ": " << cs_original << endl;


  cout << "This should call the copy constructor" << endl;
  CompoundStruct<int> cs_copy(cs_original);
  cout << "cs_copy(@: " << &cs_copy << ")" << ": " << cs_copy << endl;

  std::vector<CompoundStruct<int>> cs_vec;
  cout << "pushing cs_original on to the cs_vec" << endl;
  cs_vec.push_back(move(cs_original));
  cout << "cs_vec[0](@: " << &cs_vec[0] << ")" << ": " << cs_vec[0] << endl;
  cout << "done" << endl;

  // Try reading the moved object, this will not fail, but the compiler complains about it
  cout << "reading stale moved cs" << endl;
  cout << "cs_original(@: " << &cs_original << ")" << ": " << cs_original << endl;
  // This causes th program to crash without any message
  // cs.struct_with_a_vector.vec.push_back(-10);
  // cs.struct_with_an_array.get_arr()[0] = 10;
  // cout << "wrote stale moved cs" << endl;
  // cout << "cs_original(@: " << &cs << ")" << ": " << cs << endl;
  // cout << "cs_vec[0](@: " << &cs_vec[0] << ")" << ": " << cs_vec[0] << endl;

  return 0;
}
