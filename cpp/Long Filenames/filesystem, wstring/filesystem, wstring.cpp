// filesystem.cpp : This file contains the 'main' function. Program execution begins and ends there.
//
#include <filesystem>
#include <iostream>
#include <string>

int main()
{
  using namespace std;
  using namespace std::filesystem;

  wstring path_240_str =
    L"C:/Users/rick/Src/cpp/Long Filenames/this is a really long, multiple directory pathname/this is more of the pathname, hm how do I fill characters/here is"
    L" another long directory name, this should make the pathname 240 characters-should pass";

  try
  {
    auto path_240 = path(path_240_str);
    //cout << "path_240: " << path_240 << endl;
    create_directories(path_240);
    //cout << endl;

    wstring extend(L"");
    for (auto i = 2; i < 30; i++)
    {
      auto first_digit = i % 10;
      //cout << first_digit << endl;
      extend += to_wstring(first_digit);

      wstring extended_path_str = path_240_str + L"/" + extend;
      auto extended_path = path(extended_path_str);
      //wcout << L"absolute extended_path: " << absolute(extended_path) << endl;
      create_directories(extended_path);
      //cout << endl;
    }
  }
  catch (filesystem_error & e)
  {
    cout << "filesystem_error exception attempting to create output_dir or its sub-directories: " << endl;
    cout << "What: " << e.what() << endl;
    cout << "Error code: " << e.code() << endl;

    cout << "Path 1: " << e.path1() << endl;
    cout << "Path 2: " << e.path2() << endl;
    exit(26);
  }
  catch (exception & e)
  {
    cout << "std::exception (or subclass) attempting to create output_dir or its sub-directories: " << endl;
    cout << "What: " << e.what() << endl;

    exit(27);
  }
  catch (...)
  {
    cout << "No output written, exception of unknown type (not derived from std::exception) attempting to create output path!" << endl;
    exit(28);
  }

}
