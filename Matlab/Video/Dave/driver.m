load jt40_decs;
ll1 = dec1(1:128,1:128); 
ll2 = dec2(1:128,1:128); 
ll3 = dec3(1:128,1:128);

ll1_2 = decompN(ll1,1); 
ll2_2 = decompN(ll2,1); 
ll3_2 = decompN(ll3,1); 

ll_comp = motion_comp3(ll1_2(1:64,1:64),ll2_2(1:64,1:64),ll3_2(1:64,1:64));
lh_comp = motion_comp3(ll1_2(1:64,65:128),ll2_2(1:64,65:128),ll3_2(1:64,65:128));
hl_comp = motion_comp3(ll1_2(65:128,1:64),ll2_2(65:128,1:64),ll3_2(65:128,1:64));
hh_comp = motion_comp3(ll1_2(65:128,65:128),ll2_2(65:128,65:128),ll3_2(65:128,65:128));


 
dec1_comp = zeros(256,256);
dec1_comp(1:128,1:128) = [ll_comp lh_comp; hl_comp hh_comp];

rec = reconstN(dec1_comp,2);

image(rec)
psnr(img,rec)




