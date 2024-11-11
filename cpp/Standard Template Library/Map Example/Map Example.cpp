#include <iostream>
#include <map>

using namespace std;

int main(int argc, char * argv[])
{
  map<int, double> a_map;

  std::pair<std::map<int, double>::iterator, bool> ret_value;
  ret_value = a_map.insert(pair<int, double>(1, 3.14));

  if (ret_value.second)
  {
    cout << "insert succeeded" << endl;
    cout << "element at 1 " << a_map[1] << endl;
  }
  else
  {
    cout << "insert failed" << endl;
    cout << "element at 1 " << a_map[1] << endl;
  }

  ret_value = a_map.insert(pair<int, double>(1, 2 * 3.14));
  if (ret_value.second)
  {
    cout << "second insert succeeded" << endl;
    cout << "element at 1 " << a_map[1] << endl;
  }
  else
  {
    cout << "second insert failed" << endl;
    cout << "element at 1 " << a_map[1] << endl;
  }
  return 0;
}

