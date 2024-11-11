%PRINTPMI       Print out the parameters in a PMI structure
%
%   printpmi(pmi, fname)
%
%   pmi         The PMI data structure to print out.
%
%   fname       OPTIONAL: The name of the file to print the PMI structure out
%               to, it will append if the file already exists.  The default
%               is to write to the screen.
%
%   PRINTPMI prints out the parameters in a PMI data struture and the sizes
%   of data objects.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:27:29 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: printpmi.m,v $
%  Revision 1.1.1.1  2004/01/03 08:27:29  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function printpmi(pmi, fname)

if nargin > 1
    [fid msg] = fopen(fname, 'a');
    if fid < 0
        error(msg)
    end
else
    fid = 1;
end

fprintf(fid, 'PMI Data Structure version:\t%0.2f\n', pmi.Version);
fprintf(fid, 'PMI Debug value:\t\t%d\n', pmi.Debug);
fprintf(fid, '\n');
%%
%%  Print out the forward model structure
%%
fprintf(fid, 'Forward Model Information\n');
fprintf(fid, ...
    '======================================================================\n');
if isfield(pmi, 'Fwd')
    fprintf(fid, 'Index of refraction:\t\t');
    if isfield(pmi.Fwd, 'idxRefr')
        nParam = length(pmi.Fwd.idxRefr);
        for iParam = 1:nParam
            fprintf(fid, '%f\t', pmi.Fwd.idxRefr(iParam));    
        end
    else
        fprintf(fid, 'Not available\n');
    end
    fprintf(fid, '\n');

    fprintf(fid, 'Propagation velocity (cm/s):\t');
    if isfield(pmi.Fwd, 'v')
        nParam = length(pmi.Fwd.v);
        for iParam = 1:nParam
            fprintf(fid, '%e\t', pmi.Fwd.v(iParam));    
        end
    else
        fprintf(fid, 'Not available\n');
    end
    fprintf(fid, '\n');

    fprintf(fid, 'Mean cosine:\t\t\t');
    if isfield(pmi.Fwd, 'g')
        nParam = length(pmi.Fwd.g);
        for iParam = 1:nParam
            fprintf(fid, '%f\t', pmi.Fwd.g(iParam));    
        end
    else
        fprintf(fid, 'Not available\n');
    end
    fprintf(fid, '\n');

    fprintf(fid, 'Scattering coef. (cm^-1):\t');
    if isfield(pmi.Fwd, 'Mu_s')
        nParam = length(pmi.Fwd.Mu_s);
        for iParam = 1:nParam
            fprintf(fid, '%f\t', pmi.Fwd.Mu_s(iParam));
        end
    else
        fprintf(fid, 'Not available\n');
    end
    fprintf(fid, '\n');

    fprintf(fid, 'Reduced scat. coef. (cm^-1):\t');
    if isfield(pmi.Fwd, 'Mu_sp')
        nParam = length(pmi.Fwd.Mu_sp);
        for iParam = 1:nParam
            fprintf(fid, '%f\t', pmi.Fwd.Mu_sp(iParam));
        end
    else
        fprintf(fid, 'Not available\n');
    end
    fprintf(fid, '\n');

    fprintf(fid, 'Absorption coef. (cm^-1):\t');
    if isfield(pmi.Fwd, 'Mu_a')
        nParam = length(pmi.Fwd.Mu_a);
        for iParam = 1:nParam
            fprintf(fid, '%f\t', pmi.Fwd.Mu_a(iParam));
        end
    else
        fprintf(fid, 'Not available\n');
    end
    fprintf(fid, '\n');

    fprintf(fid, 'Chromophores:        Concentration    mu_a\n');
    fprintf(fid, ...
        '----------------------------------------------------------------------\n');
    if isfield(pmi.Fwd, 'Cphore')
        nCphore = size(pmi.Fwd.Cphore)
        for iCphore = 1:nCphore
            fprintf(fid, '%s\t%f\t%f\n', ...
                pmi.Fwd.Cphore(iCphore).Name, ...
                pmi.Fwd.Cphore(iCphore).Conc, ...
                pmi.Fwd.Cphore(iCphore).Mu_a);
        end
    else
        fprintf(fid, 'Not available\n');
    end
    fprintf(fid, '\n');
    
    fprintf(fid, 'Wavelength (nm):\t\t');
    if isfield(pmi.Fwd, 'Lambda')
        nParam = length(pmi.Fwd.Lambda);
        for iParam = 1:nParam
            fprintf(fid, '%d\t\t', pmi.Fwd.Lambda(iParam));    
        end
    else
        fprintf(fid, 'Not available\n');
    end
    fprintf(fid, '\n');

    fprintf(fid, 'Modulation frequency (MHz):\t');
    if isfield(pmi.Fwd, 'ModFreq')
        nParam = length(pmi.Fwd.ModFreq);
        for iParam = 1:nParam
            fprintf(fid, '%f\t', pmi.Fwd.ModFreq(iParam));
        end
    else
        fprintf(fid, 'Not available\n');
    end
    fprintf(fid, '\n');
    fprintf(fid, 'Number of measurements:\t\t');
    if isfield(pmi.Fwd, 'MeasList');
        fprintf(fid, '%d\n', size(pmi.Fwd.MeasList, 1));
    else
        fprintf(fid, 'Not available\n');
    end
    fprintf(fid, '\n');

    fprintf(fid, 'Source optodes\n ');
    fprintf(fid, ...
        '----------------------------------------------------------------------\n');
    if isfield(pmi.Fwd, 'Src')
        fprintf(fid, 'Type:\t%s\n', pmi.Fwd.Src.Type);
        if strcmp(pmi.Fwd.Src.Type, 'uniform')
            fprintf(fid, 'X positions (cm): ')
            fprintf(fid, '%f\t', pmi.Fwd.Src.X)
            fprintf(fid, '\n');

            fprintf(fid, 'Y positions (cm): ')
            fprintf(fid, '%f\t', pmi.Fwd.Src.Y)
            fprintf(fid, '\n');

            fprintf(fid, 'Z positions (cm): ')
            fprintf(fid, '%f\t', pmi.Fwd.Src.Z)
            fprintf(fid, '\n');
            
        else
            nSrc = size(pmi.Fwd.Src.Pos, 1);
            fprintf(fid, 'Source positions (cm):\n');
            for iSrc = 1:nSrc
                fprintf(fid, '\t%0.2f\t%0.2f\t%0.2f\n', ...
                    pmi.Fwd.Src.Pos(iSrc,1), ...
                    pmi.Fwd.Src.Pos(iSrc,2),  ...
                    pmi.Fwd.Src.Pos(iSrc,3));
            end
        end
        nSrc = size(pmi.Fwd.Src.Normal);
        fprintf(fid, 'Normal vector:\n');
        for iSrc = 1:nSrc
            fprintf(fid, '\t%0.2f\t%0.2f\t%0.2f\n', ...
                pmi.Fwd.Src.Normal(iSrc,1), ...
                pmi.Fwd.Src.Normal(iSrc,2),  ...
                pmi.Fwd.Src.Normal(iSrc,3));
        end
        fprintf(fid, 'Amplitude:          ');
        fprintf(fid,'  %0.2f', pmi.Fwd.Src.Amplitude);
        fprintf(fid, '\n');
        fprintf(fid, 'Numerical aperature:');
        fprintf(fid,'  %0.2f', pmi.Fwd.Src.Amplitude);
        fprintf(fid, '\n');

    else
        fprintf(fid, 'Not available\n');
    end
    fprintf(fid, '\n');

    fprintf(fid, 'Detector optodes\n ');
    fprintf(fid, ...
        '----------------------------------------------------------------------\n');
    if isfield(pmi.Fwd, 'Det')
        fprintf(fid, 'Type:\t%s\n', pmi.Fwd.Det.Type);
        if strcmp(pmi.Fwd.Det.Type, 'uniform')
            fprintf(fid, 'X positions (cm): ')
            fprintf(fid, '%f\t', pmi.Fwd.Det.X)
            fprintf(fid, '\n');

            fprintf(fid, 'Y positions (cm): ')
            fprintf(fid, '%f\t', pmi.Fwd.Det.Y)
            fprintf(fid, '\n');

            fprintf(fid, 'Z positions (cm): ')
            fprintf(fid, '%f\t', pmi.Fwd.Det.Z)
            fprintf(fid, '\n');
            
        else
            nDet = size(pmi.Fwd.Det.Pos, 1);
            fprintf(fid, 'Detector positions (cm):\n');
            for iDet = 1:nDet
                fprintf(fid, '\t%0.2f\t%0.2f\t%0.2f\n', ...
                    pmi.Fwd.Det.Pos(iDet,1), ...
                    pmi.Fwd.Det.Pos(iDet,2),  ...
                    pmi.Fwd.Det.Pos(iDet,3));
            end
        end
        nDet = size(pmi.Fwd.Det.Normal);
        fprintf(fid, 'Normal vector:\n');
        for iDet = 1:nDet
            fprintf(fid, '\t%0.2f\t%0.2f\t%0.2f\n', ...
                pmi.Fwd.Det.Normal(iDet,1), ...
                pmi.Fwd.Det.Normal(iDet,2),  ...
                pmi.Fwd.Det.Normal(iDet,3));
        end
        fprintf(fid, 'Efficiency:          ');
        fprintf(fid,'  %0.2f', pmi.Fwd.Det.Amplitude);
        fprintf(fid, '\n');
        fprintf(fid, 'Numerical aperature:');
        fprintf(fid,'  %0.2f', pmi.Fwd.Det.Amplitude);
        fprintf(fid, '\n');

    else
        fprintf(fid, 'Not available\n');
    end
    fprintf(fid, '\n');

    fprintf(fid, 'Medium boundary geometry:\t');
    if isfield(pmi.Fwd, 'Boundary');
        fprintf(fid, '%s', pmi.Fwd.Boundary.Geometry);
        if strcmp(pmi.Fwd.Boundary.Geometry, 'Slab')
            fprintf(fid, '  %f cm\n', pmi.Fwd.Boundary.Thinkness);
        else
            fprintf(fid, '\n');
        end
    else
        fprintf(fid, 'Not available\n');    
    end
    fprintf(fid, 'Computational method:\t\t');
    if isfield(pmi.Fwd, 'Method')
        fprintf(fid, '%s', pmi.Fwd.Method.Type);
        if strcmp(pmi.Fwd.Method.Type, 'Born') | ...
                strcmp(pmi.Fwd.Method.Type, 'Spherical');
            fprintf(fid, '  order: %d\n', pmi.Fwd.Method.Order);
        elseif strcmp(pmi.Fwd.Method.Type, 'Matlab Var')
            fprintf(fid, '  %s\n', pmi.Fwd.Method.MatlabVarName);
        end
        fprintf(fid, '\n');
    else
        fprintf(fid, 'Not available\n');    
    end

    fprintf(fid, 'Computational volume\n ');
    fprintf(fid, ...
        '----------------------------------------------------------------------\n');
    if isfield(pmi.Fwd, 'CompVol')
        fprintf(fid, 'Type :  %s\n', pmi.Fwd.CompVol.Type);
        if strcmp('uniform',pmi.Fwd.CompVol.Type)
            fprintf(fid, ...
                'Min X: %+0.2f   Max X: %+0.2f  Step: %+0.2f   Count %d\n', ...
                min(pmi.Fwd.CompVol.X), max(pmi.Fwd.CompVol.X), ...
                pmi.Fwd.CompVol.XStep, length(pmi.Fwd.CompVol.X));
            fprintf(fid, ...
                'Min Y: %+0.2f   Max Y: %+0.2f  Step: %+0.2f   Count %d\n', ...
                min(pmi.Fwd.CompVol.Y), max(pmi.Fwd.CompVol.Y), ...
                pmi.Fwd.CompVol.YStep, length(pmi.Fwd.CompVol.Y));
            fprintf(fid, ...
                'Min Z: %+0.2f   Max Z: %+0.2f  Step: %+0.2f   Count %d\n', ...
                min(pmi.Fwd.CompVol.Z), max(pmi.Fwd.CompVol.Z), ...
                pmi.Fwd.CompVol.ZStep, length(pmi.Fwd.CompVol.Z));
            fprintf(fid, 'Total Voxels:\t\t%d\n',length(pmi.Fwd.CompVol.X) * ...
                length(pmi.Fwd.CompVol.Y) * length(pmi.Fwd.CompVol.Z));
        else
            fprintf(fid, 'Total Voxels:\t\t%d\n', size(pmi.Fwd.CompVol.Pos,1));
        end
    else
        fprintf(fid, 'Not available\n');    
    end
    fprintf(fid, '\n');

    if isfield(pmi.Fwd, 'A')
        fprintf(fid, 'Linear forward model A is present, size %d x %d\n', ...
            size(pmi.Fwd.A, 1), size(pmi.Fwd.A, 2));
    else
        fprintf(fid, 'Linear forward model A is NOT present\n');
    end
    if isfield(pmi.Fwd, 'delMu_a')
        fprintf(fid, 'Absorption function perturbation is present, size %d x %d\n', ...
            size(pmi.Fwd.delMu_a, 1), size(pmi.Fwd.delMu_a, 2));
    else
        fprintf(fid, 'Absorption function perturbation is NOT present\n');
    end

    if isfield(pmi.Fwd, 'delMu_sp')
        fprintf(fid, 'Scattering function perturbation is present, size %d x %d\n', ...
            size(pmi.Fwd.delMu_sp, 1), size(pmi.Fwd.delMu_sp, 2));
    else
        fprintf(fid, 'Scattering function perturbation is NOT present\n');
    end

    if isfield(pmi.Fwd, 'PhiInc')
        fprintf(fid, 'Incident field is present, size %d x %d\n', ...
            size(pmi.Fwd.PhiInc, 1), size(pmi.Fwd.PhiInc, 2));
    else
        fprintf(fid, 'Incident field is NOT present\n');
    end

    if isfield(pmi.Fwd, 'PhiScat')
        fprintf(fid, 'Scattered field is present, size %d x %d\n', ...
            size(pmi.Fwd.PhiScat, 1), size(pmi.Fwd.PhiScat, 2));
    else
        fprintf(fid, 'Scattered field is NOT present\n');
    end
else
    fprintf(fid, 'Not available\n');
end
fprintf(fid, '\n\n');

%%
%%  Print out the inverse model structure
%%
fprintf(fid, 'Inverse Model Information\n');
fprintf(fid, ...
    '======================================================================\n');
if isfield(pmi, 'Inv')
    fprintf(fid, 'Index of refraction:\t\t');
    if isfield(pmi.Inv, 'idxRefr')
        nParam = length(pmi.Inv.idxRefr);
        for iParam = 1:nParam
            fprintf(fid, '%f\t', pmi.Inv.idxRefr(iParam));    
        end
    else
        fprintf(fid, 'Not available\n');
    end
    fprintf(fid, '\n');

    fprintf(fid, 'Propagation velocity (cm/s):\t');
    if isfield(pmi.Inv, 'v')
        nParam = length(pmi.Inv.v);
        for iParam = 1:nParam
            fprintf(fid, '%e\t', pmi.Inv.v(iParam));    
        end
    else
        fprintf(fid, 'Not available\n');
    end
    fprintf(fid, '\n');

    fprintf(fid, 'Mean cosine:\t\t\t');
    if isfield(pmi.Inv, 'g')
        nParam = length(pmi.Inv.g);
        for iParam = 1:nParam
            fprintf(fid, '%f\t', pmi.Inv.g(iParam));    
        end
    else
        fprintf(fid, 'Not available\n');
    end
    fprintf(fid, '\n');

    fprintf(fid, 'Scattering coef. (cm^-1):\t');
    if isfield(pmi.Inv, 'Mu_s')
        nParam = length(pmi.Inv.Mu_s);
        for iParam = 1:nParam
            fprintf(fid, '%f\t', pmi.Inv.Mu_s(iParam));
        end
    else
        fprintf(fid, 'Not available\n');
    end
    fprintf(fid, '\n');

    fprintf(fid, 'Reduced scat. coef. (cm^-1):\t');
    if isfield(pmi.Inv, 'Mu_sp')
        nParam = length(pmi.Inv.Mu_sp);
        for iParam = 1:nParam
            fprintf(fid, '%f\t', pmi.Inv.Mu_sp(iParam));
        end
    else
        fprintf(fid, 'Not available\n');
    end
    fprintf(fid, '\n');

    fprintf(fid, 'Absorption coef. (cm^-1):\t');
    if isfield(pmi.Inv, 'Mu_a')
        nParam = length(pmi.Inv.Mu_a);
        for iParam = 1:nParam
            fprintf(fid, '%f\t', pmi.Inv.Mu_a(iParam));
        end
    else
        fprintf(fid, 'Not available\n');
    end
    fprintf(fid, '\n');

    fprintf(fid, 'Chromophores:        Concentration    mu_a\n');
    fprintf(fid, ...
        '----------------------------------------------------------------------\n');
    if isfield(pmi.Inv, 'Cphore')
        nCphore = size(pmi.Inv.Cphore)
        for iCphore = 1:nCphore
            fprintf(fid, '%s\t%f\t%f\n', ...
                pmi.Inv.Cphore(iCphore).Name, ...
                pmi.Inv.Cphore(iCphore).Conc, ...
                pmi.Inv.Cphore(iCphore).Mu_a);
        end
    else
        fprintf(fid, 'Not available\n');
    end

    fprintf(fid, 'Wavelength (nm):\t\t');
    if isfield(pmi.Inv, 'Lambda')
        nParam = length(pmi.Inv.Lambda);
        for iParam = 1:nParam
            fprintf(fid, '%d\t\t', pmi.Inv.Lambda(iParam));    
        end
    else
        fprintf(fid, 'Not available\n');
    end
    fprintf(fid, '\n');

    fprintf(fid, 'Modulation frequency (MHz):\t');
    if isfield(pmi.Inv, 'ModFreq')
        nParam = length(pmi.Inv.ModFreq);
        for iParam = 1:nParam
            fprintf(fid, '%f\t', pmi.Inv.ModFreq(iParam));
        end
    else
        fprintf(fid, 'Not available\n');
    end
    fprintf(fid, '\n');
    fprintf(fid, 'Number of measurements:\t\t');
    if isfield(pmi.Inv, 'MeasList');
        fprintf(fid, '%d\n', size(pmi.Inv.MeasList, 1));
    else
        fprintf(fid, 'Not available\n');
    end
    fprintf(fid, '\n');

    fprintf(fid, 'Source optodes\n ');
    fprintf(fid, ...
        '----------------------------------------------------------------------\n');
    if isfield(pmi.Inv, 'Src')
        fprintf(fid, 'Type:\t%s\n', pmi.Inv.Src.Type);
        if strcmp(pmi.Inv.Src.Type, 'uniform')
            fprintf(fid, 'X positions (cm): ')
            fprintf(fid, '%f\t', pmi.Inv.Src.X)
            fprintf(fid, '\n');

            fprintf(fid, 'Y positions (cm): ')
            fprintf(fid, '%f\t', pmi.Inv.Src.Y)
            fprintf(fid, '\n');

            fprintf(fid, 'Z positions (cm): ')
            fprintf(fid, '%f\t', pmi.Inv.Src.Z)
            fprintf(fid, '\n');
            
        else
            nSrc = size(pmi.Inv.Src.Pos, 1);
            fprintf(fid, 'Source positions (cm):\n');
            for iSrc = 1:nSrc
                fprintf(fid, '\t%0.2f\t%0.2f\t%0.2f\n', ...
                    pmi.Inv.Src.Pos(iSrc,1), ...
                    pmi.Inv.Src.Pos(iSrc,2),  ...
                    pmi.Inv.Src.Pos(iSrc,3));
            end
        end
        nSrc = size(pmi.Inv.Src.Normal);
        fprintf(fid, 'Normal vector:\n');
        for iSrc = 1:nSrc
            fprintf(fid, '\t%0.2f\t%0.2f\t%0.2f\n', ...
                pmi.Inv.Src.Normal(iSrc,1), ...
                pmi.Inv.Src.Normal(iSrc,2),  ...
                pmi.Inv.Src.Normal(iSrc,3));
        end
        fprintf(fid, 'Amplitude:          ');
        fprintf(fid,'  %0.2f', pmi.Inv.Src.Amplitude);
        fprintf(fid, '\n');
        fprintf(fid, 'Numerical aperature:');
        fprintf(fid,'  %0.2f', pmi.Inv.Src.Amplitude);
        fprintf(fid, '\n');

    else
        fprintf(fid, 'Not available\n');
    end
    fprintf(fid, '\n');

    fprintf(fid, 'Detector optodes\n ');
    fprintf(fid, ...
        '----------------------------------------------------------------------\n');
    if isfield(pmi.Inv, 'Det')
        fprintf(fid, 'Type:\t%s\n', pmi.Inv.Det.Type);
        if strcmp(pmi.Inv.Det.Type, 'uniform')
            fprintf(fid, 'X positions (cm): ')
            fprintf(fid, '%f\t', pmi.Inv.Det.X)
            fprintf(fid, '\n');

            fprintf(fid, 'Y positions (cm): ')
            fprintf(fid, '%f\t', pmi.Inv.Det.Y)
            fprintf(fid, '\n');

            fprintf(fid, 'Z positions (cm): ')
            fprintf(fid, '%f\t', pmi.Inv.Det.Z)
            fprintf(fid, '\n');
            
        else
            nDet = size(pmi.Inv.Det.Pos, 1);
            fprintf(fid, 'Detector positions (cm):\n');
            for iDet = 1:nDet
                fprintf(fid, '\t%0.2f\t%0.2f\t%0.2f\n', ...
                    pmi.Inv.Det.Pos(iDet,1), ...
                    pmi.Inv.Det.Pos(iDet,2),  ...
                    pmi.Inv.Det.Pos(iDet,3));
            end
        end
        nDet = size(pmi.Inv.Det.Normal);
        fprintf(fid, 'Normal vector:\n');
        for iDet = 1:nDet
            fprintf(fid, '\t%0.2f\t%0.2f\t%0.2f\n', ...
                pmi.Inv.Det.Normal(iDet,1), ...
                pmi.Inv.Det.Normal(iDet,2),  ...
                pmi.Inv.Det.Normal(iDet,3));
        end
        fprintf(fid, 'Efficiency:          ');
        fprintf(fid,'  %0.2f', pmi.Inv.Det.Amplitude);
        fprintf(fid, '\n');
        fprintf(fid, 'Numerical aperature:');
        fprintf(fid,'  %0.2f', pmi.Inv.Det.Amplitude);
        fprintf(fid, '\n');

    else
        fprintf(fid, 'Not available\n');
    end
    fprintf(fid, '\n');

    fprintf(fid, 'Medium boundary geometry:\t');
    if isfield(pmi.Inv, 'Boundary');
        fprintf(fid, '%s', pmi.Inv.Boundary.Geometry);
        if strcmp(pmi.Inv.Boundary.Geometry, 'Slab')
            fprintf(fid, '  %f cm\n', pmi.Inv.Boundary.Thinkness);
        else
            fprintf(fid, '\n');
        end
    else
        fprintf(fid, 'Not available\n');    
    end
    fprintf(fid, 'Computational method:\t\t');
    if isfield(pmi.Inv, 'Method')
        fprintf(fid, '%s', pmi.Inv.Method.Type);
        if strcmp(pmi.Inv.Method.Type, 'Born') | ...
                strcmp(pmi.Inv.Method.Type, 'Spherical');
            fprintf(fid, '  order: %d\n', pmi.Inv.Method.Order);
        elseif strcmp(pmi.Inv.Method.Type, 'Matlab Var')
            fprintf(fid, '  %s\n', pmi.Inv.Method.MatlabVarName);
        end
        fprintf(fid, '\n');
    else
        fprintf(fid, 'Not available\n');    
    end

    fprintf(fid, 'Computational volume\n ');
    fprintf(fid, ...
        '----------------------------------------------------------------------\n');
    if isfield(pmi.Inv, 'CompVol')
        fprintf(fid, 'Type :  %s\n', pmi.Inv.CompVol.Type);
        if strcmp('uniform',pmi.Inv.CompVol.Type)
            fprintf(fid, ...
                'Min X: %+0.2f   Max X: %+0.2f  Step: %+0.2f   Count %d\n', ...
                min(pmi.Inv.CompVol.X), max(pmi.Inv.CompVol.X), ...
                pmi.Inv.CompVol.XStep, length(pmi.Inv.CompVol.X));
            fprintf(fid, ...
                'Min Y: %+0.2f   Max Y: %+0.2f  Step: %+0.2f   Count %d\n', ...
                min(pmi.Inv.CompVol.Y), max(pmi.Inv.CompVol.Y), ...
                pmi.Inv.CompVol.YStep, length(pmi.Inv.CompVol.Y));
            fprintf(fid, ...
                'Min Z: %+0.2f   Max Z: %+0.2f  Step: %+0.2f   Count %d\n', ...
                min(pmi.Inv.CompVol.Z), max(pmi.Inv.CompVol.Z), ...
                pmi.Inv.CompVol.ZStep, length(pmi.Inv.CompVol.Z));
            fprintf(fid, 'Total Voxels:\t\t%d\n',length(pmi.Inv.CompVol.X) * ...
                length(pmi.Inv.CompVol.Y) * length(pmi.Inv.CompVol.Z));
        else
            fprintf(fid, 'Total Voxels:\t\t%d\n', size(pmi.Inv.CompVol.Pos,1));
        end
    else
        fprintf(fid, 'Not available\n');    
    end
    fprintf(fid, '\n');

    if isfield(pmi.Inv, 'A')
        fprintf(fid, 'Linear forward model A is present, size %d x %d\n', ...
            size(pmi.Inv.A, 1), size(pmi.Inv.A, 2));
    else
        fprintf(fid, 'Linear forward model A is NOT present\n');
    end
    if isfield(pmi.Inv, 'Aw')
        fprintf(fid, 'Weighted linear forward model Aw is present, size %d x %d\n', ...
            size(pmi.Inv.Aw, 1), size(pmi.Inv.Aw, 2));
    else
        fprintf(fid, 'Weighted Linear forward model Aw is NOT present\n');
    end

    if isfield(pmi.Inv, 'delMu_a')
        fprintf(fid, 'Absorption function perturbation is present, size %d x %d\n', ...
            size(pmi.Inv.delMu_a, 1), size(pmi.Inv.delMu_a, 2));
    else
        fprintf(fid, 'Absorption function perturbation is NOT present\n');
    end

    if isfield(pmi.Inv, 'delMu_sp')
        fprintf(fid, 'Scattering function perturbation is present, size %d x %d\n', ...
            size(pmi.Inv.delMu_sp, 1), size(pmi.Inv.delMu_sp, 2));
    else
        fprintf(fid, 'Scattering function perturbation is NOT present\n');
    end

    if isfield(pmi.Inv, 'PhiInc')
        fprintf(fid, 'Incident field is present, size %d x %d\n', ...
            size(pmi.Inv.PhiInc, 1), size(pmi.Inv.PhiInc, 2));
    else
        fprintf(fid, 'Incident field is NOT present\n');
    end

    if isfield(pmi.Inv, 'PhiScat')
        fprintf(fid, 'Scattered field is present, size %d x %d\n', ...
            size(pmi.Inv.PhiScat, 1), size(pmi.Inv.PhiScat, 2));
    else
        fprintf(fid, 'Scattered field is NOT present\n');
    end
    if isfield(pmi.Inv, 'PhiScatw')
        fprintf(fid, 'Weighted scattered field is present, size %d x %d\n', ...
            size(pmi.Inv.PhiScatw, 1), size(pmi.Inv.PhiScatw, 2));
    else
        fprintf(fid, 'Weighted scattered field is NOT present\n');
    end
else
    fprintf(fid, 'Not available\n');    
end
fprintf(fid, '\n\n');



%%
%%  Print out the object information
%%
fprintf(fid, 'Object Information\n');
fprintf(fid, ...
    '======================================================================\n');
if isfield(pmi, 'Object')
    nObj = length(pmi.Object);
    for iObj = 1:nObj
        fprintf(fid, 'Type: %s  Position: %0.3f %0.3f %0.3f   ', ...
            pmi.Object{iObj}.Type, ...
            pmi.Object{iObj}.Pos(1), ...
            pmi.Object{iObj}.Pos(2), ...
            pmi.Object{iObj}.Pos(3));
        if strcmp(pmi.Object{iObj}.Type, 'sphere')
            fprintf(fid, 'Radius %0.3f  ', pmi.Object{iObj}.Radius);
        end
        if strcmp(pmi.Object{iObj}.Type, 'block')
            fprintf(fid, 'Dims: %0.3f  ', pmi.Object{iObj}.Dims(1), ...
                pmi.Object{iObj}.Dims(2), pmi.Object{iObj}.Dims(3));
        end
        fprintf(fid, 'mu_a: ');
        fprintf(fid, '%0.3f ', pmi.Object{iObj}.Mu_a);
        if isfield(pmi.Object{iObj}, 'Mu_s')
            fprintf(fid, ' mu_s : %0.3f', pmi.Object{iObj}.Mu_s);
        else
            fprintf(fid, ' mu_s : bkgnd');
        end
        fprintf(fid, '\n');
    end
else
    fprintf(fid, 'Not available\n');
end

fprintf(fid, '\n\n');

%%
%%  Print out the noise structure
%%
fprintf(fid, 'Noise Model Information\n');
fprintf(fid, ...
    '======================================================================\n');
fprintf(fid, '\n\n');

%%
%%  Print out the reconstruction structure
%%
fprintf(fid, 'Reconstruction Technique Information\n');
fprintf(fid, ...
    '======================================================================\n');
fprintf(fid, '\n\n');

%%
%%  Print out the visualization structure
%%
fprintf(fid, 'Visualiztion Information\n');
fprintf(fid, ...
    '======================================================================\n');
fprintf(fid, '\n\n');
