//
//	Matlab.h - matlab matrix storage format version 1.0
//

//
//	Fixed length 20 byte header object
//
class MatHeader {

	long	type;
	long	nRows;
	long	nCols;
	long	flgImag;
	long	lenName;

public:
	MatHeader();
    void Display();
};

class MatVariable : MatHeader {
	char	*Name;
	double	*Real;
	double	*Imag;

public:
	void Display();
	
};

		