function motl = log2motl(logFile)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: log2motl.m,v 1.3 2005/08/15 23:17:36 rickg Exp $\n');
end

fid = fopen(logFile, 'r')
currLine = fgetl(fid);
motl = [];
while ischar(currLine)
  
  if ~ isempty(strfind(currLine, 'Loading particle'))
    idxNumStart = strfind(currLine, '_');
    idxParticle = eval(currLine(idxNumStart+1:idxNumStart+2));
  end
  if ~ isempty(strfind(currLine, 'Max CCC'))
    idxPhiStart = strfind(currLine, 'phi: ');
    numstr = currLine(idxPhiStart+5:idxPhiStart+12);
    [phi cnt errmsg] = sscanf(numstr, '%f', 1);
    if cnt ~= 1
      numstr
      error(errmsg);
    end
    
    idxThetaStart = strfind(currLine, 'theta: ');
    numstr = currLine(idxThetaStart+7:idxThetaStart+14);
    [theta cnt errmsg] = sscanf(numstr, '%f', 1);
    if cnt ~= 1
      numstr
      error(errmsg);
    end
    
    idxPsiStart = strfind(currLine, 'psi: ');
    numstr = currLine(idxPsiStart+5:idxPsiStart+12);
    [psi cnt errmsg] = sscanf(numstr, '%f', 1);
    if cnt ~= 1
      numstr
      error(errmsg);
    end

    idxCCCStart = strfind(currLine, '  CCC ');
    numstr = currLine(idxCCCStart+6:idxCCCStart+14);
    [CCC cnt errmsg] = sscanf(numstr, '%f', 1);
    if cnt ~= 1
      numstr
      error(errmsg);
    end
  end 
  if ~ isempty(strfind(currLine, 'Interpolated shift'))
    numstr = currLine(21:26)
    [dx cnt  errmsg] = sscanf(numstr, '%f', 1);
    if cnt ~= 1
      numstr
      error(errmsg);
    end
      
    numstr = currLine(28:33);
    [dy cnt  errmsg] = sscanf(numstr, '%f', 1);
    if cnt ~= 1
      numstr
      error(errmsg);
    end

    numstr = currLine(35:40);
    [dz cnt  errmsg] = sscanf(numstr, '%f', 1);
    if cnt ~= 1
      numstr
      error(errmsg);
    end

    % Construct the MOTL
    ncol = size(motl, 2)
    motl(:, ncol + 1) = zeros(20,1);
    motl(1, ncol + 1) = CCC;
    motl(4, ncol + 1) = idxParticle;
    motl(11, ncol + 1) = dx;
    motl(12, ncol + 1) = dy;
    motl(13, ncol + 1) = dz;
    motl(17, ncol + 1) = phi;
    motl(18, ncol + 1) = psi;
    motl(19, ncol + 1) = theta;
  end 
    
  currLine = fgetl(fid);
end
fclose(fid);
