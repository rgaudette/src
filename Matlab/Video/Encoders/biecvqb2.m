%BIECVQB2       Bi-Orthogonal ECVQ using the "second" bit-allocation strategy.
%
%   [rec_img, comp, Indices, nIndices, idxCB] = biecvqb2(image, N, b,
%               algCBMap, flgTime)
%
%   rec_img     The reconstructed image.
%
%   comp        The compression ratio for the image.
%
%   Indices     A matrix containing the codeword vector indices used for
%               each subband.
%
%   nIndices    The number of indices generated for each subband.  Since
%               the number of indices used for each subband is possibly
%               different this vector is necessary to read Indices.
%
%   idxCB       The codebook index used for each subband.
%
%   image       The image to be compressed.
%
%   N           The number of wavelet decompositions to be performed.
%
%   b           The requested average bit rate used to code the image.
%
%   algCBMap    The matlab function that identifies the rates, files and
%               lambda values for the EC codebooks.
%
%   flgTime     [OPTIONAL] Selects algorithm execution to be reported. 1 causes
%               the execution time for the whole algorithm to be reported, 2
%               displays various subsections of the algorithm.
%
%       BIECVQB2 computes an N level bi-orthogonal wavelet decomposition of
%   the given image.  Each subband is then vector quantized with bit
%   allocation for each subband being proportional to the subband variance.
%   The vector quantization technique is Entropy Constrained Vector
%   Quantization[1].  The quantized image as well as the compression rate are
%   returned.
%
%       This algorithm was derived from BIVQBA2 which in turn was derived from
%   Dave's bi_vq_bit_alloc2.
%   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% For this implementation, the original image is N step
% biorthogonal wavelet decomposed. The high subbands LH1, 
% HL1, and HH1 are zeroed, and the bit allocation strategy is
% performed on only the remaining subbands. The coefficients
% are then VQ'd according to the codebook which best matches 
% the allocated bit rate.
%
% author: David Hoag
%
% input: image ==> input image
%            N ==> # of decompositions past the 2 step
%            b ==> average bit rate
%
% output: rec_img ==> reconstructed output image
%
% modifications:
%   rjg     95/07/17
%   - returns code book and quantizer output indices
%   - calls fsvq (for speed improvement)
%   - second decomposition moved into loop
%   - simplified bit assignment function in quantization, geometric mean
%        computation, bit rate allocation computation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [rec_img, comp, Indices, nIndices, idxCB] = ...
        bi_vq_bit_alloc2(image, N, b, algCBMap, flgTime);

if nargin < 5,
    flgTime = 0;
end

AlgStart = clock;
%%
%%  Initializations
%%
TotalBits = 0;
SubbandVar = zeros(1, (N+1)*3 + 1);
SubbandElem = zeros(1, (N+1)*3 + 1);
BandCRate = zeros(1, (N+1)*3 + 1);
var = zeros(1,4);

%%
%%  Initialize bit assignment vector (first level decompostion subbands)
%%  are zeroed.
%%
bit_assign = [0 0 0];
rate = b;

%%
%%  Perform first level decomposition, tossing out all but LL subband
%%
if flgTime > 1,
    disp('    First image decomposition...'); st = clock;
end

dim1 = size(image);
img_dec1 = bi_decn(image,1);
nYhalf = dim1(1) / 2;
nXhalf = dim1(2) / 2;
LL = img_dec1(1:nYhalf,1:nXhalf);
dim = size(LL);
ysize = dim1(1);
xsize = dim1(2);

HH = img_dec1((nYhalf+1):ysize,(nXhalf+1):xsize);
var(1) = (stdev(HH))^2;
SubbandVar(1) = var(1);

HL = img_dec1((nYhalf +1):ysize,1:(nXhalf));
var(2) = (stdev(HL))^2;
SubbandVar(2) = var(2);

LH = img_dec1(1:nYhalf,(nXhalf +1):xsize);
var(3) = (stdev(LH))^2;
SubbandVar(3) = var(3);

LL = img_dec1(1:nYhalf,1:nXhalf);
var(4) = (stdev(LL))^2;

if flgTime > 1,
    et = etime(clock, st); disp(['    Elapsed time : ' num2str(et)]);
end

% Each pass assigns bits to the partitioned LL subband 
for i=1:N
    if flgTime > 1,
        disp(['    Pass #' int2str(i)]); st = clock;
    end

    sub_img = bi_decn(LL,1);
    [ysize xsize]  = size(sub_img);

    % Compute variances of the coefficients contained in each
    % subband
    nYhalf = ysize / 2;
    nXhalf = xsize / 2;
    HH = sub_img((nYhalf+1):ysize,(nXhalf+1):xsize);
    var(1) = (stdev(HH))^2;

    HL = sub_img((nYhalf +1):ysize,1:(nXhalf));
    var(2) = (stdev(HL))^2;

    LH = sub_img(1:nYhalf,(nXhalf +1):xsize);
    var(3) = (stdev(LH))^2;

    LL = sub_img(1:nYhalf,1:nXhalf);
    var(4) = (stdev(LL))^2;

    dwt_img(1:ysize,1:xsize) = sub_img;

    % Compute geometric mean of the variances.
    geom_mean = sqrt(sqrt(var(1)*var(2)*var(3)*var(4)));

    % Allocate bits to each subband
    r = b + 0.5 * log2(var ./ geom_mean);

    % r(4) becomes average bit rate for next pass 
    b = r(4);

    % Generate bit assignment vector  e.g. [HH1 HL1 LH1 HH2 HL2 LH2 LL2]
    bit_assign = [bit_assign r(1:3)]; 

    if flgTime > 1,
        et = etime(clock, st); disp(['    Elapsed time : ' num2str(et)]);
    end
end

%%
%%  Add final bit rate for LL(N) subband
%%
bit_assign = [bit_assign b];

%%
%%  Reverse order of bit assignment vector
%%  e.g. [LL2 LH2 HL2 HH2 LH1 HL1 HH1]
%%
bit_assign = bit_assign([length(bit_assign):-1:1]);

%%
%%  Compute actual average bit rate
%%
b = mean(bit_assign(1:4));
for i=1:N
    b = mean([b bit_assign((5+(i-1)*3):(7+(i-1)*3))]);
end 

%%
%%  Echo average bit rate and bit assignment
b
bit_assign
comp = 8/b

% Set bit assignment of LL to 8
%bit_assign(1)=8;

% Generate x_pos and y_pos vectors which represent the spatial
% location of the various subbands  
[LL_y_pos, LL_x_pos] = size(LL);
y_pos = [1 LL_y_pos];
x_pos = [1 LL_x_pos];

% Reset xsize and ysize to dimension of original image
ysize = dim(1);
xsize = dim(2);
   
for i=N:-1:1
    y_pos = [y_pos 1 ysize/(2^i) (ysize/(2^i) + 1) ysize/(2^(i-1))];
    y_pos = [y_pos (ysize/(2^i) + 1) ysize/(2^(i-1))];
    x_pos = [x_pos (xsize/(2^i) + 1) xsize/(2^(i-1)) 1 xsize/(2^i)];
    x_pos = [x_pos (xsize/(2^i) + 1) xsize/(2^(i-1))];
end;

%%
%%  Generate rates and names of codebook files
%%
[cdbk_rate cdbks Lambda] = feval(algCBMap);

%%
%%  Generate intervals for codebook rates
%%
nRates = length(cdbk_rate);
interval = 0.5 * (cdbk_rate(1:nRates-1).' + cdbk_rate(2:nRates).');
interval = [cdbk_rate(1)/2 interval (cdbk_rate(nRates)+8.0)/2];
nInterval = length(interval);

%%
%%  Create matrix of indices, the maximum possible number of indices we
%%  can have is the number of elements in the largest subband.
%%
if nargout > 2,
    Indices = zeros(dim(1)/2 * dim(2)/2, length(bit_assign-3));
    nIndices = zeros(1, length(bit_assign-3));
    idxCB = zeros(1, length(bit_assign-3));
end

if flgTime > 1,
    disp('    Quantizing decomposition coefficients...'); st = clock;
end

%%
%%  Quantize each subband using bit-allocation strategy define above
%%
for k = 1:(length(bit_assign)-3)

    %%
    %%    Compute bit assignment for current subband
    %%
    idxRate = find( (bit_assign(k) >= interval(1:nInterval-1)) & ...
                    (bit_assign(k) <  interval(2:nInterval)) );
    if idxRate == [],
        if bit_assign(k) < interval(1),
            bit_assign(k) = 0;
        else
	        if k > 1,
		        idxRate = nRates;
                eval(['load ' cdbks(idxRate,:)]);
                bit_assign(k) = cdbk_rate(idxRate);
            else
                bit_assign(k) = 8.0;
            end
        end
    else
        eval(['load ' cdbks(idxRate,:)]);
        bit_assign(k) = cdbk_rate(idxRate);
    end

    %%
    %%  Extract the current subband for quantization
    %%
    subim = dwt_img(y_pos(2*k-1):y_pos(2*k),x_pos(2*k-1):x_pos(2*k));

    if ((bit_assign(k)>0) & (bit_assign(k)<8)) 
        %%
        %%   Normalize the coefficients, computing the mean and
	    %%   standard deviation.
        %%
        [norm_sub_img mean_sub_img stdev_sub_img] = normalize(subim);

        %%
        %%  Vector quantize the coefficients
        %%  note that the codebooks are KxM 
        %%
        [vect_dim codebook_size] = size(VQ);
        [ydim xdim] = size(subim);

	    % Create 1-D vector from 2-D subband data (row-wise ordering)
        subim_vect=norm_sub_img';
        subim_vect=subim_vect(:)';

        % Append zeros to subim_vect to make length(subim_vect)mod(vect_dim)=0
        mod_k = mod(length(subim_vect), vect_dim);
        if mod_k ~= 0,
            subim_vect = [subim_vect zeros(1,vect_dim - mod_k)];
        end
 
        %%
        %%  Quantize the vectors from the current subband
        %%   - fsvq expects the codebooks to be KxM where K is the
        %%     dimension of the vector & M is the number of codewords.
        %%   - The codebooks stored in the files are transposed
        %%
        nVects = length(subim_vect) / vect_dim;
%        idxCW = fsvq(reshape(subim_vect, vect_dim, nVects), VQ);
        idxCW = ecnnsrch(reshape(subim_vect, vect_dim, nVects), VQ, ...
            Entropy, Lambda(idxRate));

    	%%
        %%  Add the actual number of bits used to encode the subband
    	%%  to the running count of bits for the image.
        %%
        Bits = sum(Entropy(idxCW));
        BandCRate(k) = Bits / (ydim * xdim);
    	TotalBits = TotalBits + Bits;

        %%
        %%  Copy indices into index matrix
        %%
        if nargout > 2,
            nIndices(k) = length(idxCW);
            Indices(1:nIndices(k), k) = idxCW.';
            idxCB(k) = idxRate;
        end
        
        %%
        %%  Generate codewords from vector indices
        %%
        subim_vect = VQ(:, idxCW);
        subim_vect = subim_vect(:).';

        % Reshape quantized coefficients from 1-D to 2-D data
        norm_sub_img = subim_vect(1:(xdim*ydim));
        norm_sub_img = reshape(norm_sub_img, xdim, ydim)';

        % Unnormalize quantized coefficients
        unnorm_quant_sub_img = (norm_sub_img*stdev_sub_img) + mean_sub_img;
    
        % Construct quantized dwt image
        quant_dwt_img(y_pos(2*k-1):y_pos(2*k),x_pos(2*k-1):x_pos(2*k)) = ...
	unnorm_quant_sub_img;  
    end
    
    %%
    %%  No relevant information in this subband, zero it out
    %%
    if (bit_assign(k)==0)
        [sub_ysize,sub_xsize]=size(subim);
        quant_dwt_img(y_pos(2*k-1):y_pos(2*k),x_pos(2*k-1):x_pos(2*k)) = ...
            zeros(sub_ysize,sub_xsize);
        BandCRate(k) = 0.0;
    end

    %%
    %%  Full 8 bit scalar quantization of coefficients
    %%
    if (bit_assign(k)==8)
        quant_dwt_img(y_pos(2*k-1):y_pos(2*k),x_pos(2*k-1):x_pos(2*k)) = ...
	    round(subim);
        if nargout > 2,
            nIndices(k) = length(subim(:));
            Indices(1:nIndices(k), k) = round(subim(:));
        end
        BandCRate(k) = 8;
    end

end
if flgTime > 1,
    et = etime(clock, st); disp(['    Elapsed time : ' num2str(et)]);
end

%%
%%  Compute expected average bit rate
%%
bit_assign
BandCRate
b = mean(bit_assign(1:4));

for i=1:N
    b = mean([b bit_assign((5+(i-1)*3):(7+(i-1)*3))]);
end

%%
%% Echo expected average bit rate
%%
disp('Expected average bit rate');
b

%%
%%  Compute the true average bit rate (bits/pixel)
%%
b = TotalBits / (dim1(1) * dim1(2));
comp = 8 / b;

%%
%%  Echo actual average bit rate
%%
disp('Actual average bit rate');
b
comp

% Reconstruct image, pad quant_dwt_img with zeros in high subbands
if flgTime > 1,
    disp('    Reconstruct image...'); st = clock;
end

quant_dwt_img(ysize+1:2*ysize,1:xsize)=zeros(ysize,xsize);
quant_dwt_img(1:2*ysize,xsize+1:2*xsize)=zeros(2*ysize,xsize); 
rec_img = birecnn(quant_dwt_img,N+1);

if flgTime > 1,
    et = etime(clock, st); disp(['    Elapsed time : ' num2str(et)]);
end

if flgTime > 0,
    et = etime(clock, AlgStart); disp(['  BIECVQB2 total Elapsed time : ' num2str(et)]);
end
