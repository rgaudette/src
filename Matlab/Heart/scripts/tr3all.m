%TR3ALL         Run the recovery time estimates for the plaque data

[trec3_atdr0] = trecov3(atdr_0_1, 5);
[trec3_left0] = trecov3(left_0_1, 5);
[trec3_center0] = trecov3(center_0_1, 5);
[trec3_right0] = trecov3(right_0_1, 5);
[trec3_n93] = trecov3(n400_2, 5);
[trec3_e93] = trecov3(e400_3, 5);
[trec3_s93] = trecov3(s400_4, 5);
[trec3_w93] = trecov3(w400_5, 5);
[trec3_c93] = trecov3(c400_10, 5);
[trec3_sv93] = trecov3(sv400_1, 5);

save tr3all trec3_atdr0 trec3_left0 trec3_center0 trec3_right0 trec3_n93 ...
 trec3_e93 trec3_s93 trec3_w93 trec3_c93 trec3_sv93