%CMPE

for idxCol = 5:12,
    for idxRow = 5:12,
        velcmp(vel_e, vel_e1, [16 16], [idxRow, idxCol]);
        pause
    end
end