// vector examples.cpp : Defines the entry point for the console application.
//
#include <iostream>
#include <vector>
#include <boost/smart_ptr/shared_ptr.hpp>

using namespace std;
using namespace boost;


const float init[] = {1.0F, 1.0F, 1.0F, 1.0F, 1.0F};
const std::vector<float> const_vector(init, init + 5);

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

void populate_with_shared_ptrs(vector<boost::shared_ptr<SimpleType> > & vec, int n_elems)
{
  for (int i = 0; i < n_elems; i++)
  {
    boost::shared_ptr<SimpleType> simpleTypeSharedPtr(new SimpleType);
    vec.push_back(simpleTypeSharedPtr);
    cout << endl;
  }

}

void delete_by_pop_back(vector<boost::shared_ptr<SimpleType> > & vec)
{
  while (!vec.empty())
  {
    vec.pop_back();
    cout << endl;
  }

}


bool if_between_3_and_6(int value)
{
  if (value > 2 && value < 6)
  {
    return true;
  }
  return false;
}


int main(int argc, char *argv[])
{
  std::vector<int> v1(10);
  std::cout << v1.size() << endl;
  std::vector<int> v2{10};
  std::cout << v2.size() << endl;

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

  //////////////////////////////////////////////////////////////
  cout << "declare vstp" << endl;
  vector<SimpleType> vstp;
  vstp.reserve(4);

  cout << "populate vstp" << endl;
  populate_simple_type_vec(vstp, 2);


  //for (auto & st : vstp)
  //{
  //  cout << st.id() << endl;
  //}
  vector<SimpleType>::const_iterator st;
  for (st = vstp.begin(); st != vstp.end(); ++ st)
  {
    cout << st->id() << endl;
  }
  cout << "resize vstp" << endl;
  vstp.resize(4);
  cout << "calling vstp clear" << endl;
  vstp.clear();

  cout << "done" << endl;


  //////////////////////////////////////////////////////////////
  cout << "declare vsstp" << endl;
  vector<boost::shared_ptr<SimpleType> > vsstp;
  vsstp.reserve(4);

  cout << "populate vsstp" << endl;
  populate_with_shared_ptrs(vsstp, 2);


  vector<boost::shared_ptr<SimpleType> >::const_iterator cist;
  for (cist = vsstp.begin(); cist != vsstp.end(); ++cist)
  {
    cout << (*cist)->id() << endl;
  }
  cout << "resize vsstp" << endl;
  vsstp.resize(4);
  //cout << "calling vsstp clear" << endl;
  //vstp.clear();
  cout << "calling delete_by_pop_back(vsstp)" << endl;
  delete_by_pop_back(vsstp);

  cout << "done" << endl;

  vector<int> v_int = {1, 2, 3, 4, 5, 6, 7};
  v_int.erase(remove_if(v_int.begin(), v_int.end(), if_between_3_and_6), v_int.end());

  for (auto & value : v_int)
  {
    cout << value << ", ";
  }
  cout << endl;

  vector<int> v_int_2 = {1, 2, 3, 4, 5, 6, 7};
  for(vector<int>::iterator iter = v_int_2.begin(); iter != v_int_2.end();)
  {
    if(if_between_3_and_6(*iter))
    {
      iter = v_int_2.erase(iter);
    }
    else
    {
      ++iter;
    }
  }
  for (auto & value : v_int_2)
  {
    cout << value << ", ";
  }
  cout << endl;
  return 0;
}

