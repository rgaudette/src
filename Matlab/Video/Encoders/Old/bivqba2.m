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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [rec_img, comp] = bi_vq_bit_alloc2(image,N,b);

% Initialize bit_assign, top subbands are zeroed  
bit_assign = [0 0 0];
rate = b;

disp('    First image decomposition...')
st = clock;
img_dec1 = bi_decn(image,1);
et = etime(clock, st);
disp(['    Elapsed time : ' num2str(et)]);


dim1 = size(image);
img_dec1 = img_dec1(1:dim1(1)/2,1:dim1(2)/2);

disp('    Second image decomposition...')
st = clock;
img_dec2 = bi_decn(img_dec1,1);
et = etime(clock, st);
disp(['    Elapsed time : ' num2str(et)]);

dim = size(img_dec2);
ysize = dim(1);
xsize = dim(2);

sub_img = img_dec2;

% Each pass assigns bits to the partitioned LL subband 
for i=1:N  
    disp(['    Pass #' int2str(i)])
    st = clock;

    if (i > 1)
       sub_img = bi_decn(LL,1);
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

    et = etime(clock, st);
    disp(['    Elapsed time : ' num2str(et)]);

end;

bit_assign = [bit_assign b];

% Reverse order of bit assignment vector
% e.g. [LL2 LH2 HL2 HH2 LH1 HL1 HH1]
for i=1:length(bit_assign)
    dum(i) = bit_assign(length(bit_assign)-i+1);
end;
bit_assign = dum;

% junk
% bit_assign = [8 8 8 4.5 4.5 4.5 4 2.25 1.75 1.25 .66 .66 .66 0 0 0] 

% Compute actual average bit rate
b = mean(bit_assign(1:4));
for i=1:N
    b = mean([b bit_assign((5+(i-1)*3):(7+(i-1)*3))]);
end 

% Echo average bit rate and bit assignment
b
bit_assign
comp = 8/b;

% Set bit assignment of LL to 8
bit_assign(1)=8;

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

rec_vals = [];
dec_levels = [];

% Generate vector which holds the codebook rates
cdbk_rate = [
.0625
.125
.1875
.25
.3125
.375
.4375
.5
.5625
.625
.6666
.75
.875
1.0
1.125
1.25
1.5
1.75
2
2.25
2.5
3
3.5
4
4.5
5.000000
5.500000
6.000000
6.500000];

% Generate vector which holds codebook names
basepath = 'd:\data\video\codebook\';
cdbks =[
basepath 'VQ_2_16  ';
basepath 'VQ_4_16  ';
basepath 'VQ_8_16  ';
basepath 'VQ_16_16 ';
basepath 'VQ_32_16 ';
basepath 'VQ_64_16 ';
basepath 'VQ012816 ';
basepath 'VQ025616 ';
basepath 'VQ051216 ';
basepath 'VQ_32_8  ';
basepath 'VQ_4_3   ';
basepath 'VQ_64_8  ';
basepath 'VQ_128_8 ';
basepath 'VQ_256_8 ';
basepath 'VQ_512_8 ';
basepath 'VQ_32_4  ';
basepath 'VQ_64_4  ';
basepath 'VQ_128_4 ';
basepath 'VQ_256_4 ';
basepath 'VQ_512_4 ';
basepath 'VQ_32_2  ';
basepath 'VQ_64_2  ';
basepath 'VQ_128_2 ';
basepath 'VQ_256_2 ';
basepath 'VQ_512_2 ';
basepath 'VQ_1024_2';
basepath 'VQ_2048_2';
basepath 'VQ_4096_2';
basepath 'VQ_8192_2'];

interval=[]; 
for l=1:(length(cdbk_rate)-1)
    interval(l) = .5*(cdbk_rate(l)+cdbk_rate(l+1));
end;

interval = [.03125 interval 7.25];

disp('    Quantize decomposition coefficients...')
st = clock;

% Quantize wavelet coefficients according to bit allocation and
% Laplacian model  
for k=1:(length(bit_assign)-3)
    if bit_assign(k)<.03125
       bit_assign(k)=0;
    elseif ((bit_assign(k)>=.03125) & (bit_assign(k)<7.25))
       for z=1:length(interval)-1
           if ((bit_assign(k)>=interval(z)) & (bit_assign(k)<interval(z+1)))
              eval(['load ',cdbks(z,:)]);
              bit_assign(k) = cdbk_rate(z);
           end;
       end;
    elseif bit_assign(k)>=7.25 
       bit_assign(k)=8; 
    end;
    bit_assign(k)

    subim = dwt_img(y_pos(2*k-1):y_pos(2*k),x_pos(2*k-1):x_pos(2*k));

    if ((bit_assign(k)>0) & (bit_assign(k)<8)) 
 
       % Normalize the coefficients  
       norm_sub_img = normalize(subim);
       mean_sub_img = mean(mean(subim));
       stdev_sub_img = stdev(subim);

       % Vector quantize the coefficients
       VQ_dimension = size(VQ);
       cdbk_size = VQ_dimension(1);
       vect_dim = VQ_dimension(2);
       subim_dim = size(subim);
       ydim = subim_dim(1);  
       xdim = subim_dim(2);  

	% Create 1-D vector from 2-D subband data (row-wise ordering)
        subim_vect=norm_sub_img';
        subim_vect=subim_vect(:);

        % Append zeros to subim_vect to make length(subim_vect)mod(vect_dim)=0
        mod_k = mod(length(subim_vect), vect_dim);
        subim_vect = [subim_vect' zeros(1,mod_k)];
     
        % Quantize the coefficients
        for a=1:(length(subim_vect)/vect_dim) 
            vect_coef = subim_vect((vect_dim*(a-1)+1):(vect_dim*a));
            cdwd_matrix = ones(cdbk_size,1)*vect_coef;
            dist = sum(((cdwd_matrix-VQ).^2)');
            index = find(dist==min(dist));
            subim_vect((vect_dim*(a-1)+1):(vect_dim*a))=VQ(index(1),:);
        end;

        % Reshape quantized coefficients from 1-D to 2-D data
        norm_sub_img = subim_vect(1:(xdim*ydim));
        norm_sub_img = reshape(norm_sub_img, xdim, ydim)';

       % Unnormalize quantized coefficients
       unnorm_quant_sub_img = (norm_sub_img*stdev_sub_img) + mean_sub_img;
    
       % Construct quantized dwt image
       quant_dwt_img(y_pos(2*k-1):y_pos(2*k),x_pos(2*k-1):x_pos(2*k)) = unnorm_quant_sub_img;  
    end;
    
    if (bit_assign(k)==0)
       [sub_ysize,sub_xsize]=size(subim);   
       quant_dwt_img(y_pos(2*k-1):y_pos(2*k),x_pos(2*k-1):x_pos(2*k))=zeros(sub_ysize,sub_xsize); 
    end;

    if (bit_assign(k)==8)
       quant_dwt_img(y_pos(2*k-1):y_pos(2*k),x_pos(2*k-1):x_pos(2*k)) = round(subim);
    end;
end;
et = etime(clock, st);
disp(['    Elapsed time : ' num2str(et)]);

% Compute actual average bit rate
b = mean(bit_assign(1:4));
for i=1:N
    b = mean([b bit_assign((5+(i-1)*3):(7+(i-1)*3))]);
end
 
% Echo average bit rate and bit assignment
b;
bit_assign;
comp = 8/b;

% Reconstruct image, pad quant_dwt_img with zeros in high subbands
disp('    Reconstruct image...')
st = clock;

quant_dwt_img(ysize+1:2*ysize,1:xsize)=zeros(ysize,xsize);
quant_dwt_img(1:2*ysize,xsize+1:2*xsize)=zeros(2*ysize,xsize); 
rec_img = birecnn(quant_dwt_img,N+1);

et = etime(clock, st);
disp(['    Elapsed time : ' num2str(et)]);

