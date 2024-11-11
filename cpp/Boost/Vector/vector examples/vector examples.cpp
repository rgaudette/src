// vector examples.cpp : Defines the entry point for the console application.
//
#include <iostream>
#include <vector>

using namespace std;

struct SimpleType
{
  static int _instance_counter;
  int _id;

  SimpleType()
  {
    _id = _instance_counter;
    _instance_counter++;

    cout << "default constructing simple type id: " << _id << endl;
  }

  SimpleType(SimpleType const & source)
  {
    _id = _instance_counter;
    _instance_counter++;
    cout << "copy constructing simple type id: " << _id << " from : " << source.id() << endl;
  }

  int id() const
  {
    return _id;
  }

  ~SimpleType()
  {
    cout << "destroying simple type id: " << _id << endl;
  }
};

int SimpleType::_instance_counter = 0;

void populate_simple_type_vec(vector<SimpleType> & vec, int n_elems)
{
  for (int i = 0; i < n_elems; i++)
  {
    SimpleType * ptrANewSimpleType = new SimpleType;
    vec.push_back(*(ptrANewSimpleType));
    cout << endl;
  }
}

//void populate_with_scoped_ptrs(vector<SimpleType> & vec, int n_elems))
//{
//
//}

int main(int argc, char *argv[])
{
  //vector<int> vint;
  //vint.push_back(1);
  //vint.push_back(2);
  //vint.push_back(3);

  //cout << "vint size: " << vint.size() << endl;
  //cout << "vint capacity: " << vint.capacity() << endl;
  //vint[2] = 5;
  //cout << "vint[2]: " << vint[2] << endl;
  // 
  //vector<SimpleType> vst;
  //cout << vst.size() << endl;

  //vst.resize(3);

  //for (auto & st : vst)
  //{
  //  cout << st.id() << endl;
  //}
  //cout << "calling vst clear" << endl;
  //vst.clear();
  //cout << "done" << endl;

  cout << "declare vstp" << endl;
  vector<SimpleType> vstp;
  vstp.reserve(4);

  cout << "populate vstp" << endl;
  populate_simple_type_vec(vstp, 2);

  for (auto & st : vstp)
  {
    cout << st.id() << endl;
  }

  cout << "resize vstp" << endl;
  vstp.resize(4);
  cout << "calling vstp clear" << endl;
  vstp.clear();
  cout << "done" << endl;


  return 0;
}

