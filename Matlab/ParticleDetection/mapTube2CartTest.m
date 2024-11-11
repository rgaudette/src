[d1_mt1_pts] = mapCart2Tube(mt1, ax6D1pts);
est = mapTube2Cart(mt1, d1_mt1_pts);

diffNorm = sqrt(sum((ax6D1pts - est) .^2, 2))


[d2_mt2_pts] = mapCart2Tube(mt2, ax6D2pts);
est = mapTube2Cart(mt2, d2_mt2_pts);

diffNorm = sqrt(sum((ax6D2pts - est) .^2, 2))

[d3_mt3_pts] = mapCart2Tube(mt3, ax6D3pts);
est = mapTube2Cart(mt3, d3_mt3_pts);

diffNorm = sqrt(sum((ax6D3pts - est) .^2, 2))

[d4_mt4_pts] = mapCart2Tube(mt4, ax6D4pts);
est = mapTube2Cart(mt4, d4_mt4_pts);

diffNorm = sqrt(sum((ax6D4pts - est) .^2, 2))

[d5_mt5_pts] = mapCart2Tube(mt5, ax6D5pts);
est = mapTube2Cart(mt5, d5_mt5_pts);

diffNorm = sqrt(sum((ax6D5pts - est) .^2, 2))

[d6_mt6_pts] = mapCart2Tube(mt6, ax6D6pts);
est = mapTube2Cart(mt6, d6_mt6_pts);

diffNorm = sqrt(sum((ax6D6pts - est) .^2, 2))

[d7_mt7_pts] = mapCart2Tube(mt7, ax6D7pts);
est = mapTube2Cart(mt7, d7_mt7_pts);

diffNorm = sqrt(sum((ax6D7pts - est) .^2, 2))

[d8_mt8_pts] = mapCart2Tube(mt8, ax6D8pts);
est = mapTube2Cart(mt8, d8_mt8_pts);

diffNorm = sqrt(sum((ax6D8pts - est) .^2, 2))

[d9_mt9_pts] = mapCart2Tube(mt9, ax6D9pts);
est = mapTube2Cart(mt9, d9_mt9_pts);

diffNorm = sqrt(sum((ax6D9pts - est) .^2, 2))
