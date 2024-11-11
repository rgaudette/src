#include <iostream>
#include <new>
#include <boost/smart_ptr/scoped_ptr.hpp>
#include <boost/smart_ptr/scoped_array.hpp>

using namespace std;
using namespace boost;

struct MyType
{
  MyType(int int_attr = 1, float float_attr = 2.0) : int_attr(int_attr), float_attr(float_attr)
  {
    cout << "    constructing a MyType at: " << this << endl;
    cout << "    int_attr: " << int_attr << "  float_attr: " << float_attr  << endl;
  }

  ~MyType()
  {
    cout << "   destroying a MyType at: " << this << endl;
  }

  int int_attr;
  float float_attr;
};


struct AllocateInInitializerList
{
    AllocateInInitializerList() : my_type(new MyType(1, 1.0))
    {
      cout << endl << "  constructing a AllocateInInitializerList at: " << this << endl;
      cout << "  AllocateInInitializerList.my_type raw pointer: " << my_type.get() << endl;
    }

    void do_something()
    {
      cout << "  Using AllocateInInitializerList at: " << this << endl;
    }


    ~AllocateInInitializerList()
    {
      cout << "  destroying a AllocateInInitializerList at: " << this << endl;
    }

  private:
    scoped_ptr<MyType> my_type;

};


struct AllocateInConstructor
{
    AllocateInConstructor()
    {
      cout << endl << "  constructing a AllocateInConstructor at: " << this << endl;
      my_type.reset(new MyType( 3, 3.0));
      cout << "  AllocateInConstructor.my_type raw pointer: " << my_type.get() << endl;
    }

    void use_me()
    {
      cout << "  Using AllocateInConstructor at: " << this << endl;
    }

    ~AllocateInConstructor()
    {
      cout << "  destroying a AllocateInConstructor at: " << this << endl;
    }

  private:
    scoped_ptr<MyType> my_type;

};


struct FailedAllocationInConstructor
{
    FailedAllocationInConstructor(size_t array_size)
    {
      cout << endl << "  constructing a FailedAllocationInConstructor at: " << this << endl;
      my_type.reset(new MyType(4, 4.0));
      cout << "  Attempting to allocate a an array of " << array_size << endl;
      huge.reset(new double[array_size]);
    }

    void do_something()
    {
      cout << "  Using FailedAllocationInConstructor at: " << this << endl;
    }

    ~FailedAllocationInConstructor()
    {
      cout << "  destroying a FailedAllocationInConstructor at: " << this << endl;
    }

  private:
    scoped_ptr<MyType> my_type;
    scoped_array<double> huge;

};


void allocate_multidimensional_array_of_objects()
{
  cout << "Entered allocate_multidimensional_array_of_objects" << endl;
  scoped_ptr < 
  scoped_ptr < 
  scoped_array< scoped_array<MyType> > multidim;
  multidim.reset(new scoped_array<MyType>[2]);
  scoped_array<MyType> lowest_level;
  for (int i = 0; i < 2; i++)
  {
    multidim[i].reset(new MyType[3]);
  }
}


int main(int argc, char * argv[])
{
  for (int i = 0; i < argc; i++)
    cout << argv[i] << endl;

  cout << "Declaring AllocateInInitializerList" << endl;
  AllocateInInitializerList allocate_in_initializer_list;
  allocate_in_initializer_list.do_something();
  cout << "done" << endl;

  cout << "Declaring AllocateInConstructor" << endl;
  AllocateInConstructor allocate_in_constructor;
  allocate_in_constructor.use_me();

  cout << "Newing AllocateInInitializerList" << endl;
  AllocateInInitializerList * ptr_allocate_in_initializer_list = new AllocateInInitializerList();
  ptr_allocate_in_initializer_list->do_something();
  cout << "done" << endl;

  cout << "Declaring FailedAllocationInConstructors" << endl;
  try
  {
    FailedAllocationInConstructor failed_allocation_in_constructor1(10);
    FailedAllocationInConstructor failed_allocation_in_constructor2(0x7fffffff);
  }
  catch (bad_alloc & exception_)
  {
    cout << "  failed big allocation in constructor" << endl;
  }

  allocate_multidimensional_array_of_objects();

  cout << "done" << endl;

  return 0;
}

