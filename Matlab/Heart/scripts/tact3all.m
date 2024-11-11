%TACT3ALL       Run the activation estimates for the plaque data

[tact3_atdr0] = tactiv3(atdr_0_1, 5);
[tact3_left0] = tactiv3(left_0_1, 5);
[tact3_center0] = tactiv3(center_0_1, 5);
[tact3_right0] = tactiv3(right_0_1, 5);
[tact3_n93] = tactiv3(n400_2, 5);
[tact3_e93] = tactiv3(e400_3, 5);
[tact3_s93] = tactiv3(s400_4, 5);
[tact3_w93] = tactiv3(w400_5, 5);
[tact3_c93] = tactiv3(c400_10, 5);
[tact3_sv93] = tactiv3(sv400_1, 5);

save tact3all tact3_atdr0 tact3_left0 tact3_center0 tact3_right0 tact3_n93 ...
 tact3_e93 tact3_s93 tact3_w93 tact3_c93 tact3_sv93