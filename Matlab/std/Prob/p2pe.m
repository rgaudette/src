%P2PE

function pe = p2pe(alpha)
%pe = qfct(alpha);
pe = 0.25 * qfct(1.5 * alpha) + 0.5 * qfct(alpha) + 0.25 * qfct(alpha);

