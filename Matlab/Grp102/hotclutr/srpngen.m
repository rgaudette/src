%SRPNGEN	Gererate a shift register psuedo-random noise sequence.
%
%    Seq = srpngen(Samples, SRLength, Seed, Tap, flgXNOR)
%
%    Seq	Samples x 1 vector containing the psuedo-random sequence.
%
%    Samples    The number of samples to generate.
%
%    SRLength	The shift register length to use for generating the sequence.
%		Available lengths are :
%		  3,4,5,6,7,8,9,10,11,15,16,17,18,20,21,22,23,24,25,28,29,31,33
%
%    Seed	OPTIONAL: SRLength x 1 vector use to preload the shift
%		register, default = ones(SRLength, 1).
%
%    Tap	OPTIONAL: The tap from which to extract the sequence,
%		default = 1.
%
%    flgXNOR	OPTIONAL: Use and XNOR gate instead of a XOR gate, in this
%		case a seed of all ones will lock the sequence.
%
%	    SRPNGEN generates the requested number of samples of a maximal
%	length PN sequence.  The shift register length defines the length of
%	the sequence before it starts repeating (2^SRLength - 1).
%    
%
%    Calls: none 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:33 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: srpngen.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:33  rickg
%  Matlab Source
%
%  
%     Rev 1.0   25 Feb 1993 13:54:56   rjg
%  Initial revision.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%    This function has been tested by looking at the circular ACF for
%%    each SR length upto 16 bits.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Seq = srpngen(Samples, SRLength, Seed, Tap, flgXNOR)

%%
%%    Get optional args if available.
%%
if nargin < 5,
    flgXNOR = 0;
    if nargin < 4,
	Tap = 1;
	if nargin < 3,
	    Seed = ones(SRLength,1);
	else
	    if length(Seed) ~= SRLength,
		error('Seed vector length is not equal to the number of taps');
	    end
	end
    end
end

%%
%%    Error checking.
%%
if ~any(SRLength == ...
    [3 4 5 6 7 8 9 10 11 15 16 17 18 20 21 22 23 24 25 28 29 31 33]),
    error(['Shift register length of ' int2str(SRLength) ' is unsupproted']);
end

if Tap > SRLength,
    fprintf('Tap: %2.0f\tShift register: %2.0f\n', Tap, SRLength);
    error('Tap number is greater than shift register length');
end

%%
%%    Create a table of taps for the available SR lengths, each row represents
%%    a different SR length.
TapTable = zeros(33);
TapTable(3,2) = 1; TapTable(3,3) = 1;
TapTable(4,3) = 1; TapTable(4,4) = 1;
TapTable(5,3) = 1; TapTable(5,5) = 1;
TapTable(6,5) = 1; TapTable(6,6) = 1;
TapTable(7,6) = 1; TapTable(7,7) = 1;
TapTable(8,4) = 1; TapTable(8,5) = 1;
    TapTable(8,6) = 1; TapTable(8,8) = 1; 
TapTable(9,5) = 1; TapTable(9,9) = 1;
TapTable(10,7) = 1; TapTable(10,10) = 1;
TapTable(11,9) = 1; TapTable(11,11) = 1;
TapTable(15,14) = 1; TapTable(15,15) = 1;
TapTable(16,4) = 1; TapTable(16,13) = 1;
    TapTable(16,15) = 1; TapTable(16,16) = 1;
TapTable(17,14) = 1; TapTable(17,17) = 1;
TapTable(18,11) = 1; TapTable(18,18) = 1;
TapTable(20,17) = 1; TapTable(20,20) = 1;
TapTable(21,19) = 1; TapTable(21,21) = 1;
TapTable(22,21) = 1; TapTable(22,22) = 1;
TapTable(23,18) = 1; TapTable(23,23) = 1;
TapTable(24,17) = 1; TapTable(24,22) = 1;
    TapTable(24,23) = 1; TapTable(24,24) = 1;
TapTable(25,22) = 1; TapTable(25,25) = 1;
TapTable(28,25) = 1; TapTable(28,28) = 1;
TapTable(29,27) = 1; TapTable(29,29) = 1;
TapTable(31,28) = 1; TapTable(31,31) = 1;
TapTable(33,20) = 1; TapTable(33,33) = 1;

%%
%%    Initialize SR circuit.
%%
TapVector = TapTable(SRLength,1:SRLength)';
ShiftRegister = Seed(:);
Seq = zeros(Samples,1);
ShiftFrom = 1:SRLength-1;
ShiftTo = 2:SRLength;

%%
%%    Clock shift register.
%%
for clk = 1:Samples,
    ShiftInput = (rem(sum(ShiftRegister & TapVector), 2) == ~flgXNOR); 
    ShiftRegister(ShiftTo) = ShiftRegister(ShiftFrom);
    ShiftRegister(1) = ShiftInput;
    Seq(clk) = ShiftRegister(Tap);
end
