%N400DEC        Compute both temporal & spatial decompositions for N400_2
n400_td1 = mallat1s(n400_2'./1000, 1)';
n400_td2 = mallat1s(n400_2'./1000, 2)';
n400_td3 = mallat1s(n400_2'./1000, 3)';
n400_td4 = mallat1s(n400_2'./1000, 4)';
n400_td5 = mallat1s(n400_2'./1000, 5)';
n400_td6 = mallat1s(n400_2'./1000, 6)';
[n400_rd1 n400_cd1] = mallatrc(n400_2./1000, 1, 1);
[n400_rd2 n400_cd2] = mallatrc(n400_2./1000, 2, 2);
[n400_rd3 n400_cd3] = mallatrc(n400_2./1000, 3, 3);
save n400dec n400_td1 n400_td2 n400_td3 n400_td4 n400_td5 n400_td6 ...
n400_rd1 n400_rd2 n400_rd3 n400_cd1 n400_cd2 n400_cd3