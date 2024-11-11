% showCallArrayPlot(callArray, compID, htmlFName, flgPrint)

function showCallArrayPlot(ca, compID, htmlFName, flgPrint)
%%
%%  Graph parameters
%%
defaultAxesColorOrder = [ 0 0 1; 1 0 0; 0 1 0; 1 0 1];
lineWidth = 2;
if ~strcmp(compID, 'all')
  idxComp = findCellArrayStr(ca.compID, compID);
  if idxComp == 0
    warning(['Can not find:' compID]);
    return
  end
  ca.count =  ca.count(idxComp, :, : ,:, :);
  ca.nCompJoints = ca.nCompJoints(idxComp);
  ca.compID = { ca.compID{idxComp} };
end

nComp = length(ca.compID);
nIndict = length(ca.indictList);
nRes = length(ca.ResList);
nIC = length(ca.ICList);

figIndex = 1;
if flgPrint == 2
  zStep = int2str(ca.zHeight(2) - ca.zHeight(1));
  TOCRefHtml = '<A HREF="#%s">';
  TOCRefTxtHtml = '%s</A><BR>\n';

  htmlAnchor = '<A name="%s">\n';
  htmlGraphBlkTitle = ['<P ALIGN="CENTER"><FONT SIZE=5 COLOR="#000080" ' ...
                    'NAME="ARIAL">%s</FONT><BR>\n'];
  imageRefhtml = '<IMG SRC="%s"><BR>\n';
  htmlSPCPageRef = '<A HREF="%s">';
  htmlSPCPageRefTxt = '%s </A></P><HR>\n';

  htmlEndAnchor = '</A>\n';


  [fidHtml msg] = fopen(['../HTMLResults/' htmlFName ...
                    '_Z' zStep '_CallBreakout.html'], ...
                        'w+');
  if fidHtml == -1
    error(msg);
  end
  strContent = [];

  strTemp = sprintf('<TITLE>%s Call Breakout</TITLE>\n', ...
                    htmlFName);
  strTOC = ['<HTML>\n' strTemp];
  strTemp = sprintf('<P ALIGN="CENTER"><FONT SIZE=6 COLOR="#000000" NAME="ARIAL"><HEAD>%s Call Breakout</HEAD></P><BR>\n', ...
                    htmlFName);
  strTOC = [strTOC strTemp '<P ALIGN="LEFT"><FONT SIZE=3 COLOR="#000080" NAME="ARIAL">\n'];
  
end  

for idxComp = 1:nComp
  nJointsPerParam = ca.nCompJoints(idxComp) / ...
      length(ca.zHeight) / length(ca.FOVList) / ...
      length(ca.ResList) / length(ca.ICList);
  %%
  %%  Add a component anchor for each component
  %%
  if flgPrint == 2
    strTemp = sprintf(htmlAnchor, deblank(ca.compID{idxComp}));
    strContent = [strContent strTemp];        
  end
  
  for idxIndict = 1:nIndict
    indictCnt = getIndictCounts(ca, ca.indictList{idxIndict}, ...
                                    ca.compID{idxComp});
    maxCnt = max(max(max(max(indictCnt))));
    if maxCnt > 0
      figure(figIndex)
      clf
      set(gcf, 'DefaultAxesColorOrder', defaultAxesColorOrder)

      falseAlarm = (indictCnt +1) ./ nJointsPerParam * 1E6;
      for idxRes = 1:nRes
        for idxIC = 1:nIC
          if nRes == 1
            subplot(nIC, 1, idxIC);          
          else
            subplot(nRes, nIC, idxIC + nIC*(idxRes-1));          
          end
          
          semilogy(ca.zHeight, falseAlarm(:,:, idxRes, idxIC), ...
                   'linewidth', lineWidth);
          hold on
          semilogy([min(ca.zHeight) max(ca.zHeight)], ...
                   [1 1] *[1E6/nJointsPerParam], 'k--', ...
                   'linewidth', lineWidth);
          set(gca, 'ylim', [min(1E5, 5E5/nJointsPerParam) 1E6])
          grid
          xlabel('Z offset (mils)')
          ylabel('False Alarm Rate (ppm)');
          title([deblank(ca.compID{idxComp}) ' ' htmlFName ' ' ...
                 fixFileName(ca.indictList{idxIndict}) ...
                 '   RES: ' int2str(ca.ResList(idxRes)) ...
                 ' IC: ' int2str(ca.ICList(idxIC)) ...
                 ' Joints: ' int2str(nJointsPerParam)]);
          legend('400', '650', '800', '850', 0);
        end
      end
      orient landscape
      if flgPrint == 1
        print -dwinc
      end
      
      if flgPrint == 2
        %%
        %%  Concatenate the table of contents HTML
        %%
        strTemp = sprintf(TOCRefHtml, ...
                          [deblank(ca.compID{idxComp}) '_' htmlFName '_' ...
                           fixFileName(ca.indictList{idxIndict})]);
        strTOC = [strTOC strTemp];
        strTemp = sprintf(TOCRefTxtHtml, ...
                          [deblank(ca.compID{idxComp}) '  ' ...
                           fixFileName(ca.indictList{idxIndict})]);
        strTOC = [strTOC strTemp];
        
        %%
        %%  Concatenate the content HTML
        %%
        strTemp = sprintf(htmlAnchor, ...
                          [deblank(ca.compID{idxComp}) '_' htmlFName '_' ...
                           fixFileName(ca.indictList{idxIndict})]);
        strContent = [strContent strTemp];        
        

        strTemp = sprintf(htmlGraphBlkTitle, [deblank(ca.compID{idxComp}) '  ' ...
                    fixFileName(ca.indictList{idxIndict})]);
        strContent = [strContent strTemp];
                          

        strTemp = sprintf(imageRefhtml, ...
                          [deblank(ca.compID{idxComp}) '_' htmlFName '_' ...
                           fixFileName(ca.indictList{idxIndict}) '_Z' zStep '.jpg']);
        strContent = [strContent strTemp];

        strTemp = sprintf(htmlSPCPageRef, ...
                          [deblank(ca.compID{idxComp}) '_Z' zStep ...
                           '_SPCStats.html']);
        strContent = [strContent strTemp];

        strTemp = sprintf(htmlSPCPageRefTxt, ...
                          [deblank(ca.compID{idxComp}) ' SPC Statistics']);
        strContent = [strContent strTemp htmlEndAnchor];
        
        print('-djpeg95', '-r100', ...
              ['../HTMLResults/' deblank(ca.compID{idxComp}) '_' htmlFName '_' ...
               fixFileName(ca.indictList{idxIndict}) '_Z' zStep '.jpg' ]);
      end
      
      figIndex = figIndex + 1;
    end
  
  end

end

if flgPrint == 2
  fprintf(fidHtml, [strTOC '<HR>']);
  fprintf(fidHtml, strContent);  
  fprintf(fidHtml, '<HTML>\n');
  fclose(fidHtml);
end

function badName = fixFileName(badName)
%%
%%  Remove colons
%%
idxColon = findstr(badName, ':');
if ~isempty(idxColon)
  badName(idxColon) = '-';
end

%%
%%  Remove line feeds
%%
idxLF = findstr(badName, char(13));
if ~isempty(idxLF)
  badName(idxLF) = '-';
end
