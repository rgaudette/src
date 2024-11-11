#define BOOST_TEST_MAIN
#include <boost/test/unit_test.hpp>
#include "FilterModel.h"
// most frequently you implement test cases as a free functions with automatic registration
BOOST_AUTO_TEST_CASE( FilterModel_get_node_id)
{
    FilterModel filter_model;
	int node_id = 3;
	filter_model.set_node_id(node_id);
	BOOST_CHECK( filter_model.get_node_id() == node_id );
}

