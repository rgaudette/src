load jt40_decs;
ll1 = dec1(1:128,1:128); 
ll2 = dec2(1:128,1:128); 
ll3 = dec3(1:128,1:128);

ll1_2 = decompN(ll1,1); 
ll2_2 = decompN(ll2,1); 
ll3_2 = decompN(ll3,1); 

% Compute backward and forward motion estimates
[x_mot_bck,y_mot_bck]=overlap_motion(ll2_2(1:64,1:64),ll1_2(1:64,1:64));
[x_mot_for,y_mot_for]=overlap_motion(ll2_2(1:64,1:64),ll3_2(1:64,1:64));


ll2_comp = motion_comp2(ll1_2(1:64,1:64),ll2_2(1:64,1:64),ll3_2(1:64,1:64),x_mot_bck,y_mot_bck,x_mot_for,y_mot_for);

lh2_comp = motion_comp2(ll1_2(1:64,65:128),ll2_2(1:64,65:128),ll3_2(1:64,65:128),x_mot_bck,y_mot_bck,x_mot_for,y_mot_for);

hl2_comp = motion_comp2(ll1_2(65:128,1:64),ll2_2(65:128,1:64),ll3_2(65:128,1:64),x_mot_bck,y_mot_bck,x_mot_for,y_mot_for);

hh2_comp = motion_comp2(ll1_2(65:128,65:128),ll2_2(65:128,65:128),ll3_2(65:128,65:128),x_mot_bck,y_mot_bck,x_mot_for,y_mot_for);
 
dec1_comp = zeros(256,256);
dec1_comp(1:128,1:128) = [ll2_comp lh2_comp; hl2_comp hh2_comp];

rec = reconstN(dec1_comp,2);

image(rec)

psnr(img,rec)




