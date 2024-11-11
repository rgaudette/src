function [mean_angle, var] = angle_stat(mus_spec, theta)
% Compute mean and variance of music spectrum angle estimate
 
[junk NSamp] = size(mus_spec);

Src1 = [];
Src2 = [];

for idxSamp = 1:NSamp,
    [PkVal idxPk] = peak_srch(mus_spec(:, idxSamp));
    Peaks = theta(idxPk);
    if length(Peaks) > 2,
	disp('WARNING: found more than two peaks');
    end
    for idxSrc = 1:length(Peaks),
        if idxSrc > 2, break; end
	eval(['Src' int2str(idxSrc) '=[ Src' int2str(idxSrc) ...
	    '; Peaks(idxSrc)];']);
    end
    mean_angle = [mean(Src1) mean(Src2)];
    var = [cov(Src1) cov(Src2)];
end