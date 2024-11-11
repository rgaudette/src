%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Program: motion_comp.m
% Author: David F. Hoag
%         10/30/94
%
% This program takes an image and associated motion vectors and
% generates an estimate of the next frame in the sequence based
% on this info.
%
% input: img = input image
%        mot_vect_x = array of x components of the motion vectors
%        mot_vect_y = array of y components of the motion vectors
% output: comp_img = predicted output image
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function comp_img = motion_comp(img,mot_vec_x,mot_vec_y)

[vec_y_dim,vec_x_dim] = size(mot_vec_x);
[img_y_dim,img_x_dim] = size(img);

% Initialize predicted image values
comp_img = -1*ones(img_y_dim,img_x_dim);

blk_y_dim = img_y_dim/vec_y_dim;
blk_x_dim = img_x_dim/vec_x_dim;

% Prediction of image
for i=1:vec_y_dim
    for j=1:vec_x_dim
	    % Generate values by block processing
	    for k=1:blk_y_dim
	        for l=1:blk_x_dim
	            if ((blk_y_dim*(i-1)+k+mot_vec_y(i,j)>0) & (blk_y_dim*(i-1)+k+mot_vec_y(i,j)<(img_y_dim+1)) & (blk_x_dim*(j-1)+l+mot_vec_x(i,j)>0) & (blk_x_dim*(j-1)+l+mot_vec_x(i,j)<(img_x_dim+1)))
           
		            if (comp_img(blk_y_dim*(i-1)+k+mot_vec_y(i,j),blk_x_dim*(j-1)+l+mot_vec_x(i,j)) == -1)
		                comp_img(blk_y_dim*(i-1)+k+mot_vec_y(i,j),blk_x_dim*(j-1)+l+mot_vec_x(i,j)) = img(blk_y_dim*(i-1)+k,blk_x_dim*(j-1)+l);
		            end;
    	        end;
            end;
	    end;
    end;
end;

% Check if any pixels in reconstructed image are still set to -1
for i=1:img_y_dim
    for j=1:img_x_dim
	if (comp_img(i,j) == -1)
	   comp_img(i,j) = img(i,j);
	end;
    end;
end;
