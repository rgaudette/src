%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Program: video_encoder_bi.m
% Author: David F. Hoag
%         11/7/94
%
% This program takes a video sequence and compresses it
% using the MPEG-like video encoding scheme. For motion
% estimation, an overlap block matching technique is applied.
% The biorthogonal wavelet/VQ still image compression algorithm 
% resides in the forward path of the encoder rather than JPEG.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define the number of motion vector bytes per residual frame
mot_vec_bytes = 96;

% Load in video data
video_data;
video_dim = length(video);
for i=1:video_dim
    eval(['load ',video(i,:)]);
end;

% Compress 1st image using wavelet/VQ algorithm at approx. 20:1
eval(['[video1_comp, comp] = bivqba2(',video(1,:),',3,1.5);']);
eval(['psnr_vec(1) = psnr(',video(1,:),',video1_comp)']);

% Find dimensions of image data
[ysize, xsize] = size(video1_comp);
num_pixels = ysize*xsize;
 
% Compute compression rate
sum = num_pixels/comp

% Build movie
figure(1);
colormap(gray(256));
image(video1_comp);
lim = axis;
movie_handle = moviein(video_dim);
axis(lim);
movie_handle(:,1) = getframe;

% Compress remainder of sequence
for i=2:video_dim 
    % Generate motion vectors for 2 succesive images from sequence
    eval(['[mot_vec_x,mot_vec_y] = overlap_motion(',video(i-1,:),',',video(i,:),');']);
    if (i==2)
       video_pred = video1_comp;
       residual_comp = 0;
    end;

    % Clear old frames from Matlab memory
    if (i>2)
       eval(['clear ',video(i-2,:)]);
    end

    video_pred = motion_comp(video_pred+residual_comp,mot_vec_x,mot_vec_y);

    % Compute residual error
    eval(['residual = ',video(i,:),'-video_pred;']);

    % Compress the residual error using  wavelet/VQ algorithm
    [residual_comp, comp] = bivqba2(residual,6,.001);
    sum = sum + num_pixels/comp

    % Decode the compressed video
    % For 2nd video frame reconstruction, use predicted video frame from 
    % encoder end, else use past decoded frame with motion compensation
    if (i==2)
       video_decode_mot_comp = video_pred;
    else
       video_decode_mot_comp = motion_comp(video_decode,mot_vec_x,mot_vec_y);
    end;

    video_decode = video_decode_mot_comp + residual_comp;
    eval(['psnr_vec(i) = psnr(',video(i,:),',video_decode)']);
    image(video_decode);
    axis(lim)
    movie_handle(:,i)=getframe;
end;

% Compute overall average compression
sum = sum + (video_dim-1)*mot_vec_bytes;
compression = video_dim*num_pixels/sum 
