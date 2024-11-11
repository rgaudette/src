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
function comp_img = motion_comp(img, mot_vec_x, mot_vec_y)

[vec_y_dim,vec_x_dim] = size(mot_vec_x);
[img_y_dim,img_x_dim] = size(img);

%%
%%  Compute necessary border size, but at least 0
%%
BrdrTop= max(abs(mot_vec_y(1,:)));
BrdrBottom = max(abs(mot_vec_y(vec_y_dim,:)));
BrdrLeft= max(abs(mot_vec_x(:,1)));
BrdrRight = max(abs(mot_vec_x(:,vec_x_dim)));

% Initialize predicted image values
comp_img = -1*ones(img_y_dim+BrdrTop+BrdrBottom, img_x_dim+BrdrLeft+BrdrRight);

blk_y_dim = img_y_dim/vec_y_dim;
blk_x_dim = img_x_dim/vec_x_dim;

% Prediction of image
for i=vec_y_dim:-1:1
    for j=vec_x_dim:-1:1
        SrcBlkY = [blk_y_dim*(i-1)+1:blk_y_dim*i];
        SrcBlkX = [blk_x_dim*(j-1)+1:blk_x_dim*j];
        DestBlkY = [blk_y_dim*(i-1)+1:blk_y_dim*i] + BrdrTop + mot_vec_y(i,j);
        DestBlkX = [blk_x_dim*(j-1)+1:blk_x_dim*j] + BrdrLeft + mot_vec_x(i,j);
        comp_img(DestBlkY, DestBlkX) = img(SrcBlkY, SrcBlkX);
    end;
end;

%%
%%  Remove border from image
%%

comp_img = comp_img([BrdrTop+1:BrdrTop+img_y_dim], ...
                    [BrdrLeft+1:BrdrLeft+img_x_dim]);

% Check if any pixels in reconstructed image are still set to -1
idx = find(comp_img == -1);
comp_img(idx) = img(idx);

