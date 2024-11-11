#include "pch.h"
#include <iostream>

#include "spdlog/spdlog.h"
#include "spdlog/sinks/basic_file_sink.h"


using namespace std;

void another_function(int arg1)
{
  spdlog::trace("In another_function {}", arg1);
  spdlog::debug("In another_function {}", arg1);
  spdlog::info("In another_function {}", arg1);
  spdlog::warn("In another_function {}", arg1);
  spdlog::error("In another_function {}", arg1);
  spdlog::critical("In another_function {}", arg1);
}
int main()
{
  spdlog::info("Welcome to spdlog!");
  spdlog::error("Some error message with arg: {}", 1);

  spdlog::warn("Easy padding in numbers like {:08d}", 12);
  spdlog::critical("Support for int: {0:d};  hex: {0:x};  oct: {0:o}; bin: {0:b}", 42);
  spdlog::info("Support for floats {:03.2f}", 1.23456);
  spdlog::info("Positional args are {1} {0}..", "too", "supported");
  spdlog::info("{:<30}", "left aligned");

  spdlog::set_level(spdlog::level::debug); // Set global log level to debug
  spdlog::debug("This message should be displayed..");
  spdlog::trace("main trace, SHOULD NOT BE DISPLAYED");
  spdlog::debug("main debug");

  spdlog::set_level(spdlog::level::trace); // Set global log level to trace
  another_function(4);
}

