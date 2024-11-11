function mti = mtiproc(cpi, wrecord)

pulses = length(cpi) / wrecord

for idxPulse = 2:pulses,
    left = (idxPulse - 1) * wrecord + 1 : idxPulse * wrecord;
    right = left - wrecord;

    mti(:,idxPulse) = cpi(left) - cpi(right);
end
