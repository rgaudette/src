#include <iostream>

#include "boost/filesystem.hpp"
#include "boost/program_options.hpp"
#include "boost/lexical_cast.hpp"

namespace progopts = boost::program_options;
using namespace boost::filesystem;

using namespace std;

///////////////////////////////////////////////////////////////////////////////
//  Parse the command line using boost::progopts
///////////////////////////////////////////////////////////////////////////////
bool parse_command_line(int argc, char ** argv, progopts::variables_map & cmd_args)
{

  progopts::options_description desc("Arguments");
  desc.add_options()
  ("help", "A simple program to demonstrate the use of Boost Program Options")

  ("option_string,s", progopts::value<string>()->required(), "a required string option")
  ("bool_switch,b", progopts::bool_switch(), "a bool_switch with a default of false")
  ("bool_switch_f,f", progopts::bool_switch()->default_value(false), "a bool_switch with a default of false")
  ("bool_switch_t,t", progopts::bool_switch()->default_value(true), "a bool_switch with a default of true")
  ;

  try
  {
    // The first definition of an argument is the one that is used, thus look at the command line first
    progopts::store(progopts::parse_command_line(argc, argv, desc), cmd_args);

    // Then the config file if it exists
    string config_filename("Program Options.cfg");
    if (exists(path(config_filename)))
    {
      progopts::store(progopts::parse_config_file<char>(config_filename.c_str(), desc), cmd_args);
    }

    if (cmd_args.count("help"))
    {
      cout << desc << "\n";
    }

    progopts::notify(cmd_args);
  }

  catch (exception & e)
  {
    cout << desc << "\n";
    cerr << "command line option error: " << e.what() << "\n";
    return false;
  }
  catch (...)
  {
    cout << desc << "\n";
    cerr << "Exception of unknown type in parse_command_line!\n";
    return false;
  }

  return true;
}

int main(int argc, char ** argv)
{

  // Parse the command line options
  progopts::variables_map cmd_args;
  auto const success = parse_command_line(argc, argv, cmd_args);
  if (!success)
  {
    exit(-1);
  }

  // Parse the config file if it exists
  string config_filename("program options.cfg");
  path config_path(config_filename);
  if (exists(config_path))
  {
    progopts::basic_parsed_options<char> const config_file_options =
      progopts::parse_config_file<char>(config_filename.c_str(), description);

    progopts::store(config_file_options, cmd_args);
  }

  cout << "option_string (s): " << cmd_args["option_string"].as<string>() << endl;
  cout << "bool_switch: " << cmd_args["bool_switch"].as<bool>() << endl;
  cout << "bool_switch_f (default: false): " << cmd_args["bool_switch_f"].as<bool>() << endl;
  cout << "bool_switch_t (default: true): " << cmd_args["bool_switch_t"].as<bool>() << endl;

  cout << boost::lexical_cast<bool, string>(string("true")) << endl;
}
