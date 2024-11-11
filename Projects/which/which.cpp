#include <iostream.h>
#include <stdlib.h>

void main(int argc, char *argv[]) {

	char *pstrPath;

	if (argc < 2) {
		cerr << "No command to search for.\n";
		exit(-1);
	}

	//
	//  Get the current path from the environment
	//
	pstrPath = getenv("PATH");
	if(pstrPath == NULL) {
		cerr << "Unable to find PATH environment variable.\n";
		exit(-1);
	}
	cout << "Searching the path:\n" << pstrPath << "\n";
	
	//
	//	Walk the search path to if command or command.EXE is present
	//

}
