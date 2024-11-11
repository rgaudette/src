%C400DEC        Compute both temporal & spatial decompositions for C400_10
c400_td1 = mallat1s(c400_10'./1000, 1)';
c400_td2 = mallat1s(c400_10'./1000, 2)';
c400_td3 = mallat1s(c400_10'./1000, 3)';
c400_td4 = mallat1s(c400_10'./1000, 4)';
c400_td5 = mallat1s(c400_10'./1000, 5)';
c400_td6 = mallat1s(c400_10'./1000, 6)';
[c400_rd1 c400_cd1] = mallatrc(c400_10./1000, 1, 1);
[c400_rd2 c400_cd2] = mallatrc(c400_10./1000, 2, 2);
[c400_rd3 c400_cd3] = mallatrc(c400_10./1000, 3, 3);
save c400dec c400_td1 c400_td2 c400_td3 c400_td4 c400_td5 c400_td6 ...
c400_rd1 c400_rd2 c400_rd3 c400_cd1 c400_cd2 c400_cd3