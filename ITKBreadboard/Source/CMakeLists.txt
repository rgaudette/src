project(ITKBreadboard)

cmake_minimum_required(VERSION 2.6)

find_package(ITK)
if(ITK_FOUND)
  include(${ITK_USE_FILE})
else(ITK_FOUND)
  message(FATAL_ERROR "ITK not found. Please set ITK_DIR.")
endif(ITK_FOUND)

set(Boost_ADDITIONAL_VERSIONS "1.38")
set(BOOST_LIBRARYDIR "H:/Libraries/x86/boost-1_38/lib")

find_package(Boost
   REQUIRED
   COMPONENTS
#     date_time
#     filesystem
#     iostreams
#     prg_exec_monitor
#     program_options
#     python
#     regex
#     serialization
#     signals
# #    test_exec_monitor
#     thread
     unit_test_framework
#     wserialization
 )

if (NOT Boost_FOUND)
  message(FATAL_ERROR "Boost not found")
endif (NOT Boost_FOUND)

# message("Boost_INCLUDE_DIRS: ${Boost_INCLUDE_DIRS}")
message("Boost_LIBRARY_DIRS: ${Boost_LIBRARY_DIRS}")
message("Boost_LIBRARIES: ${Boost_LIBRARIES}")
# message("Boost_VERSION: ${Boost_VERSION}")
# message("Boost_LIB_VERSION: ${Boost_LIB_VERSION}")

# Add include directories needed to use Boost.
include_directories(before ${Boost_INCLUDE_DIRS})

# Add link directories needed to use Boost.
link_directories(${Boost_LIBRARY_DIRS})

set(SRCS ITKBreadboard.cpp FilterModel.cpp)
add_executable(ITKBreadboard ${SRCS})
target_link_libraries(ITKBreadboard ITKCommon)

set(FILTERMODEL_TEST_SRC FilterModel_Test.cpp)
add_executable(FilterModel_Test ${FILTERMODEL_TEST_SRC})
target_link_libraries(FilterModel_Test ${Boost_LIBRARIES})
