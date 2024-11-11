
#include <string>
#include <vector>

class FilterModel {

public:
	// Default constructor
	FilterModel();

	void set_node_id(int id) {node_id = id; }
	int get_node_id() {return node_id; }

private:
	std::string name;
	int node_id;
	std::vector<int> input_nodes;

	// Hide the default copy constructor and assignment operator
	FilterModel & operator= (const FilterModel &){};

};