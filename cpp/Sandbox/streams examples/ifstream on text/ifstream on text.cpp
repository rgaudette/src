// ifstream on text.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"

#include <iostream>
#include <fstream>
#include <string>
#include <Windows.h>

using namespace std;

int main(int argc, char * argv[])
{
	char current_directory[1024];
	GetCurrentDirectoryA(1024, current_directory);
	cout << current_directory << endl;

	ifstream file(argv[1]);
	cout << argv[1] << endl;
	string word;
	file >> word;
	cout << word << endl;
	for (string word; file >> word;)
	{
		cout << word << endl;
	}
	return 0;
}

