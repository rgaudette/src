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

start = clock;

% Load in video data
disp('Loading video data ...'); st = clock;

setfile;
[video_dim junk] = size(video);
for i=1:video_dim
    eval(['load ',video(i,:)]);
end;

et = etime(clock, st); disp(['Elapsed time: ' num2str(et)]); disp(' ');


% Initialization/parameters
% Define the number of motion vector bytes per residual frame
% Frame compression
mot_vec_bytes = 128;
frame_comp = zeros(video_dim, 1);
psnr_vec = zeros(video_dim, 1);

% Compress 1st image using wavelet/VQ algorithm at approx. 20:1
disp('Compressing first image ...'); st = clock;

eval(['[video1_comp frame_comp(1) Indices nIndices] = bivqba2a(',video(1,:),',3,1.6);']);
video_pred = video1_comp;
residual_comp = 0;
[ysize, xsize] = size(video1_comp);
num_pixels = ysize*xsize;
sum = num_pixels/frame_comp(1);

et = etime(clock, st); disp(['Elapsed time: ' num2str(et)]); disp(' ');


disp('Computing PSNR ...'); st = clock;

eval(['psnr_vec(1) = new_psnr(',video(1,:),',video1_comp);']);
psnr_vec(1)
et = etime(clock, st); disp(['Elapsed time: ' num2str(et)]); disp(' ');


% Build movie
disp('Setting up movie ...'); st = clock;

image(video1_comp);
movie_handle = moviein(video_dim);
movie_handle(:,1) = getframe;

et = etime(clock, st); disp(['Elapsed time: ' num2str(et)]); disp(' ');


% Compress remainder of sequence                   
for i=2:video_dim 

    % Generate motion vectors for 2 succesive images from sequence
    disp('Estimating motion vectors...'); st = clock;

    eval(['[mot_vec_x,mot_vec_y] = mot_est(' video(i-1,:) ',' video(i,:) ...
    ',[16 16], [34 34], [20 20] );']);
    figure(2)
    quiver(mot_vec_x, mot_vec_y)
    figure(1)

    %eval(['[mot_vec_x,mot_vec_y]=non_overlap(',video(i-1,:),',',video(i,:),');']);

    et = etime(clock, st); disp(['Elapsed time: ' num2str(et)]); disp(' ');
    

    disp('Performing motion compensation...');  st = clock;

    video_pred = motncmp(video_pred+residual_comp,mot_vec_x,mot_vec_y);

    et = etime(clock, st); disp(['Elapsed time: ' num2str(et)]); disp(' ');
    
    % Compute residual error
    disp('Computing/Compressing residual error ...'); st = clock;

    eval(['residual = ',video(i,:),'-video_pred;']);

    % Compress the residual error using  wavelet/VQ algorithm
    [residual_comp frame_comp(i) Indices nIndices] = bivqba2a(residual, 6, .001);

    et = etime(clock, st); disp(['Elapsed time: ' num2str(et)]); disp(' ');
    

    if (i==3)
        resid2 = residual;
        resid_comp2 = residual_comp;
    end;

    sum = sum + num_pixels/frame_comp(i);


    %%
    %%  Reconstrucion section
    %%

    % Decode the compressed video
    % For 2nd video frame reconstruction, use predicted video frame from 
    % encoder end, else use past decoded frame with motion compensation
    disp('Generating decoded image ...'); st = clock;

    if (i==2)
       video_decode_mot_comp = video_pred;
    else
       video_decode_mot_comp = motncmp(video_decode,mot_vec_x,mot_vec_y);
    end;
    video_decode = video_decode_mot_comp + residual_comp;
    
    et = etime(clock, st); disp(['Elapsed time: ' num2str(et)]); disp(' ');

    disp('Computing PSNR and adding movie sequence...'); st = clock;

    eval(['psnr_vec(i) = new_psnr(',video(i,:),',video_decode);']);
    psnr_vec
    image(video_decode);
    movie_handle(:,i)=getframe;

    et = etime(clock, st); disp(['Elapsed time: ' num2str(et)]); disp(' ');
end;

% Compute overall average compression. Sum is the total # of pixels (8 bits per)
% which result after compression
sum = sum + (video_dim-1)*mot_vec_bytes;
compression = video_dim*num_pixels/sum

eval(['clear ',video(i-1,:)]);
eval(['clear ',video(i,:)]);

disp(['Total computation time: ', num2str(etime(clock, start)) ]);
