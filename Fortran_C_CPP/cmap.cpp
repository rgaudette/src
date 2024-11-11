#include <iostream>

#include <map>
#include <string>

using namespace std;

//  Define a C interface to argument map object
extern "C" {
  void initialize_();
  void addargument_(char *key, int * keyLength, char *argument, int *argLength);
  void getoption_(char *option, int *optionLength, char *value, int *valueLength);
  void destroy_();

  map<const string, string> *optionMap;

  void initialize_() {
    optionMap  = new map<const string, string>;
  }

  void addargument_(char *key, int *keyLength, char *argument, int *argLength){
    //  Convert the FORTRAN character arrays into strings.
    char * str;
    str = new char[*keyLength + 1];
    memcpy(str, key, *keyLength);
    cout << str << endl;
  }

  void getoption_(char *option, int *optionLength, char *value, int *valueLength){
  }

  void destroy_() {
    delete optionMap;
  }

}


    
