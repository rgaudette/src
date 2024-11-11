%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Program: overlap_motion.m
% Author: David F. Hoag
%         10/29/94
%
% This program takes two consecutive images in a video
% sequence and uses overlapped block matching to estimate
% motion vectors. 
%
% input: img1 = input image1
%        img2 = input image2
% output: mot_vect_x = array of x components of the motion vectors
%         mot_vect_y = array of y components of the motion vectors
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [mot_vect_x, mot_vect_y] = overlap_motion(img1,img2);

% Find the dimensions of input matrix 
[ydim,xdim]  = size(img1);

% Define block and window dimensions. If the block size and windowed 
% block size are of equal dimension then no overlapping will take
% place, i.e. equivalent to simple block-matching.
blk_x = 16;
blk_y = 16;
win_blk_x = 20;
win_blk_y = 20;
win_x = 34;
win_y = 34;

% Pad img1 with zeros at edges to account for overlapping
% blocks which extend beyond the support of the image.
dum = zeros(ydim+(win_blk_y-blk_y),xdim+(win_blk_x-blk_x));
dum((win_blk_y-blk_y)/2+1:ydim+(win_blk_y-blk_y)/2,(win_blk_x-blk_x)/2+1:xdim+(win_blk_x-blk_x)/2)=img1;
img1 = dum;

% Pad img2 with zeros at edges to account for windowing
dum = zeros(ydim+(win_y-blk_y),xdim+(win_x-blk_x));
dum((win_y-blk_y)/2+1:ydim+(win_y-blk_y)/2,(win_x-blk_x)/2+1:xdim+(win_x-blk_x)/2)=img2;
img2 = dum;

mot_vect_x = zeros(ydim/blk_y,xdim/blk_x);
mot_vect_y = zeros(ydim/blk_y,xdim/blk_x);

for i=1:ydim/blk_y
    for j=1:xdim/blk_x
        block = img1(blk_y*(i-1)+1:blk_y*(i-1)+win_blk_y,blk_x*(j-1)+1:blk_x*(j-1)+win_blk_x);
        window = img2(blk_y*(i-1)+1:blk_y*(i-1)+win_y,blk_x*(j-1)+1:blk_x*(j-1)+win_x);
	    min = 999999;
	    for l=1:(win_x-win_blk_x)+1
	        for k=1:(win_y-win_blk_y)+1
                tmp = sum(sum(abs(block-window(k:k+win_blk_y-1,l:l+win_blk_x-1))));
                if tmp<min
    	            mot_vect_x(i,j) = l-((win_x-win_blk_x)/2+1);
                    mot_vect_y(i,j) = k-((win_y-win_blk_y)/2+1);
		            min = tmp;
		        end;
            end;
	    end;
    end;
end;
