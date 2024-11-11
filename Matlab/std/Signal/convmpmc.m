%CONVMPMC       Multiple pulse, multiple channel convolution routine.
%
%    y = convmpmc(x, h, nPulses, flgChopTrans)
%
%    y              The processed data matrix.
%
%    x              The input data matrix.  Each column of this matrix is a
%                   seperate channel.  Down each column are the time samples
%                   for the first pulse followed by any the time samples for
%                   succesive pulses.
%
%    h              The filter to convolve x with.  This may either be a
%                   single filter or a seperate for each channel of x.  It's
%                   format is the same as x.
%
%    nPulses        The number of pulses present in each column.
%
%    flgChopTrans   OPTIONAL: Remove the transient portion of the output
%                   signal if non-zero (default: 0).
%
%    
%    Calls: none.
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:19 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: convmpmc.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:19  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 19:10:21  rjg
%  Initial revision
%
%  
%     Rev 1.4   22 Mar 1994 09:30:40   rjg
%  Modified help description.
%   
%  
%     Rev 1.3   02 Feb 1994 09:34:08   rjg
%  Enhanced error detection of output signal length for chopped transient output.
%  If steady state output not available the input sequence length is printed and
%  an error is generated.
%  
%     Rev 1.2   18 Jan 1994 13:31:22   rjg
%  Fixed help section.
%  
%     Rev 1.1   06 Jan 1994 17:07:46   rjg
%  Added option to chop transient portion of signal off.
%  
%     Rev 1.0   06 Jan 1994 15:50:10   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = convmpmc(x, h, nPulses, flgChopTrans)

%%
%%    Default values
%%
if nargin < 4,
    flgChopTrans = 0;
end

%%
%%    Get sizes for signal and filter.
%%
[nXSaTot nXChan] = size(x);
nXTimeSa = nXSaTot / nPulses;
[nHSa nHChan] = size(h);

%%
%%    Check to see if either x or h is complex, if not take real part of
%%    output at the end.
%%
flgComplex = 0;
if any(imag(x)) | any(imag(h)),
    flgComplex = 1;
end

%%
%%    Compute the size of the FFT necessary to convolve the sequences.
%%
nYSa = nXTimeSa + nHSa - 1;
nFFT = pow2(ceil(log2(nYSa)));

%%
%%    Transform h to freq domain and duplicate for each pulse and for each
%%    channel present in x if only a single filter was supplied.
%%
h = fft(h, nFFT);

if nHChan == 1 & nXChan > 1,
    h = h * ones(1, nXChan);
end

H = zeros(nFFT * nPulses, nXChan);
for idxPulse = 0:nPulses-1
    H(idxPulse*nFFT+1:(idxPulse+1)*nFFT,:) = h;
end

%%
%%    reshape the pulse data and freq domain filter data s.t. each pulse
%%    is in it's own column.
%%
H = reshape(H, nFFT, nPulses * nXChan);
x = reshape(x, nXTimeSa, nPulses * nXChan);
x = fft(x, nFFT);

%%
%%    Convovle the two sets of signals
%%
Y = H .* x;

Y = ifft(Y);

%%
%%    Reshape ouput back to input format and chop transients if necessary
%%
if flgChopTrans,
    nYSa = nXTimeSa - nHSa + 1;
    if(nYSa <= 0)
        fprintf('X number of samples: %d\n', nXTimeSa);
	fprintf('H number of samples: %d\n', nHSa);
        error('No steady state output signal avialable, X signal to short.');
    end
    y = reshape(Y(nHSa:nXTimeSa,:), nYSa * nPulses, nXChan);
else
    y = reshape(Y(1:nYSa,:), nYSa * nPulses, nXChan);
end

%%
%%    Take real part of signal if both inputs were real.
%%
if ~flgComplex,
    y = real(y);
end

return
