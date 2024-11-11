#include <iostream>
#define _USE_MATH_DEFINES
#include <math.h>

using namespace std;

void a_func(const float * value_is_const_1, float const * value_is_const_2, float * const ptr_is_const)
{
  // This is not allowed since the location pointed to by ptr_is_const is constant, it returns the following error
  // error C3892: 'ptr_is_const' : you cannot assign to a variable that is const
  //float a_float_var;
  //ptr_is_const = & a_float_var;

  const float a_local_const = (float) M_PI;

  // This is also not allowed since we are again attempting to reassign ptr_is_const but gives a different error
  // error C2440: '=' : cannot convert from 'const float *' to 'float *const '
  // that error is less clear than C3892
  // ptr_is_const = & a_local_const;

  *(ptr_is_const) = *(value_is_const_1) + *(value_is_const_2) + a_local_const;
}

class AClass
{
  private:
    const int an_int;
    const float a_cfloat;

    float a_float;

  public:
    AClass() : an_int(1), a_cfloat(2.0F), a_float(3.0F)
    {
    }

    AClass(int arg1, float arg2, float arg3) : an_int(arg1), a_cfloat(arg2), a_float(arg3)
    {
    }

    // A const class member must initialized in the base or member initializer list, the following two errors are 
    // produced from the following constructor
    // error C2758: 'AClass::an_int' : must be initialized in constructor base/member initializer list
    // error C2166: l-value specifies const object
    //AClass(int arg1, float arg2) : a_cfloat(arg2)
    //{
    //  an_int = arg1;
    //}

    void set_a_float(float value)
    {
      a_float = value;
    }

    float get_a_float(void) const
    {
      return a_float;
    }

    // Below produces the following error
    // error C2166: l-value specifies const object
    //void set_an_int(int arg)
    //{
    //  an_int = arg;
    //}

    const int get_an_int(void)
    {
      return an_int;
    }

    // Is it possible to sneak around the constness of the members by returning a pointer to the member
    const int * get_an_int_ptr(void) 
    {
      return & an_int;
    }
    // No because the return type is a const int * and therefore must be that type on the left hand side of the call


    float * get_a_float_ptr(void)
    {
      return & a_float;
    }

    float const * get_a_float_ptr(void) const
    {
      cout << "called const get_a_float_ptr " << endl;
      return const_cast<float const *>(& a_float);
    }

private:
    AClass & operator=(AClass & ) {};
};


int main(int argc, char * argv[])
{
  for(int i = 0; i < argc; i++)
  {
    cout << argv[i] << endl;
  }

  // const arguments of a function
  float val_1 = 1.0F;
  float val_2 = 2.0F;
  // This parameter can't be const because the declaration for a_func does not guarantee it will not be modified
  float val_3 = 3.0F;
  a_func(& val_1, & val_2, & val_3);

  const float cval_1 = 1.0F;
  const float cval_2 = 2.0F;
  // This parameter can't be const because the declaration for a_func does not guarantee it will not be modified
  float cval_3 = 3.0F;

  a_func(& cval_1, & cval_2, & cval_3);


  AClass a_class(10, 20, 30);

  cout << "a_class.an_int: " << a_class.get_an_int() << endl;
  const int * local_an_int = a_class.get_an_int_ptr();

  cout << "a_class.a_float: " << a_class.get_a_float() << endl;
  
  float * reg_ptr = a_class.get_a_float_ptr();
  cout <<  "a_class.a_float ptr: " << reg_ptr << endl; 
  // Why doesn't this call the const version of get_a_float_ptr
  float const * const ptr = a_class.get_a_float_ptr();
  cout <<  "a_class.a_float const ptr: " << ptr << endl;  
  return 0;
}

