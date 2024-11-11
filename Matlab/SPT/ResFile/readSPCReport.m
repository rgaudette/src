%readSPCReport  Read in an SPC report into an array of SPC structures.
%
%  compArray = readSPCReport(filename)
%
%  compArray    An array of component structures containing the SPC data for
%               each component in the SPC data file.
%
%  filename     The name of the SPC data file generaterd from spcrpt.exe.

function compArray = readSPCReport(filename)

[fid msg] = fopen(filename, 'r');

%%
%%  Open the SPC report file
%%
if fid == -1
  disp(msg)
  error(['Unable to open: ' filename]);
end
idxComp = 1;

%%
%%  Parse each line of the header section
%%
currLine = fgetl(fid);
while currLine ~= -1
  [name value] = strtok(currLine, ':');
  switch name
   case 'Component',
    currComp.name = value(3:end);
   
   case 'Layer',
    currComp.layer = value(3:end);
   
   case 'Algorithm Name',
    currComp.family = value(3:end);
   
   case 'Subtype',
    currComp.subtype = value(3:end);
   
   case 'Pins',
    currComp.nPins = eval(value(3:end));
    try
      %%
      %%  Read in and parse the measurement description line
      %%
      currComp.measDesc = getMeasDescLine(fid);
      
      %%
      %%  Read in and parse all of the measurement vectors
      %%
      if strcmp(currComp.family, 'BGA2')
        currComp.measDesc(1) = [];
        currComp.measVec = getBGA2MeasVecs(fid, currComp.nPins, ...
                                                length(currComp.measDesc));
      else
      currComp.measVec = ...
          getMeasVecs(fid, currComp.nPins, length(currComp.measDesc));
      end
      %%
      %%  Append the current component on to the end of the component array
      %%
      compArray(idxComp) = currComp;
      idxComp = idxComp + 1;    
    
    catch
      disp(['Current component: ' currComp.name])
      error(lasterr);
    end
   
   otherwise,    
    %%
    %%  Unknown key in the .SPC file
    %%
    disp(['Key: ' name]);
    disp(['Value: ' value]);
    error(['Unknown key in: ' filename])
  end
  
  currLine = fgetl(fid);
end

%%
%%  Close the SPC Report file
%%
fclose(fid);


%%
%%  Parse the measurement description into a cell array of strings.
%%  the description line is expected to be a comm separated sequence of
%%  strings
%%
function measDesc = getMeasDescLine(fid)

%%
%% Read in the current line
%%
currLine = fgetl(fid);
if currLine == -1
  error('Measurement description is missing');
end

[pinNumText restOfLine] = strtok(currLine, ',');
if ~strcmp(pinNumText, 'Pin #')
  error('Measurement description line not in expected format: didn''t find Pin#');
end

idxDesc = 1;
while ~isempty(restOfLine)
  [name restOfLine] = strtok(restOfLine(3:end), ',');
  measDesc{idxDesc} = strjust(name, 'left');
  idxDesc = idxDesc + 1;
end


%%
%%  load in the measurement vectors for the current component
%%
function measVecs = getMeasVecs(fid, nPins, nMeas)
measVecs = zeros(nPins, nMeas);

for idxPin = 1:nPins
  fullLine = fscanf(fid, '%f,');
  if length(fullLine) ~= nMeas+1
    error('Measurement vector line is incorrect');
  end
  measVecs(idxPin, :) = fullLine(2:end)';
  %%
  %%  Get the trailing linefeed, otherwise the main loop fgetl will return
  %%  an empty string and exit
  %%
  fgetl(fid);
end

%%
%%  load in the measurement vectors for the current BGA2 component
%%
function measVecs = getBGA2MeasVecs(fid, nPins, nMeas)

nSlices = 1;
nSlicesMax = 10;
%%
%%  An ugly way to do it, need to figure out how many slices are actually
%%  measured before reading the SPC data
%%
measVecs = zeros(nPins, nMeas, nSlicesMax);

nLines = nSlices * nPins;
idxLine = 1;
while idxLine <= nLines
  fullLine = fscanf(fid, '%f,');
  if length(fullLine) ~= nMeas+2
    error(['Measurement vector line is incorrect. Component SPC block line ' ...
           int2str(idxLine)]);
  end
  idxPin = fullLine(1);
  idxSlice = fullLine(2);
  if idxSlice > nSlices
    nSlices = idxSlice;
    nLines = nSlices * nPins
  end
  
  measVecs(idxPin, :, idxSlice) = fullLine(3:end)';

  %%
  %%  Get the trailing linefeed, otherwise the main loop fgetl will return
  %%  an empty string and exit
  %%
  fgetl(fid);
  idxLine = idxLine +1;
end

%%
%%  Resize the measVecs array to contain only the slices that were present in
%%  the file.
%%
measVecs = measVecs(:, :, 1:nSlices);
