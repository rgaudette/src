%CMPE

for idxCol = 5:12,
    for idxRow = 5:12,
        velcmp(vel_w, vel_w1, [16 16], [idxRow, idxCol]);
        pause
    end
end