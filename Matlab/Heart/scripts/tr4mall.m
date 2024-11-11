%TR4MALL        Run the recovery time estimates for the plaque data

[trec_atdr0] = trecov4m(atdr_0_1, 5);
[trec_left0] = trecov4m(left_0_1, 5);
[trec_center0] = trecov4m(center_0_1, 5);
[trec_right0] = trecov4m(right_0_1, 5);
[trec_n93] = trecov4m(n400_2, 5);
[trec_e93] = trecov4m(e400_3, 5);
[trec_s93] = trecov4m(s400_4, 5);
[trec_w93] = trecov4m(w400_5, 5);
[trec_c93] = trecov4m(c400_10, 5);
[trec_sv93] = trecov4m(sv400_1, 5);

save tr4mall trec_atdr0 trec_left0 trec_center0 trec_right0 trec_n93 ...
 trec_e93 trec_s93 trec_w93 trec_c93 trec_sv93