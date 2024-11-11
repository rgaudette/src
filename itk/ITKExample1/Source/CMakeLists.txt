project(ITKExample1)

cmake_minimum_required(VERSION 2.6)

find_package(ITK)
if(ITK_FOUND)
  include(${ITK_USE_FILE})
else(ITK_FOUND)
  message(FATAL_ERROR "ITK not found. Please set ITK_DIR.")
endif(ITK_FOUND)

set(Boost_ADDITIONAL_VERSIONS "1.38")

# find_package(Boost COMPONENTS filesystem)

# if(NOT Boost_FOUND)
#   message(FATAL_ERROR "Could not find Boost. Set BOOST_ROOT to the parent of the include and libs dirs")
# endif(NOT Boost_FOUND)
# message(STATUS ${Boost_INCLUDE_DIR})
# set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR})

find_package(Boost
  REQUIRED
  COMPONENTS
    date_time
    filesystem
    iostreams
    prg_exec_monitor
    program_options
    python
    regex
    serialization
    signals
#    test_exec_monitor
    thread
    unit_test_framework
    wserialization
)

if (NOT Boost_FOUND)
  message(FATAL_ERROR "Boost not found")
endif (NOT Boost_FOUND)

message("Boost_INCLUDE_DIRS: ${Boost_INCLUDE_DIRS}")
message("Boost_LIBRARY_DIRS: ${Boost_LIBRARY_DIRS}")
message("Boost_LIBRARIES: ${Boost_LIBRARIES}")
message("Boost_VERSION: ${Boost_VERSION}")
message("Boost_LIB_VERSION: ${Boost_LIB_VERSION}")

# Add include directories needed to use ITK.
INCLUDE_DIRECTORIES(BEFORE ${Boost_INCLUDE_DIRS})

# Add link directories needed to use ITK.
LINK_DIRECTORIES(${Boost_LIBRARY_DIRS})

set(SRCS ITKExample.cpp)

add_executable(ITKExample ${SRCS})

target_link_libraries(ITKExample ITKCommon ITKIO ITKTiff)

