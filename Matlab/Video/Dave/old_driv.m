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

[mot_vec_x, mot_vec_y] = overlap_motion(jt400,jt401);
jt401_pred = motion_comp(jt400,mot_vec_x,mot_vec_y);
image(jt401_pred)
psnr(jt401,jt401_pred)

[mot_vec_x, mot_vec_y] = overlap_motion(jt401,jt402);
jt402_pred = motion_comp(jt401_pred,mot_vec_x,mot_vec_y);
image(jt402_pred)
psnr(jt402,jt402_pred)

[mot_vec_x, mot_vec_y] = overlap_motion(jt402,jt403);
jt403_pred = motion_comp(jt402_pred,mot_vec_x,mot_vec_y);
image(jt403_pred)
psnr(jt403,jt403_pred)

[mot_vec_x, mot_vec_y] = overlap_motion(jt403,jt404);
jt404_pred = motion_comp(jt403_pred,mot_vec_x,mot_vec_y);
image(jt404_pred)
psnr(jt404,jt404_pred)

[mot_vec_x, mot_vec_y] = overlap_motion(jt404,jt405);
jt405_pred = motion_comp(jt404_pred,mot_vec_x,mot_vec_y);
image(jt405_pred)
psnr(jt405,jt405_pred)

[mot_vec_x, mot_vec_y] = overlap_motion(jt405,jt406);
jt406_pred = motion_comp(jt405_pred,mot_vec_x,mot_vec_y);
image(jt406_pred)
psnr(jt406,jt406_pred)

[mot_vec_x, mot_vec_y] = overlap_motion(jt406,jt407);
jt407_pred = motion_comp(jt406_pred,mot_vec_x,mot_vec_y);
image(jt407_pred)
psnr(jt407,jt407_pred)

[mot_vec_x, mot_vec_y] = overlap_motion(jt407,jt408);
jt408_pred = motion_comp(jt407_pred,mot_vec_x,mot_vec_y);
image(jt408_pred)
psnr(jt408,jt408_pred)

[mot_vec_x, mot_vec_y] = overlap_motion(jt408,jt409);
jt409_pred = motion_comp(jt408_pred,mot_vec_x,mot_vec_y);
image(jt409_pred)
psnr(jt409,jt409_pred)










