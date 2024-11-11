for idxFile = 10:23
clear mAOA varAOA
strFileNum = sprintf('%02.0f', idxFile);
for idxCPI = 1:15
    strCPINum = sprintf('%02.0f', idxCPI);
    eval(['[mn var]=angle_stat(mus_spec_' strFileNum '_' ...
	strCPINum ', theta);']);

    if length(mn) == 1,
	mAOA(idxCPI,:) = [mn NaN];
    else
	mAOA(idxCPI,:) = mn;
    end
    if length(var) == 1,
	varAOA(idxCPI,:) = [var NaN];
    else
	varAOA(idxCPI,:) = var;
    end
end

    subplot(211)
    plot(mAOA(:,1), 'o');
    axis([0 15 -5 15])
    hold on
    plot(mAOA(:,2), 'x');
    xlabel('CPI Index');
    ylabel('AOA estimate mean');
    title(['Jamr00' strFileNum ': AOA Estimate vs. CPI #']);
    grid
    hold off

    subplot(212);
    plot(sqrt(varAOA(:,1)), 'o');
    axis([0 15 0  0.1])
    hold on
    plot(sqrt(varAOA(:,2)), 'x');
    xlabel('CPI Index');
    ylabel('AOA standard deviation');
    title(['Jamr00' strFileNum ': AOA Standard Deviation vs. CPI #']);
    grid
    hold off
    orient landscape 
    print
end
