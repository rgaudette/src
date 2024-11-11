%E400DEC        Compute both temporal & spatial decompositions for E400_3
e400_td1 = mallat1s(e400_3'./1000, 1)';
e400_td2 = mallat1s(e400_3'./1000, 2)';
e400_td3 = mallat1s(e400_3'./1000, 3)';
e400_td4 = mallat1s(e400_3'./1000, 4)';
e400_td5 = mallat1s(e400_3'./1000, 5)';
e400_td6 = mallat1s(e400_3'./1000, 6)';
[e400_rd1 e400_cd1] = mallatrc(e400_3./1000, 1, 1);
[e400_rd2 e400_cd2] = mallatrc(e400_3./1000, 2, 2);
[e400_rd3 e400_cd3] = mallatrc(e400_3./1000, 3, 3);
save e400dec e400_td1 e400_td2 e400_td3 e400_td4 e400_td5 e400_td6 ...
e400_rd1 e400_rd2 e400_rd3 e400_cd1 e400_cd2 e400_cd3