%TACTALL        Run the activation estimates for the plaque data

[tact_atdr0] = tactiv(atdr_0_1);
[tact_left0] = tactiv(left_0_1);
[tact_center0] = tactiv(center_0_1);
[tact_right0] = tactiv(right_0_1);
[tact_n93] = tactiv(n400_2);
[tact_e93] = tactiv(e400_3);
[tact_s93] = tactiv(s400_4);
[tact_w93] = tactiv(w400_5);
[tact_c93] = tactiv(c400_10);
[tact_sv93] = tactiv(sv400_1);

save tactall tact_atdr0 tact_left0 tact_center0 tact_right0 tact_n93 ...
 tact_e93 tact_s93 tact_w93 tact_c93 tact_sv93