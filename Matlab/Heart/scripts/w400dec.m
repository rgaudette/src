%W400DEC        Compute both temporal & spatial decompositions for W400_5
w400_td1 = mallat1s(w400_5'./1000, 1)';
w400_td2 = mallat1s(w400_5'./1000, 2)';
w400_td3 = mallat1s(w400_5'./1000, 3)';
w400_td4 = mallat1s(w400_5'./1000, 4)';
w400_td5 = mallat1s(w400_5'./1000, 5)';
w400_td6 = mallat1s(w400_5'./1000, 6)';
[w400_rd1 w400_cd1] = mallatrc(w400_5./1000, 1, 1);
[w400_rd2 w400_cd2] = mallatrc(w400_5./1000, 2, 2);
[w400_rd3 w400_cd3] = mallatrc(w400_5./1000, 3, 3);
save w400dec w400_td1 w400_td2 w400_td3 w400_td4 w400_td5 w400_td6 ...
w400_rd1 w400_rd2 w400_rd3 w400_cd1 w400_cd2 w400_cd3