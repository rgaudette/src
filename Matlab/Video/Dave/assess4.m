load jt400.mat;

fp = fopen('rd_vq_bi.m','w');

   fprintf(fp,'rd3 =[\n');
   for rate=4*(.001:.0125:1)
       [rec, comp_ratio] = bivqba2(jt400,3,rate);
       psnr = new_psnr(jt400,rec)
       fprintf(fp,'%f %f\n',psnr,(8.0/comp_ratio));
       clear rec;
   end;
   fprintf(fp,'];\n\n');

fclose(fp)
