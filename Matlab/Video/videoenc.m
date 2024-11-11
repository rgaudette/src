%VIDEOENC       Video encoding script
%
%   This script, based on David Hoag's VIDEO_ENCODER_BI performs video
% encoding using an MPEG style algorithm.  The Modifiable parameters are
% present at the beginning of the script.
%
% Input variables:
%
%   video       The names of the MATLAB files containing the images in the 
%               seqeuence.  Each row should contain the name of a file.
%
%
% Output variables:
%
%   psnr_vec    The Peak-Signal-to-Noise ratio for each frame.
%
%   frame_comp  The compression ratio for each frame.
%
%   movie_handle A movie sequence matrix.
%
%   icb_*       The codebook indices used for each codebook for the image
%               compression.
%
%   rcb_*       The codebook indices used for each codebook for the residual
%               compression.
%
%   cb_*        The combined (residual & image) codebook indices.

%%
%%  Modifiable parameters
%%
IntraFrameRate     = 1.9;
IntraFrameNDecomp  = 3;
ResidRate       = 1E-8;
ResidNDecomp    = 6;
UpdateRate      = 10;

BlockSize       = [16 16];
WindowSize      = [34 34];
OverlapBlock    = [20 20];

flgMotBrdr      = 1;
flgDisplay      = 1;
flgMotVecVid    = 1;
flgTime         = 0;
flgRcrdIdx      = 0;

%%
%%  Algorithms
%%
algCompression      = 'biecvqb2';
algMotionEst        = 'mot_est';
algMotionComp       = 'avmotcmp';
algMotCompPostFilt  = 'uncovrd';
algCBMap            = 'ecvqggcb';

if flgTime > 0,
 AlgStart = clock;
end

%%
%%  Initialization and matrix preallocation
%%
[nImages junk] = size(video);
nIntraFrame = ceil(nImages/ UpdateRate);
nResidual = nImages - nIntraFrame;
psnr_vec = zeros(nImages, 1);
frame_comp = zeros(nImages, 1);
ResidualVar = zeros(nResidual, 1);

%%
%%  If index recording is selected load in the codebook lookup table to
%%  initialize index recording arrays.
%%
if flgRcrdIdx
    [Rates Files] = feval(algCBMap);

    nCB = length(Rates);

    for i = 1:nCB,
        s = sprintf('%03d', i);
        eval(['cb_' s ' = []; ']);
        eval(['icb_' s ' = []; ']);
        eval(['rcb_' s ' = []; ']);
    end
    cb_full = [];
    icb_full = [];
    rcb_full = [];
end

%%
%%  Load in the first image to get image size and setup movie structure
%%
load(video(1, :));
eval(['CurrImage = ' video(1, :) ' ;']);
eval(['clear ' video(1, :) ]);
[ysize xsize] = size(CurrImage);
nPixels = ysize * xsize;

% Compute number of motion vector bytes/image
MotionVecBytes  = ysize/BlockSize(1)*xsize/BlockSize(2)*...
   (ceil(log((WindowSize(1)-OverlapBlock(1))/log(2)))+...
    ceil(log((WindowSize(2)-OverlapBlock(2))/log(2))))/8.0;

if flgDisplay,
    figure(1);
    set(gcf, 'Position', [1 1 336 336]);
    colormap(gray(256))
    image(CurrImage)
    truesize;
    set(gca, 'visible', 'off');
    movie_handle = moviein(nImages);
end


%%
%%  Loop over image sequence files
%%
idxResidual = 0;
for idxImage = 1:nImages,

    %%
    %%  Load current image
    %%
    load(video(idxImage, :));
    eval(['CurrImage = ' video(idxImage, :) ' ;']);
    eval(['clear ' video(idxImage, :) ]);

    %%
    %%  This is an update image, send compressed image
    %%
    if rem(idxImage, UpdateRate) == 1,

        if flgTime > 0,
            disp('Computing intraframe quantization...'); st = clock;
        end

        %%
        %%  Compress image using bi-orthogonal vector quantization
        %%
        [ReconBuffer frame_comp(idxImage) Indices nIndices idxCB] = ...
            feval(algCompression, CurrImage, IntraFrameNDecomp, ...
            IntraFrameRate, algCBMap, flgTime);

        %%
        %%  Record codebook indices for each subband acorrding to
        %%  codebook.
        %%
        if flgRcrdIdx,
            [junk nSubBand] = size(Indices);
            for iSubBand = 1:nSubBand,
                if idxCB(iSubBand) == 0,
                    lnCB = length(icb_full);
                    lnCBNew = lnCB + nIndices(iSubBand);
                    icb_full(lnCB+1:lnCBNew) = Indices(1:nIndices(iSubBand), ...
                        iSubBand);
                else
                    strCB = sprintf('icb_%03d', idxCB(iSubBand));
                    eval(['lnCB = length( ' strCB ' ); ']);
                    lnCBNew = lnCB + nIndices(iSubBand);
                    disp([strCB '(' int2str(lnCB+1) ' : ' int2str(lnCBNew) ...
                    ') = Indices(1:nIndices(iSubBand), iSubBand) ;']);
                    eval([strCB '(' int2str(lnCB+1) ' : ' int2str(lnCBNew) ...
                    ') = Indices(1:nIndices(iSubBand), iSubBand) ;']);
                end
            end
        end

        if flgTime > 0,
            et = etime(clock, st); disp(['    Elapsed time : ' num2str(et)]);
        end

    %%
    %%  This is an interframe image, send compressed motion prediction
    %%
    else
        idxResidual = idxResidual + 1;

        if flgTime > 0,
            disp('Motion vector estimation...'); st = clock;
        end

        %%
        %%  Estimate motion vectors between previous and current image
        %%
        [mot_vec_x mot_vec_y] = feval(algMotionEst, ...
            PrevImage, CurrImage, BlockSize, WindowSize, OverlapBlock);


        %%
        %%  Copy motion estimates of inner subblocks to border subblocks
        %%  if requested. 
        %%
        if flgMotBrdr,

            %%
            %%  Copy the x motion vectors to the borders
            %%
            [mMX nMX] = size(mot_vec_x);
            mot_vec_x(1,1:nMX) = mot_vec_x(2,1:nMX);
            mot_vec_x(mMX,1:nMX) = mot_vec_x(mMX-1,1:nMX);
            mot_vec_x(1:mMX,1) = mot_vec_x(1:mMX,2);
            mot_vec_x(1:mMX,nMX) = mot_vec_x(1:mMX,nMX-1);

            %%
            %%  Copy the y motion vectors to the borders
            %%
            [mMY nMY] = size(mot_vec_y);
            mot_vec_y(1,1:nMY) = mot_vec_y(2,1:nMY);
            mot_vec_y(mMY,1:nMY) = mot_vec_y(mMY-1,1:nMY);
            mot_vec_y(1:mMY,1) = mot_vec_y(1:mMY,2);
            mot_vec_y(1:mMY,nMY) = mot_vec_y(1:mMY,nMY-1);
        end

        %%
        %%  Create a new figure for the motion vectors
        %%
        if flgMotVecVid,
            figure(2);
            quiver(mot_vec_x, mot_vec_y)
            if idxResidual == 1,
                MotVecMovie = moviein(nResidual);
            end
            MotVecMovie(:, idxResidual) = getframe;
            figure(1);
        end

        if flgTime > 0,
            et = etime(clock, st); disp(['    Elapsed time : ' num2str(et)]);
        end

        %%
        %%  Generate predicted image by compensating for block motion
        %%
        if flgTime > 0,
            disp('Motion compensation...'); st = clock;
        end

        video_pred = feval(algMotionComp, ReconBuffer, mot_vec_x, mot_vec_y);

	% 
	%  Perform post-filtering upon motion compensated prediction image
	%  Ex. Low-pass filtering, Uncovered area prediction
        %
 	video_pred = feval(algMotCompPostFilt, video_pred, ReconBuffer);

        if flgTime > 0,
            et = etime(clock, st); disp(['    Elapsed time : ' num2str(et)]);
        end

        %%
        %%  Compute image residual from predicted image and actual image
        %%

        if flgTime > 0,
            disp('Residual image compression...'); st = clock;
        end

        residual = CurrImage - video_pred;
        [residual_comp frame_comp(idxImage) Indices nIndices idxCB] = ...
            feval(algCompression, residual, ResidNDecomp, ResidRate, flgTime);

        %%
        %%  Compute residual image variance
        %%
        ResidualVar(idxResidual) = stdev(residual).^2;

        %%
        %%  Reconstruction section
        %%
        ReconBuffer = video_pred + residual_comp;
        if flgRcrdIdx,
            [junk nSubBand] = size(Indices);
            for iSubBand = 1:nSubBand,
                if idxCB(iSubBand) == 0,
                    lnCB = length(rcb_full);
                    lnCBNew = lnCB + nIndices(iSubBand);
                    rcb_full(lnCB+1:lnCBNew) = Indices(1:nIndices(iSubBand), iSubBand);
                else
                    strCB = sprintf('rcb_%03d', idxCB(iSubBand));
                    eval(['lnCB = length( ' strCB ' ); ']);
                    lnCBNew = lnCB + nIndices(iSubBand);
                    disp([strCB '(' int2str(lnCB+1) ' : ' int2str(lnCBNew) ...
                    ') = Indices(1:nIndices(iSubBand), iSubBand) ;']);
                    eval([strCB '(' int2str(lnCB+1) ' : ' int2str(lnCBNew) ...
                    ') = Indices(1:nIndices(iSubBand), iSubBand) ;']);
                end
            end
        end
        if flgTime > 0,
            et = etime(clock, st); disp(['    Elapsed time : ' num2str(et)]);
        end


    end

    %%
    %%  Reconstruction section
    %%  - compute PSNR
    %%  - shift current image in buffer
    %%  - add image to movie sequence
    %%
    if flgTime > 0,
        disp('Reciever reconstruction & display...'); st = clock;
    end

    psnr_vec(idxImage) = psnr(CurrImage, ReconBuffer);

    PrevImage = CurrImage;

    if flgDisplay,
        image(ReconBuffer);
        truesize;
        set(gca, 'visible', 'off');
        movie_handle(:, idxImage) = getframe;
    end

    %%
    %%  Record codebook indices for each subband acorrding to
    %%  codebook.
    %%
    if flgRcrdIdx,
        [junk nSubBand] = size(Indices);
        for iSubBand = 1:nSubBand,
            if idxCB(iSubBand) == 0,
                lnCB = length(cb_full);
                lnCBNew = lnCB + nIndices(iSubBand);
                cb_full(lnCB+1:lnCBNew) = Indices(1:nIndices(iSubBand), iSubBand);
            else
                strCB = sprintf('cb_%03d', idxCB(iSubBand));
                eval(['lnCB = length( ' strCB ' ); ']);
                lnCBNew = lnCB + nIndices(iSubBand);
                disp([strCB '(' int2str(lnCB+1) ' : ' int2str(lnCBNew) ...
                ') = Indices(1:nIndices(iSubBand), iSubBand) ;']);
                eval([strCB '(' int2str(lnCB+1) ' : ' int2str(lnCBNew) ...
                ') = Indices(1:nIndices(iSubBand), iSubBand) ;']);
            end
        end
    end

    if flgTime > 0,
        et = etime(clock, st); disp(['    Elapsed time : ' num2str(et)]);
    end

end

if flgTime > 0,
    et = etime(clock, AlgStart); disp(['Total Elapsed time : ' num2str(et)]);
end

% Compute compression rate
OrigNumBytes = nPixels*nImages;

ActualNumBytes = (UpdateRate-1)*nImages/UpdateRate*MotionVecBytes +...
     sum((nPixels*ones(nImages,1)./frame_comp));

CompressRate = OrigNumBytes/ActualNumBytes; 
