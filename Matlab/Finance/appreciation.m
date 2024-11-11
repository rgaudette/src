%appreciation   Compute the periodic appreciation given a old and new price
%
%  appr_pct = appreciation(old_price, new_price, duration)

function appr_pct = appreciation(old_price, new_price, duration)
appr = 10 .^ (log10(new_price / old_price) / duration);
appr_pct = (appr - 1) * 100;
