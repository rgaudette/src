% showTotalFAPlot(callArray, compID, titleText, plotText, flgPrint)

function showTotalFAPlot(tca, compID, titleText, plotText, flgPrint)
%%
%%  Graph parameters
%%
defaultAxesColorOrder = [ 0 0 1; 1 0 0; 0 1 0; 1 0 1];
lineWidth = 2;
if ~strcmp(compID, 'all')
  idxComp = findCellArrayStr(tca.compID, compID);
  if idxComp == 0
    warning(['Can not find:' compID]);
    return
  end
  tca.count =  tca.count(idxComp, :, : ,:, :);
  tca.nCompJoints = tca.nCompJoints(idxComp);
  tca.compID = tca.compID(idxComp);
end


nComp = length(tca.compID);
nRes = length(tca.ResList);
nIC = length(tca.ICList);
if length(plotText) ~= nComp
  error('Plot text must have a cell for each component');
end

figIndex = 1;
if flgPrint == 2
  zStep = int2str(tca.zHeight(2) - tca.zHeight(1));
  TOCRefHtml = '<A HREF="#%s">';
  TOCRefTxtHtml = '%s</A><BR>\n';

  htmlAnchor = '<A name="%s">\n';
  htmlGraphBlkTitle = ['<P ALIGN="CENTER"><FONT SIZE=5 COLOR="#000080" ' ...
                    'NAME="ARIAL">%s</FONT><BR>\n'];
  imageRefhtml = '<IMG SRC="%s"><BR>\n';

  htmlPageRef = '<A HREF="%s#%s">';
  htmlPageRefTxt = '%s </A>\n';

  htmlEndAnchor = '</A>\n';


  [fidHtml msg] = fopen(['../HTMLResults/' titleText ...
                    '_Z' zStep '_FalseAlarm.html'], 'w+');
  if fidHtml == -1
    error(msg);
  end
  strContent = [];

  strTemp = sprintf('<TITLE>%s False Alarm Rate</TITLE>\n', ...
                    [titleText ' dz = ' zStep]);
  strTOC = ['<HTML>\n' strTemp];
  strTemp = sprintf('<P ALIGN="CENTER"><FONT SIZE=6 COLOR="#000000" NAME="ARIAL">%s False Alarm Rate</P><BR>\n', ...
                    [titleText ' dz = ' zStep]);
  strTOC = [strTOC strTemp '<P ALIGN="LEFT"><FONT SIZE=3 COLOR="#000080" NAME="ARIAL">\n'];

end  

for idxComp = 1:nComp
  compID = tca.compID(idxComp);
  nJointsPerParam = tca.nCompJoints(idxComp) / length(tca.zHeight) ...
      / length(tca.FOVList) / length(tca.ResList) / ...
      length(tca.ICList)
  calls = getTotalFA(tca, compID)+1;
  
  figure(figIndex)
  clf
  set(gcf, 'DefaultAxesColorOrder', defaultAxesColorOrder)

  for idxRes = 1:nRes
    for idxIC = 1:nIC
      if nRes == 1
        subplot(nIC, 1, idxIC);          
      else
        subplot(nRes, nIC, idxIC + nIC*(idxRes-1));          
      end
      semilogy(tca.zHeight, ...
               calls(:,:, idxRes, idxIC) ./ nJointsPerParam * 1E6, ...
               'linewidth', lineWidth);
      hold on
      semilogy([min(tca.zHeight) max(tca.zHeight)], ...
               [1 1] *[1E6/nJointsPerParam], 'k--', ...
               'linewidth', lineWidth);
      set(gca, 'ylim', [min(1E5, 5E5/nJointsPerParam) 1E6])
%      set(gca, 'ylim', [1E5 1E6])
      grid
      xlabel('Z offset (mils)')
      ylabel('False Alarm Rate (ppm)');
      title([tca.compID{idxComp} ' ' titleText ' ' ...
             '   RES: ' int2str(tca.ResList(idxRes)) ...
             ' IC: ' int2str(tca.ICList(idxIC)) ...
             ' Joints: ' int2str(nJointsPerParam)]);
      lgndArgs = [];
      for iFOV = 1:length(tca.FOVList)
        lgndArgs = [lgndArgs, '''' int2str(tca.FOVList(iFOV)) ''','];
      end
      eval(['legend( ' lgndArgs '0);']);
    end
  end
  orient landscape
  if flgPrint == 2
    %%
    %%  Concatenate the table of contents HTML
    %%
    strTemp = sprintf(TOCRefHtml, tca.compID{idxComp});
    strTOC = [strTOC strTemp];
    strTemp = sprintf(TOCRefTxtHtml, [tca.compID{idxComp} ' ' plotText{idxComp}]);
    strTOC = [strTOC strTemp];
        
    %%
    %%  Concatenate the content HTML
    %%
    strTemp = sprintf(htmlAnchor, tca.compID{idxComp});
    strContent = [strContent strTemp];        
        

    strTemp = sprintf(htmlGraphBlkTitle, [tca.compID{idxComp}  ' ' ...
                    plotText{idxComp}]);
    strContent = [strContent strTemp];
                          

    strTemp = sprintf(imageRefhtml, ...
                      [tca.compID{idxComp} '_Z' zStep '.jpg']);
    strContent = [strContent strTemp];

    %%
    %%  Call breakout link
    %%
    strTemp = sprintf(htmlPageRef, ...
                      [titleText '_Z' zStep '_CallBreakout.html'], ...
                      tca.compID{idxComp});
    strContent = [strContent strTemp];

    strTemp = sprintf(htmlPageRefTxt, ...
                      [tca.compID{idxComp} ' Call Breakout']);
    strContent = [strContent strTemp htmlEndAnchor '<BR>' ];

    %%
    %%  SPC link
    %%
    strTemp = sprintf(htmlPageRef, ...
                      [tca.compID{idxComp} '_Z' zStep '_SPCStats.html'], ...
                      '');
    strContent = [strContent strTemp];

    strTemp = sprintf(htmlPageRefTxt, ...
                      [tca.compID{idxComp} ' SPC Data']);
    strContent = [strContent strTemp htmlEndAnchor '</P><HR>'];
    
    print('-djpeg95', '-r100', ...
          ['../HTMLResults/' tca.compID{idxComp} '_Z' zStep '.jpg' ]);
  end
  figIndex = figIndex + 1;
end

if flgPrint == 2
  fprintf(fidHtml, [strTOC '<HR>']);
  fprintf(fidHtml, strContent);  
  fprintf(fidHtml, '<HTML>\n');
  fclose(fidHtml);
end
