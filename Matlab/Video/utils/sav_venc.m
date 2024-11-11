%SAV_VENC       Save video encoder data to a file given by sav_name.
%
%   Input vars:
%
%   sav_name    The file name to save the data under.

eval(['save ' sav_name ' BlockSize MotVecMovie OverlapBlock PrimaryNDecomp ' ...
        'PrimaryRate ResidNDecomp ResidRate UpdateRate WindowSize algCBMap ' ...
        'algCompression algMotionComp algMotionEst flgZeroMotBrdr frame_comp ' ...
        'movie_handle nImages psnr_vec video' ]);


