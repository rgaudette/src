%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% For this implementation, the original image is 2 step
% decomposed. The high subbands LH1, HL1, and HH1
% are zeroed, and the bit allocation strategy is
% performed on only the remaining subbands. 
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

function [rec_img, comp] = bit_alloc2(img,N,b);

% Initialize bit_assign, top subbands are zeroed  
bit_assign = [0 0 0];
rate = b;

[ysize, xsize] = size(img);

ysize = ysize/2;
xsize = xsize/2;

sub_img = decompN(img,2);;

sub_img = sub_img(1:ysize,1:xsize);

% Each pass assigns bits to the partitioned LL subband 
for i=1:N  
    if (i > 1)
       sub_img = decompN(LL,1);
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

% Reverse order of bit assignment vector
% e.g. [LL2 LH2 HL2 HH2 LH1 HL1 HH1]
for i=1:length(bit_assign)
    dum(i) = bit_assign(length(bit_assign)-i+1);
end;
bit_assign = dum;

% Compute actual average bit rate
b = mean(bit_assign(1:4));
for i=1:N
    b = mean([b bit_assign((5+(i-1)*3):(7+(i-1)*3))]);
end 

% Create file for storing data
fid = fopen('bit_alloc2_2.dat','a');
fprintf(fid,'\n--------------------------------------------------------------------\n');
fprintf(fid,'# of decompositions: %d\n',(N+1));
fprintf(fid,'Desired bit rate: %1.4f\n\n',rate);
fprintf(fid,'Bit assignment after rate allocation applied:\n');

% Echo average bit rate and bit assignment
b
bit_assign
comp = 8/b

for i=1:length(bit_assign)
    fprintf(fid,'%1.4f ',bit_assign(i));
end;

fprintf(fid,'\n\nAverage bit rate: %1.4f\n',b);
fprintf(fid,'Compression ratio: %3.4f:1\n',(8/b));

bit_assign(1)=8;

% Generate x_pos and y_pos vectors which represent the spatial
% location of the various subbands  
[LL_y_pos, LL_x_pos] = size(LL);
y_pos = [1 LL_y_pos];
x_pos = [1 LL_x_pos];

% Reset xsize and ysize to dimension of original image
[ysize,xsize] = size(img);
ysize = ysize/2;
xsize = xsize/2;
   
for i=N:-1:1
    y_pos = [y_pos 1 ysize/(2^i) (ysize/(2^i) + 1) ysize/(2^(i-1))];
    y_pos = [y_pos (ysize/(2^i) + 1) ysize/(2^(i-1))];
    x_pos = [x_pos (xsize/(2^i) + 1) xsize/(2^(i-1)) 1 xsize/(2^i)];
    x_pos = [x_pos (xsize/(2^i) + 1) xsize/(2^(i-1))];
end;

rec_vals = [];
dec_levels = [];

% Generate an array of #'s from log2(2:36) then find midpoints
% between the array elements. This defines the bit rates which
% correspond to the Laplacian tables reconstruction levels ranging
% from 2 to 36.
i=2:36;
i = [i 64 128 256];
lg2 = log2(i);

for j=1:length(i)-1
    interval(j) = .5*(lg2(j)+lg2(j+1));
end;

% Quantize wavelet coefficients according to bit allocation and
% Laplacian model  
for k=1:(length(bit_assign)-3)
    if bit_assign(k)<.5
       bit_assign(k)=0;
    elseif ((bit_assign(k)>=.5) & (bit_assign(k)<interval(1)))
       Laplacian2;
       bit_assign(k) = lg2(1); 
    elseif ((bit_assign(k)>=interval(1)) & (bit_assign(k)<interval(2)))
       Laplacian3;
       bit_assign(k) = lg2(2);
    elseif ((bit_assign(k)>=interval(2)) & (bit_assign(k)<interval(3)))
       Laplacian4;
       bit_assign(k) = lg2(3);
    elseif ((bit_assign(k)>=interval(3)) & (bit_assign(k)<interval(4)))
       Laplacian5;
       bit_assign(k) = lg2(4);
    elseif ((bit_assign(k)>=interval(4)) & (bit_assign(k)<interval(5)))
       Laplacian6;
       bit_assign(k) = lg2(5);
    elseif ((bit_assign(k)>=interval(5)) & (bit_assign(k)<interval(6)))
       Laplacian7;
       bit_assign(k) = lg2(6);
    elseif ((bit_assign(k)>=interval(6)) & (bit_assign(k)<interval(7)))
       Laplacian8;
       bit_assign(k) = lg2(7);
    elseif ((bit_assign(k)>=interval(7)) & (bit_assign(k)<interval(8)))
       Laplacian9;
       bit_assign(k) = lg2(8);
    elseif ((bit_assign(k)>=interval(8)) & (bit_assign(k)<interval(9)))
       Laplacian10;
       bit_assign(k) = lg2(9);
    elseif ((bit_assign(k)>=interval(9)) & (bit_assign(k)<interval(10)))
       Laplacian11;
       bit_assign(k) = lg2(10);
    elseif ((bit_assign(k)>=interval(10)) & (bit_assign(k)<interval(11)))
       Laplacian12;
       bit_assign(k) = lg2(11);
    elseif ((bit_assign(k)>=interval(11)) & (bit_assign(k)<interval(12)))
       Laplacian13;
       bit_assign(k) = lg2(12);
    elseif ((bit_assign(k)>=interval(12)) & (bit_assign(k)<interval(13)))
       Laplacian14;
       bit_assign(k) = lg2(13);
    elseif ((bit_assign(k)>=interval(13)) & (bit_assign(k)<interval(14)))
       Laplacian15;
       bit_assign(k) = lg2(14);
    elseif ((bit_assign(k)>=interval(14)) & (bit_assign(k)<interval(15)))
       Laplacian16;
       bit_assign(k) = lg2(15);
    elseif ((bit_assign(k)>=interval(15)) & (bit_assign(k)<interval(16)))
       Laplacian17;
       bit_assign(k) = lg2(16);
    elseif ((bit_assign(k)>=interval(16)) & (bit_assign(k)<interval(17)))
       Laplacian18;
       bit_assign(k) = lg2(17);    
    elseif ((bit_assign(k)>=interval(17)) & (bit_assign(k)<interval(18)))
       Laplacian19;
       bit_assign(k) = lg2(18);
    elseif ((bit_assign(k)>=interval(18)) & (bit_assign(k)<interval(19)))
       Laplacian20;
       bit_assign(k) = lg2(19);
    elseif ((bit_assign(k)>=interval(19)) & (bit_assign(k)<interval(20)))
       Laplacian21;
       bit_assign(k) = lg2(20);
    elseif ((bit_assign(k)>=interval(20)) & (bit_assign(k)<interval(21)))
       Laplacian22;
       bit_assign(k) = lg2(21);
    elseif ((bit_assign(k)>=interval(21)) & (bit_assign(k)<interval(22)))
       Laplacian23;
       bit_assign(k) = lg2(22);
    elseif ((bit_assign(k)>=interval(22)) & (bit_assign(k)<interval(23)))
       Laplacian24;
       bit_assign(k) = lg2(23);
    elseif ((bit_assign(k)>=interval(23)) & (bit_assign(k)<interval(24)))
       Laplacian25;
       bit_assign(k) = lg2(24);
    elseif ((bit_assign(k)>=interval(24)) & (bit_assign(k)<interval(25)))
       Laplacian26;
       bit_assign(k) = lg2(25);
    elseif ((bit_assign(k)>=interval(25)) & (bit_assign(k)<interval(26)))
       Laplacian27;
       bit_assign(k) = lg2(26);
    elseif ((bit_assign(k)>=interval(26)) & (bit_assign(k)<interval(27)))
       Laplacian28;
       bit_assign(k) = lg2(27);
    elseif ((bit_assign(k)>=interval(27)) & (bit_assign(k)<interval(28)))
       Laplacian29;
       bit_assign(k) = lg2(28);
    elseif ((bit_assign(k)>=interval(28)) & (bit_assign(k)<interval(29)))
       Laplacian30;
       bit_assign(k) = lg2(29);
    elseif ((bit_assign(k)>=interval(29)) & (bit_assign(k)<interval(30)))
       Laplacian31;
       bit_assign(k) = lg2(30);
    elseif ((bit_assign(k)>=interval(30)) & (bit_assign(k)<interval(31)))
       Laplacian32;
       bit_assign(k) = lg2(31);
    elseif ((bit_assign(k)>=interval(31)) & (bit_assign(k)<interval(32)))
       Laplacian33;
       bit_assign(k) = lg2(32);
    elseif ((bit_assign(k)>=interval(32)) & (bit_assign(k)<interval(33)))
       Laplacian34;
       bit_assign(k) = lg2(33);
    elseif ((bit_assign(k)>=interval(33)) & (bit_assign(k)<interval(34)))
       Laplacian35;
       bit_assign(k) = lg2(34);
    elseif ((bit_assign(k)>=interval(34)) & (bit_assign(k)<interval(35)))
       Laplacian36;
       bit_assign(k) = lg2(35);
    elseif ((bit_assign(k)>=interval(35)) & (bit_assign(k)<interval(36)))
       Laplacian64;
       bit_assign(k) = lg2(36);
    elseif ((bit_assign(k)>=interval(36)) & (bit_assign(k)<interval(37)))
       Laplacian128;
       bit_assign(k) = lg2(37);
    elseif bit_assign(k) >= interval(37)
       bit_assign(k) = lg2(38);
    end;

    subim = dwt_img(y_pos(2*k-1):y_pos(2*k),x_pos(2*k-1):x_pos(2*k));

    if ((bit_assign(k)>0) & (bit_assign(k)<8)) 
 
       % Normalize the coefficients  
       norm_sub_img = normalize(subim);
       mean_sub_img = mean(mean(subim));
       stdev_sub_img = stdev(subim);

       % Call quantization function  
       quant_sub_img = quantization(norm_sub_img,dec_levels,rec_vals);

       % Unnormalize quantized coefficients
       unnorm_quant_sub_img = (quant_sub_img*stdev_sub_img) + mean_sub_img;
    
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

% Compute actual average bit rate
b = mean(bit_assign(1:4));
for i=1:N
    b = mean([b bit_assign((5+(i-1)*3):(7+(i-1)*3))]);
end
 
% Echo average bit rate and bit assignment
b
bit_assign
comp = 8/b

fprintf(fid,'\n\n"Rounding" of bit assignment:\n');
for i=1:length(bit_assign)
    fprintf(fid,'%1.4f ',bit_assign(i));
end;

fprintf(fid,'\n\nActual average bit rate: %1.4f\n',b);
fprintf(fid,'Compression ratio: %3.4f:1',(8/b));

% Reconstruct image, pad quant_dwt_img with zeros in high subbands 
quant_dwt_img(ysize+1:2*ysize,1:xsize)=zeros(ysize,xsize);
quant_dwt_img(1:2*ysize,xsize+1:2*xsize)=zeros(2*ysize,xsize); 
rec_img = reconstN(quant_dwt_img,N+1);

qual = psnr(img,rec_img)
fprintf(fid,'\nPSNR: %2.4f \n\n',qual);
