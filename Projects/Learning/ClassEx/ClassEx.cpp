#include <iostream.h>

//
//  A simple parent class
//
class parent {
public:
	int diff();
	int a,b,c;
	int sum() { return (a + b + c);}
};


//
//  A simple child class derived from parent
//
class child : public parent {
public:
	int d,e,f;
	int diff() {return (a-d);}
};

void main(int argc, char *argv[]){

	child TheChild;

	TheChild.a = 1;
	TheChild.b = 2;
	TheChild.c = 3;
	TheChild.d = 4;

	TheChild.e = TheChild.sum();
	TheChild.f = TheChild.diff();

	cout << "a: " << TheChild.a << '\n';
	cout << "b: " << TheChild.b << '\n';
	cout << "c: " << TheChild.c << '\n';
	cout << "d: " << TheChild.d << '\n';
	cout << "e: " << TheChild.e << '\n';
	cout << "f: " << TheChild.f << '\n';
}

int parent::diff()
{
return a-b;
}
