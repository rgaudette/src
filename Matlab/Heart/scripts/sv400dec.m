%SV400DEC       Compute both temporal & spatial decompositions for SV400_1
sv400_td1 = mallat1s(sv400_1'./1000, 1)';
sv400_td2 = mallat1s(sv400_1'./1000, 2)';
sv400_td3 = mallat1s(sv400_1'./1000, 3)';
sv400_td4 = mallat1s(sv400_1'./1000, 4)';
sv400_td5 = mallat1s(sv400_1'./1000, 5)';
sv400_td6 = mallat1s(sv400_1'./1000, 6)';
[sv400_rd1 sv400_cd1] = mallatrc(sv400_1./1000, 1, 1);
[sv400_rd2 sv400_cd2] = mallatrc(sv400_1./1000, 2, 2);
[sv400_rd3 sv400_cd3] = mallatrc(sv400_1./1000, 3, 3);
save sv400dec sv400_td1 sv400_td2 sv400_td3 sv400_td4 sv400_td5 sv400_td6 ...
sv400_rd1 sv400_rd2 sv400_rd3 sv400_cd1 sv400_cd2 sv400_cd3