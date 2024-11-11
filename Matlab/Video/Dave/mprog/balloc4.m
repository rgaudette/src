%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The original image is 2 step decomposed, then the LH1, HL1
% and HH1 subbands are zeroed. The function 
% then allocates bits according to Matic/Mosley bit alloc.
% strategy. If any subbands are assigned negative rates then
% the subband is zeroed and the bit allocation is redone.
% Any rates greater than 8 are forced to be equal to 8.
% The coefficients are then Lloyd-Max. quantized according to
% Laplacian models and the image is reconstructed. 
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

function rec_img = bit_alloc4(N,b);

N = N-1;

% Initialize bit_assign to 1 
num_subs = 3*N+1;
bit_assign = ones(1,num_subs);

% Load in 2nd step decomposition of jt403
load jt403_dec2;
img_decN = img_dec2;

dim = size(img_decN);
ysize = dim(1);
xsize = dim(2);
pix_num = ysize*xsize;

% Decompose the image N-2 more times
if (N-1)>0
   tmp_img = img_decN(1:ysize/2,1:xsize/2);
   tmp_img = decompN(tmp_img,(N-1));
   img_decN(1:ysize/2,1:xsize/2)=tmp_img;
end;

% Generate x_pos and y_pos vectors which represent the spatial
% location of the various subbands
y_pos = [1 (ysize/(2^N))];    
x_pos = [1 (xsize/(2^N))];
 
for i=N:-1:1
    y_pos = [y_pos 1 ysize/(2^i) (ysize/(2^i) + 1) ysize/(2^(i-1))];
    y_pos = [y_pos (ysize/(2^i) + 1) ysize/(2^(i-1))];
    x_pos = [x_pos (xsize/(2^i) + 1) xsize/(2^(i-1)) 1 xsize/(2^i)];
    x_pos = [x_pos (xsize/(2^i) + 1) xsize/(2^(i-1))];
end;

geom_mean_var = 1;
% Compute subband variances and geometric mean of the variance
for i=1:num_subs
    tmp_img = img_decN(y_pos(2*i-1):y_pos(2*i),x_pos(2*i-1):x_pos(2*i));
    tmp_dim = size(tmp_img); 
    % Compute number of pixels in each subband
    sub_pix_size(i) = tmp_dim(1)*tmp_dim(2); 
    var(i) = (std(tmp_img(:)))^2; 
    weight_var(i) = var(i)^(sub_pix_size(i)/pix_num);
    geom_mean_var = geom_mean_var*weight_var(i);
end;

% Perform bit allocation on the subbands until
% all bit rates are >= 0.
flag = 0;

while (flag ~= num_subs)
      flag = 0;
      for i=1:num_subs 
          % Compute bit assignments
          if (bit_assign(i) > 0)
             bit_assign(i) = b + .5/log10(2)*log10(var(i)/geom_mean_var);
             if bit_assign(i) < 0 
                bit_assign(i) = 0;
                weight_var(i) = 1;
             else
                flag = flag + 1;
             end;
          else
             flag = flag + 1;
          end
      end;

      % If any bit assignments = 0, zero out its contribution to the
      % bit allocation formula.

      % Subtract off contributing # of pixels
      for i=1:num_subs
          if bit_assign(i)==0 
             pix_num = pix_num - sub_pix_size(i);
             sub_pix_size(i) = 0;
          end;
      end;  

      % Recalculate the geometric mean of the variances
      geom_mean_var = 1;
      for i=1:num_subs
          if bit_assign(i)~=0
             weight_var(i) = var(i)^(sub_pix_size(i)/pix_num);
             geom_mean_var = geom_mean_var*weight_var(i);
          end;
      end; 
end;

bit_assign
bit_assign = round(bit_assign)

% Insure that bits <=8
for i=2:length(bit_assign)
    if bit_assign(i) >= 8
       bit_assign(i) = 8;
    end;
end;
 
% Set bit assignment of LL to 8
bit_assign(1)=8;

% Add in zeros for bit rates of upper subbands
bit_assign = [bit_assign 0 0 0]
 
% Compute actual average bit rate
b = mean(bit_assign(1:4));
for i=1:N
    b = mean([b bit_assign((5+(i-1)*3):(7+(i-1)*3))]);
end 
 
% Echo average bit rate and bit assignment
b
comp = 8/b
 
% Quantize wavelet coefficients according to bit allocation and
% Laplacian model
for j=1:(length(bit_assign)-3)
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
 
    subim = img_decN(y_pos(2*j-1):y_pos(2*j),x_pos(2*j-1):x_pos(2*j));
 
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
 
    if (bit_assign(j)==8)
       quant_dwt_img(y_pos(2*j-1):y_pos(2*j),x_pos(2*j-1):x_pos(2*j)) = (subim);
    end;
end;
 
% Reconstruct image, pad quant_dwt_img with zeros in high subbands
quant_dwt_img(ysize+1:2*ysize,1:xsize)=zeros(ysize,xsize);
quant_dwt_img(1:2*ysize,xsize+1:2*xsize)=zeros(2*ysize,xsize);
rec_img = reconstN(quant_dwt_img,N+1);
