load jt400;
load jt401;
load jt402;
load jt403;
load jt404;
load jt405;
load jt406;
load jt407;
load jt408;
load jt409;

% Compress 1st image using wave/VQ algorithm
jt400_comp20 = vq_bit_alloc2(jt400,3,1.6);

% Compress 2nd image in the sequence
[mot_vec_x, mot_vec_y] = overlap_motion(jt400,jt401);
jt401_pred = motion_comp(jt400_comp20,mot_vec_x,mot_vec_y);
image(jt401_pred)
psnr(jt401,jt401_pred)
residual = jt401-jt401_pred;
res_comp = vq_bit_alloc2(residual,6,.001);

% Decoder
jt401_enc = jt401_pred+res_comp;

image(jt401_enc)
psnr(jt401,jt401_enc)

% Compress 3rd image in the sequence
[mot_vec_x, mot_vec_y] = overlap_motion(jt401,jt402);
jt402_pred = motion_comp(jt401_pred+res_comp,mot_vec_x,mot_vec_y);
image(jt402_pred)
psnr(jt402,jt402_pred)
residual = jt402-jt402_pred;
res_comp = vq_bit_alloc2(residual,6,.001);

% Decoder
jt401_new_enc = motion_comp(jt401_enc,mot_vec_x,mot_vec_y);
jt402_enc = jt401_new_enc+res_comp;

image(jt402_enc)
psnr(jt402,jt402_enc)

% Compress 4th image in the sequence
[mot_vec_x, mot_vec_y] = overlap_motion(jt402,jt403);
jt403_pred = motion_comp(jt402_pred+res_comp,mot_vec_x,mot_vec_y);
image(jt403_pred)
psnr(jt403,jt403_pred)
residual = jt403-jt403_pred;
res_comp = vq_bit_alloc2(residual,6,.001);

% DecoderFrom veeram Wed Nov  9 13:48:40 1994
To: hoag@cdsp.neu.edu
Subject: Re:  Pot luck dinner Sat.
Content-Length: 298
X-Lines: 9

Hi davie,
i have a friday morning meeting at 9:30 at MIT.
too bad, isnt it ? Anyway, how about saturday or
friday evening ? i mean sat morning.
i will listen to your advise on not studying too hard.
but if i dont do well, it is your butt !!
c u and have a nice time on sat.
ram
veeram@cdsp.neu.edu


jt402_new_enc = motion_comp(jt402_enc,mot_vec_x,mot_vec_y);
jt403_enc = jt402_new_enc+res_comp;

image(jt403_enc)
psnr(jt403,jt403_enc)

% Compress 5th image in the sequence
[mot_vec_x, mot_vec_y] = overlap_motion(jt403,jt404);
jt404_pred = motion_comp(jt403_pred+res_comp,mot_vec_x,mot_vec_y);
image(jt404_pred)
psnr(jt404,jt404_pred)
residual = jt404-jt404_pred;
res_comp = vq_bit_alloc2(residual,6,.001);

% Decoder
jt403_new_enc = motion_comp(jt403_enc,mot_vec_x,mot_vec_y);
jt404_enc = jt403_new_enc+res_comp;

image(jt404_enc)
psnr(jt404,jt404_enc)

% Compress 6th image in the sequence
[mot_vec_x, mot_vec_y] = overlap_motion(jt404,jt405);
jt405_pred = motion_comp(jt404_pred+res_comp,mot_vec_x,mot_vec_y);
image(jt405_pred)
psnr(jt405,jt405_pred)
residual = jt405-jt405_pred;
res_comp = vq_bit_alloc2(residual,6,.001);

% Decoder
jt404_new_enc = motion_comp(jt404_enc,mot_vec_x,mot_vec_y);
jt405_enc = jt404_new_enc+res_comp;

image(jt405_enc)
psnr(jt405,jt405_enc)

% Compress 7th image in the sequence
[mot_vec_x, mot_vec_y] = overlap_motion(jt405,jt406);
jt406_pred = motion_comp(jt405_pred+res_comp,mot_vec_x,mot_vec_y);
image(jt406_pred)
psnr(jt406,jt406_pred)
residual = jt406-jt406_pred;
res_comp = vq_bit_alloc2(residual,6,.001);

% Decoder
jt405_new_enc = motion_comp(jt405_enc,mot_vec_x,mot_vec_y);
jt406_enc = jt405_new_enc+res_comp;

image(jt406_enc)
psnr(jt406,jt406_enc)

% Compress 8th image in the sequence
[mot_vec_x, mot_vec_y] = overlap_motion(jt406,jt407);
jt407_pred = motion_comp(jt406_pred+res_comp,mot_vec_x,mot_vec_y);
image(jt407_pred)
psnr(jt407,jt407_pred)
residual = jt407-jt407_pred;
res_comp = vq_bit_alloc2(residual,6,.001);

% Decoder
jt406_new_enc = motion_comp(jt406_enc,mot_vec_x,mot_vec_y);
jt407_enc = jt406_new_enc+res_comp;

image(jt407_enc)
psnr(jt407,jt407_enc)

% Compress 9th image in the sequence
[mot_vec_x, mot_vec_y] = overlap_motion(jt407,jt408);
jt408_pred = motion_comp(jt406_pred+res_comp,mot_vec_x,mot_vec_y);
image(jt408_pred)
psnr(jt408,jt408_pred)
residual = jt408-jt408_pred;
res_comp = vq_bit_alloc2(residual,6,.001);

% Decoder
jt407_new_enc = motion_comp(jt407_enc,mot_vec_x,mot_vec_y);
jt408_enc = jt407_new_enc+res_comp;

image(jt408_enc)
psnr(jt408,jt408_enc)
psnr(jt408,jt408_enc)

% Compress 10th image in the sequence

% Compress 10th image in the sequence
[mot_vec_x, mot_vec_y] = overlap_motion(jt408,jt409);
jt409_pred = motion_comp(jt408_pred+res_comp,mot_vec_x,mot_vec_y);
image(jt409_pred)
psnr(jt409,jt409_pred)
residual = jt409-jt409_pred;
res_comp = vq_bit_alloc2(residual,6,.001);

% Decoder
jt408_new_enc = motion_comp(jt408_enc,mot_vec_x,mot_vec_y);
jt409_enc = jt408_new_enc+res_comp;

image(jt409_enc)
psnr(jt409,jt409_enc)

