#include <cmath>
#include <cstdlib>
#include <experimental/filesystem> // C++-standard header file name
#include <filesystem> // Microsoft-specific implementation header file name

#include <iostream>
#include <string>
#include <vector>

#include "boost/program_options.hpp"
#include "boost/tokenizer.hpp"

using namespace std;
using namespace std::experimental::filesystem::v1;
using namespace boost;
using string = string;


template<typename T>
void print_vector(vector<T> const & v)
{
  cout << "[ ";
  for (int i = 0; i < v.size(); ++i)
  {
    cout << v[i] << ", ";
  }
  cout << "]";
}

// Parse a vector of strings in to a single vector of the type specified by the output argument.  Each string in the
// input can contain one or more regions that specify an output value separated by spaces or commas.  The values are
// appended on to the output vector.
template<typename T>
void parse_vector(vector<string> const & input, vector<T> & output)
{
  boost::char_separator<char> seperators{ " ," };
  for (auto const & str : input)
  {
    boost::tokenizer<boost::char_separator<char>> tokenizer{str, seperators};
    for (auto const & token : tokenizer)
    {
      output.push_back(lexical_cast<T>(token));
    }
  }
}


int main(int argc, char ** argv)
{

  int opt;
  program_options::options_description description("description caption");

  try
  {
    description.add_options()
    ("help", "produce help message")
    ("int_value,i", program_options::value<int>(&opt)->default_value(10), "integer option")
    // It appears that simply specifying the value as a vector allows the option to be specified multiple times on the
    // command line, program options appends to the vector for each
    ("vector_element,v", program_options::value<vector<double>>(), "vector elements")
    ("composed_option,c", program_options::value<vector<string>>()->composing(), "composed option")
    // boost program_options doesn't seem to handle multitoken floating point numbers correctly, thus we need to read
    // it in as a string and then convert it to a vector
    ("multitoken_option,m", program_options::value<vector<string>>()->multitoken(), "multitoken option")
    ;
  }
  catch (program_options::error & desc_error)
  {
    cerr << "description error:" << desc_error.what() << endl;
    exit(1);
  }

  program_options::variables_map vm;
  try
  {
    // Parse the command line
    program_options::basic_parsed_options<char> const command_line_options =
      program_options::parse_command_line(argc, argv, description);
    program_options::store(command_line_options, vm);

    // Parse the config file if it exists
    string config_filename("program options.cfg");
    path config_path(config_filename);
    if (exists(config_path))
    {
      program_options::basic_parsed_options<char> const config_file_options =
        program_options::parse_config_file<char>(config_filename.c_str(), description);

      program_options::store(config_file_options, vm);
    }

    program_options::notify(vm);

  }
  catch (program_options::error & parse_error)
  {
    cerr << "parse error:" << parse_error.what() << endl;
    exit(2);
  }

  string option;

  try
  {
    option = "int_value";
    if (vm.count("int_value"))
    {
      cout << "int_value level was set to " << vm["int_value"].as<int>() << ".\n";
    }
    else
    {
      cout << "int_value level was not set.\n";
    }

    option = "vector_element";
    cout << "vector_element count: " << vm.count("vector_element") << endl;
    cout << "vector_element vector size: " << vm["vector_element"].as<vector<double>>().size() << endl;
    if (vm.count("vector_element"))
    {
      cout << "vector_element was set to ";
      print_vector(vm["vector_element"].as<vector<double>>());
      cout << endl;
    }
    else
    {
      cout << "vector_element was not set.\n";
    }

    option = "composed_option";
    cout << "composed_option count: " << vm.count("composed_option") << endl;
    if (vm.count("composed_option"))
    {
      cout << "composed_option vector size: " << vm["composed_option"].as<vector<string>>().size() << endl;
      cout << "composed_option was set to ";
      print_vector(vm["composed_option"].as<vector<string>>());
      cout << endl;
    }
    else
    {
      cout << "composed_option was not set.\n";
    }

    option = "composed_option";
    cout << "multitoken_option count: " << vm.count("multitoken_option") << endl;
    if (vm.count("multitoken_option"))
    {
      cout << "multitoken_option vector size: " << vm["multitoken_option"].as<vector<string>>().size() << endl;
      cout << "multitoken_option was set to " << endl;
      vector<double> multittoken_vector;
      parse_vector(vm["multitoken_option"].as<vector<string>>(), multittoken_vector);
      print_vector(multittoken_vector);
      cout << endl;
    }
    else
    {
      cout << "multitoken_option was not set.\n";
    }

  }
  catch (program_options::error & access_error)
  {
    cerr << option << " access error:" << access_error.what() << endl;
    exit(3);
  }


}
