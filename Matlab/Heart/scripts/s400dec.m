%S400DEC        Compute both temporal & spatial decompositions for S400_4
s400_td1 = mallat1s(s400_4'./1000, 1)';
s400_td2 = mallat1s(s400_4'./1000, 2)';
s400_td3 = mallat1s(s400_4'./1000, 3)';
s400_td4 = mallat1s(s400_4'./1000, 4)';
s400_td5 = mallat1s(s400_4'./1000, 5)';
s400_td6 = mallat1s(s400_4'./1000, 6)';
[s400_rd1 s400_cd1] = mallatrc(s400_4./1000, 1, 1);
[s400_rd2 s400_cd2] = mallatrc(s400_4./1000, 2, 2);
[s400_rd3 s400_cd3] = mallatrc(s400_4./1000, 3, 3);
save s400dec s400_td1 s400_td2 s400_td3 s400_td4 s400_td5 s400_td6 ...
s400_rd1 s400_rd2 s400_rd3 s400_cd1 s400_cd2 s400_cd3