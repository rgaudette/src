%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This program computes the 3D separable wavelet transform
% of a video sequence. It uses Daubechies wavelet filters. 
%
% author: David Hoag
% date: 2/23/95
%
% program: wt_3d.m   
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load in file with video data, compute 2D wavelet
% transform for each image then reshape each image to
% a column vector. Order each column in a supermatrix
% then perform WT across the temporal domain. Also
% contained in the video_data.m file are the
% dimensions of each image (y_dim, x_dim)

video_data

% Set the # of 2D decompositions
num_2D_dec=1;

% Set num_img to the # of images in the sequence
num_img = length(video);

% Initialize supermatrix
super_mat = zeros((y_dim*x_dim),num_img);

% Compute 2D WT for each image individually
for i=1:num_img
    eval(['load ',video(i,:)]);
    tmp_img = eval(video(i,:));
    decN = decompN(tmp_img,num_2D_dec);
    clear tmp_img;
    
    % Reshape image into column, insert into supermatrix
    super_mat(:,i) = reshape(decN,(ydim*xdim),1);
    clear decN;
end;

% Load in 6-tap Daubechies filter
hload6;

% Compute WT for temporal (row) data
wave_3D = dwt(super_mat);
clear super_mat;

result = [];

for i=1:num_img
    result = [result reshape(wave_3D(:),ydim,xdim))];
end;

clear super_mat;
    
