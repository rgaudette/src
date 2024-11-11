// Filesystem Example.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "boost/filesystem.hpp"

int main(int argc, char* argv[])
{
  if (argc < 2)
  {
    std::cout << "Usage: tut2 path\n";
    return 1;
  }

  boost::filesystem::path p(argv[1]);  // avoid repeated path construction below

  if (boost::filesystem::exists(p))    // does path p actually exist?
  {
    if (boost::filesystem::is_regular_file(p))        // is path p a regular file?
      std::cout << p << " size is " << boost::filesystem::file_size(p) << '\n';

    else if (boost::filesystem::is_directory(p))      // is path p a directory?
      std::cout << p << " is a directory\n";

    else
      std::cout << p << " exists, but is not a regular file or directory\n";
  }
  else
    std::cout << p << " does not exist\n";

  return 0;
}