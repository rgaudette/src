%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% For the 1st step in the decomposition, the sample
% variances of the wavelet coefficients for each subband 
% are computed. Bits are then allocated to
% to each subband based on the optimal bit allocation
% scheme from Vaidyanathan p.821. If N>1, then the LL
% subband is decomposed, and bits are allocated in the
% manner described above. The lowest subband is JPEG
% encoded for a further compression of 8:1. 
%
% author: David Hoag
%
% input: image ==> input image
%            N ==> # of decompositions
%            b ==> average bit rate
%
% output: rec_img ==> reconstructed output image
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function rec_img = bit_alloc_JPEG(N,b);

% Initialize bit_assign 
bit_assign = [];

% Load in 1st step decomposition of jt403
load jt403_dec1;

dim = size(img_dec1);
ysize = dim(1);
xsize = dim(2);

sub_img = img_dec1;

% Each pass assigns bits to the partitioned LL subband 
for i=1:N  
    if (i > 1)
       sub_img = decomp1(LL);
    end;

    % Compute variances of the coefficients contained in each
    % subband

    HH = sub_img((ysize/2 +1):ysize,(xsize/2 +1):xsize);
    var(1) = (stdev(HH))^2;

    HL = sub_img((ysize/2 +1):ysize,1:(xsize/2));
    var(2) = (stdev(HL))^2;

    LH = sub_img(1:(ysize/2),(xsize/2 +1):xsize);
    var(3) = (stdev(LH))^2;

    LL = sub_img(1:(ysize/2),1:(xsize/2));
    var(4) = (stdev(LL))^2;

    dwt_img(1:ysize,1:xsize) = sub_img;

    % Compute geometric mean of the variances.
    geom_mean = sqrt(sqrt(var(1)*var(2)*var(3)*var(4)));

    % Allocate bits to each subband
    for j=1:4;
        r(j) = b + .5/log10(2)*log10(var(j)/geom_mean);
    end;

    % r(4) becomes average bit rate for next pass 
    b=r(4);

    % Generate bit assignment vector  e.g. [HH1 HL1 LH1 HH2 HL2 LH2 LL2]
    bit_assign = [bit_assign r(1:3)]; 

    % Reduce image size by 2 in each dimension
    xsize = xsize/2;
    ysize = ysize/2;
end;

bit_assign = [bit_assign b];
bit_assign = round(bit_assign); 

% Reverse order of bit assignment vector
% e.g. [LL2 LH2 HL2 HH2 LH1 HL1 HH1]
for i=1:length(bit_assign)
    dum(i) = bit_assign(length(bit_assign)-i+1);
end;
bit_assign = dum;

% Insure that 0<= bits <=8
for i=2:length(bit_assign)
    if bit_assign(i) < 0 
       bit_assign(i) = 0;
    end;
    if bit_assign(i) >= 8
       bit_assign(i) = 7;
    end;
end;

% Set bit assignment of LL to 1 due 8:1 comp. from JPEG
bit_assign(1)=1;

% Compute actual average bit rate
b = mean(bit_assign(1:4));
for i=1:N-1
    b = mean([b bit_assign((5+(i-1)*3):(7+(i-1)*3))]);
end 

% Echo average bit rate, compression and bit assignment
b 
comp = 8/b
bit_assign

% Generate x_pos and y_pos vectors which represent the spatial
% location of the various subbands  
[LL_y_pos, LL_x_pos] = size(LL);
y_pos = [1 LL_y_pos];
x_pos = [1 LL_x_pos];

% JPEG encode the LL_N coefficients
dwt_img(1:LL_y_pos,1:LL_x_pos)=JPEG(dwt_img(1:LL_y_pos,1:LL_x_pos));
% INV_JPEG the coefficients
quant_dwt_img(1:LL_y_pos,1:LL_x_pos)=INV_JPEG(dwt_img(1:LL_y_pos,1:LL_x_pos));

% Reset xsize and ysize to dimension of original image
ysize = dim(1);
xsize = dim(2);
   
for i=N:-1:1
    y_pos = [y_pos 1 ysize/(2^i) (ysize/(2^i) + 1) ysize/(2^(i-1))];
    y_pos = [y_pos (ysize/(2^i) + 1) ysize/(2^(i-1))];
    x_pos = [x_pos (xsize/(2^i) + 1) xsize/(2^(i-1)) 1 xsize/(2^i)]; 
    x_pos = [x_pos (xsize/(2^i) + 1) xsize/(2^(i-1))];
end;

% Quantize wavelet coefficients according to bit allocation and
% Laplacian model  
for j=2:length(bit_assign)
    if (bit_assign(j)==1)
       Laplacian2;
    elseif (bit_assign(j)==2)
       Laplacian3;
    elseif (bit_assign(j)==3)
       Laplacian7;
    elseif (bit_assign(j)==4)
       Laplacian15;
    elseif (bit_assign(j)==5)
       Laplacian31;
    elseif (bit_assign(j)==6)
       Laplacian64;
    elseif (bit_assign(j)==7)
       Laplacian128;
    end;

    subim = dwt_img(y_pos(2*j-1):y_pos(2*j),x_pos(2*j-1):x_pos(2*j));

    if ((bit_assign(j)>0) & (bit_assign(j)<8)) 
 
       % Normalize the coefficients  
       norm_sub_img = normalize(subim);
       mean_sub_img = mean(mean(subim));
       stdev_sub_img = stdev(subim);

       % Call quantization function  
       quant_sub_img = quantization(norm_sub_img,dec_levels,rec_vals);

       % Unnormalize quantized coefficients
       unnorm_quant_sub_img = (quant_sub_img*stdev_sub_img) + mean_sub_img;
    
       % Construct quantized dwt image
       quant_dwt_img(y_pos(2*j-1):y_pos(2*j),x_pos(2*j-1):x_pos(2*j)) = unnorm_quant_sub_img;  
    end;
    
    if (bit_assign(j)==0)
       [sub_ysize,sub_xsize]=size(subim);   
       quant_dwt_img(y_pos(2*j-1):y_pos(2*j),x_pos(2*j-1):x_pos(2*j))=zeros(sub_ysize,sub_xsize); 
    end;

    % Round any subband with 8 bits/coefficient
    if (bit_assign(j)==8)
       quant_dwt_img(y_pos(2*j-1):y_pos(2*j),x_pos(2*j-1):x_pos(2*j)) = round(subim);
    end;
end;

% Reconstruct image
rec_img = reconstN(quant_dwt_img,N);
