%TR3MALL        Run the recovery time estimates for the plaque data

[trec3m_atdr0] = trecov3m(atdr_0_1, 5);
[trec3m_left0] = trecov3m(left_0_1, 5);
[trec3m_center0] = trecov3m(center_0_1, 5);
[trec3m_right0] = trecov3m(right_0_1, 5);
[trec3m_n93] = trecov3m(n400_2, 5);
[trec3m_e93] = trecov3m(e400_3, 5);
[trec3m_s93] = trecov3m(s400_4, 5);
[trec3m_w93] = trecov3m(w400_5, 5);
[trec3m_c93] = trecov3m(c400_10, 5);
[trec3m_sv93] = trecov3m(sv400_1, 5);

save tr3mall trec3m_atdr0 trec3m_left0 trec3m_center0 trec3m_right0 trec3m_n93 ...
 trec3m_e93 trec3m_s93 trec3m_w93 trec3m_c93 trec3m_sv93