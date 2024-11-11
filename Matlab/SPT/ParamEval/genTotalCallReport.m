%totalCallReport    Generate the total call report from a group of call reports.
%
%   totalCallReport = genCallReportZ2(resFileList, type, measParam)

function totalCallReport = genTotalCallReport(resFileList, type, measParam)

totalCallReport = [];

nFiles = length(resFileList);
for iFile  = 1:nFiles
  disp(resFileList{iFile})
  totalCallReport = totalCallClass([resFileList{iFile} '_' type '.rpt'], ...
                                   totalCallReport, measParam);
end
