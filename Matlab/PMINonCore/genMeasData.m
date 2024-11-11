%GenMeasData    Generate the measured data.
%
%   pmi = genMeasData(pmi);
%
%   pmi          The PMI Imaging data structure to updated.
%
%
%   GenMeasData generates the noiseless measured data using the forward method
%   information present in the PMI imaging data structure.
%
%   Calls: none.
%
%   Bugs: CURRENTLY ONLY HANDLES 1st ORDER FOR BORN CASE.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:27:27 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: genMeasData.m,v $
%  Revision 1.1.1.1  2004/01/03 08:27:27  rickg
%  Matlab Source
%
%  Revision 3.5  2000/01/10 00:14:14  dboas
%  Storing the source and detector lists for use by other functions
%
%  Revision 3.4  1999/12/03 13:52:23  dboas
%  Calculate the incident to purturbation ratio only if
%  the PhiScat field has been calculated.
%  This is needed because this routine
%  can now just calculate the incident
%  fluence (previous revision).
%
%  Revision 3.3  1999/11/18 17:37:37  rjg
%  Correct remaining calls to FullMeasList
%
%  Revision 3.2  1999/11/16 22:37:46  rjg
%  Added 'Helmholtz Homogenous' section from David.
%
%  Revision 3.1  1999/11/15 19:13:39  rjg
%  Commented out extended born section since that was moved to the non-core
%  development directory will uncomment when it is working.
%
%  Fixed calculation of effective source position for FDFD method.
%
%  Added warning about spherical harmonic not being fully functional.
%
%  Spherical harmonic code updated to handle new Object format.
%
%  Removed checking for nLambda since Lambda is avaiable in the new structure.
%
%  Revision 3.0  1999/06/17 19:29:38  rjg
%  Initial Revision for PMI 3.0
%
%  Revision 2.2  1999/02/05 20:39:28  rjg
%  Correctly handles extracting number of wavelengths from mu_a
%  Handles both spheres and blocks (multiple)
%  Calculates the total variance of the noise for appropriate weighting
%  Added TotalVar field to structure
%  No need for update flag for noise wieghting, removed.
%  Added code to added vector norm weighted noise (Eric usual manner
%  for specifying SNR).  Does not correctly handle multiple wavelengths yet.
%
%  Revision 2.1  1998/09/09 15:12:21  rjg
%  Corrected scaling for detector noise to be relative to the unpurturbed
%  scattered field.  Not significant unless two or more noise types were used.
%
%  Revision 2.0  1998/08/20 18:58:22  rjg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pmi = genMeasData(pmi);
%%
%%  Generate measured data
%%

switch pmi.Fwd.Method.Type

case 'Matlab Variable' 
    %%
    %%  Matlab variable data should be a matrix with 2 columns, the first ...
    %%  column should contain the total fluence measurement and the second ...
    %%  column should contain the incident fluence level.
    %%
    Fluence = eval(pmi.Fwd.Method.MatlabVarName);
    pmi.PhiTotal = Fluence(:,1);
    if pmi.Fwd.ModFreq > 0
        pmi.Fwd.PhiInc = Fluence(:,2);
        pmi.Fwd.PhiScat = pmi.PhiTotal - pmi.Fwd.PhiInc;
    end
    
case 'Helmholtz Homogeneous'
    nLambda = length(pmi.Fwd.Lambda);
    nFreq = length(pmi.Fwd.ModFreq);
    
    if ~isfield(pmi.Fwd, 'MeasList')
    	warning('MeasList data item not found, running all permutations');
    	[pSrc nSrc] = getOptodePos(pmi.Fwd.Src);
    	[pDet nDet] = getOptodePos(pmi.Fwd.Det);    
    	pmi.Fwd.MeasList = FullMeasList(nSrc, nDet, nFreq, nLambda);
       pmi.Fwd.Src.Pos = pSrc;
       pmi.Fwd.Det.Pos = pDet;
    end
    
    %%
	 %%  Loop over wavelength
	 %%
	 for idxLambda = 1:nLambda
	   %%
		%%  Loop over frequency
    	%%
    	idxRow = 1;
    	for idxFreq = 1:nFreq
        idxThisFreq = find((idxFreq == pmi.Fwd.MeasList(:,3)) & ...
            (idxLambda == pmi.Fwd.MeasList(:,4)));
        MeasList = pmi.Fwd.MeasList(idxThisFreq,:);
        
        PhiInc = DPDWHelmholtz( pmi.Fwd, MeasList, pmi.Debug);

        %%
        %%  Scale the amplitude of the forward matrix and incident field if 
        %%  necessary.
        %%
        if any(pmi.Fwd.Src.Amplitude ~= 1) | any(pmi.Fwd.Det.Amplitude ~= 1)
            disp('NEED TO VALIDATE MATRIX AMPLITUDE WEIGHTING!');
            SDWeight = pmi.Fwd.Det.Amplitude' * pmi.Fwd.Src.Amplitude;
            SDWeight = SDWeight(:);
            PhiInc = SDWeight .* PhiInc;
        end

        %%
        %%  Copy the fluence into the correct block
        %%
        nMeas = size(MeasList, 1);
        pmi.Fwd.PhiInc(idxRow:idxRow+nMeas-1,idxLambda) = real(PhiInc);
        idxRow = idxRow + nMeas;            
        if pmi.Fwd.ModFreq(idxFreq) > 0
            pmi.Fwd.PhiInc(idxRow:idxRow+nMeas-1,idxLambda) = imag(PhiInc);
            idxRow = idxRow + nMeas;
        end
      end
    end
   

case 'Born'
    %%
    %%  Check to make sure the number of mu_a parameters is the same as the
    %%  number of delMu_a parameters, this is also the number of
    %%  wavelengths.
    %%
    nLambda = size(pmi.Fwd.Mu_a, 2);

    %%
    %%  Generate the volume data using the 1st born method
    %%
    nMeas = size(pmi.Fwd.A, 1);
    pmi.Fwd.PhiScat = zeros(nMeas, nLambda);

    for iLambda = 1:nLambda
        delMu_a = calcDelMuA(pmi.Object, pmi.Fwd.CompVol, pmi.Fwd.Mu_a, iLambda);
        pmi.Fwd.PhiScat(:, iLambda) = pmi.Fwd.A(:,:,iLambda) * delMu_a(:);
        
    end
    pmi.PhiTotal = pmi.Fwd.PhiInc + pmi.Fwd.PhiScat;

case 'ExtBorn'
    warning('Extended Born approximation not yet functional');
%    %%
%    %%  Check to make sure the number of Mu_a parameters is the same as the
%    %%  number of delMu_a parameters, this is also the number of
%    %%  wavelengths.
%    %%
%    nLambda = size(pmi.Fwd.Mu_a, 2);
%    nDMu_a = size(pmi.Fwd.Mu_a, 2);
%    if nLambda ~= nDMu_a
%        error('Incorrect number of Mu_a parameters, must match Mu_a');
%    end
%
%    %%
%    %%  Source modulation frequency and source & detector positions
%    %%
%    [pSrc nSrc]= getOptodePos(pmi.Fwd.Src);
%    [pDet nDet]= getOptodePos(pmi.Fwd.Det);
%    nSDPair = nDet * nSrc;
%    nFreq = length(pmi.Fwd.ModFreq);
%
%    nMeas = nSDPair * (nFreq + sum(pmi.Fwd.ModFreq > 0));
%
%    pmi.Fwd.PhiScat = zeros(nMeas, nLambda);
%    pmi.Fwd.PhiInc = zeros(nMeas, nLambda);
%    pmi.PhiTotal = zeros(nMeas, nLambda);
%    if nFreq > 1
%        warning(['Multiple frequencies are not currently implemented for ' ...
%                'Extended born']);
%    end
%
%    %%
%    %%  Create the MeasList matrix
%    %%
%    if ~isfield(pmi.Fwd, 'MeasList')
%        pmi.Fwd.MeasList = FullMeasList(nSrc, nDet, nLambda, nLambda);
%    end
%    
%    %%
%    %%  Calculate the fluence at the detector using the extended born method
%    %%  looping over each wavelength
%    %%
%    for iLambda = 1:nLambda
%        delMu_a = calcDelMuA(pmi.Object, pmi.Fwd.CompVol, pmi.Fwd.Mu_a, iLambda)
%
%        %%
%        %%  Select the appropriate method for the boundary condition
%        %%
%        switch lower(pmi.Fwd.Boundary.Geometry)
%         case { 'semi-infinite', 'semi', 'extrapolated'}
%          if pmi.Debug
%              fprintf(['Executing semi-infinite boundary computation\n']);
%          end
%          %%
%          %%  Move the effective source position 1 mean free path into the medium
%          %%
%          EffpSrc = [pSrc(:,1) pSrc(:,2) pSrc(:,3)-(1/pmi.Fwd.Mu_sp(iLambda))]
%
%          [PhiTotal PhiInc] = DPDWEBornZB(pmi.Fwd.CompVol, pmi.Fwd.Mu_sp(iLambda), ...
%                                          pmi.Fwd.Mu_a(iLambda), delMu_a, ...
%                                          pmi.Fwd.v(iLambda), ...
%                                          pmi.Fwd.idxRefr(iLambda), ...
%                                          pmi.Fwd.ModFreq * 1E6, EffpSrc, pDet, ...
%                                          pmi.Debug);
%
%         case {'infinite', 'inf'}
%          if pmi.Debug
%              fprintf(['Executing infinite boundary computation\n']);
%          end
%          [PhiTotal PhiInc] = DPDWEBornNB(pmi.Fwd.CompVol, pmi.Fwd.Mu_sp(iLambda), ...
%                                          pmi.Fwd.Mu_a(iLambda), delMu_a, ...
%                                          pmi.Fwd.v(iLambda), ...
%                                          pmi.Fwd.idxRefr(iLambda), ...
%                                          pmi.Fwd.ModFreq * 1E6, pSrc, pDet, ...
%                                          pmi.Debug);
%        
%        otherwise
%         error(['Unknown boundary condition: ' pmiFwd.Boundary.Geometry]);
%        end
%
%        if pmi.Fwd.ModFreq > 0
%            pmi.PhiTotal(:, iLambda) = [real(PhiTotal); imag(PhiTotal)];
%            pmi.Fwd.PhiInc(:, iLambda) = [real(PhiInc); imag(PhiInc)];            
%        else
%            pmi.PhiTotal(:, iLambda) = real(PhiTotal);
%            pmi.Fwd.PhiInc(:, iLambda) = real(PhiInc);            
%        end
%    end
%    pmi.Fwd.PhiScat = pmi.PhiTotal - pmi.Fwd.PhiInc;
%
    
case 'FDFD'
    %%
    %%  Adujust the computational volume for the boundary.
    %%  Assuming a negative Z medium
    %%
    if any(strcmp(lower(pmi.Fwd.Boundary.Geometry), {'semi-infinite', 'semi', ...
                    'extrapolated'}))
        %%
        %%  Get the extrapolated boundary distance
        %%
        zBnd = calcExtBnd(pmi.Fwd.idxRefr, pmi.Fwd.Mu_sp);
        if pmi.Debug
            fprintf('Extrapolated boundary = %f cm\n', zBnd);
        end
        
        CVShift = - max(pmi.Fwd.CompVol.Z) + zBnd;
        pmi.Fwd.CompVol.Z = pmi.Fwd.CompVol.Z + CVShift;
        if pmi.Debug
            fprintf('Z Domain computational volume shifted %f cm\n', CVShift);
        end
    end
    
    %%
    %%  Source modulation frequency and source & detector positions
    %%
    [pSrc nSrc]= getOptodePos(pmi.Fwd.Src);
    [pDet nDet]= getOptodePos(pmi.Fwd.Det);
    nSDPair = nSrc * nDet;
    nFreq = length(pmi.Fwd.ModFreq);
    nMeas = nSDPair * (nFreq + sum(pmi.Fwd.ModFreq > 0));

    nLambda = length(pmi.Fwd.Lambda);
    pmi.Fwd.PhiScat = zeros(nMeas, nLambda);
    pmi.Fwd.PhiInc = zeros(nMeas, nLambda);
    pmi.PhiTotal = zeros(nMeas, nLambda);
    if nFreq > 1
        warning(['Multiple frequencies are not currently implemented for ' ...
                'FDFD']);
    end

    %%
    %%  Create the MeasList matrix
    %%
    if ~isfield(pmi.Fwd, 'MeasList')
        pmi.Fwd.MeasList = FullMeasList(nSrc, nDet, nLambda, nLambda);
    end
    
    %%
    %%  Calculate the fluence at the detector using the extended born method
    %%  looping over each wavelength
    %%
    for iLambda = 1:nLambda
        delMu_a = calcDelMuA(pmi.Object, pmi.Fwd.CompVol, pmi.Fwd.Mu_a, iLambda);

        %%
        %%  Calculate the effiective source position
        %%
        EffpSrc = [pSrc(:,1) pSrc(:,2) pSrc(:,3)-(1/pmi.Fwd.Mu_sp(iLambda))]        
        %%
        %%  Select the appropriate method for the boundary condition
        %%
        switch lower(pmi.Fwd.Boundary.Geometry)
         case { 'semi-infinite', 'semi', 'extrapolated'}
          if pmi.Debug
              fprintf(['Executing extrapolated zero boundary' ...
                       ' computation\n']);
          end
          [PhiScat PhiInc] = DPDWFDJacZB(pmi.Fwd.CompVol,  pmi.Fwd.Mu_sp(iLambda), ...
                                         pmi.Fwd.Mu_a(iLambda), delMu_a, ...
                                         pmi.Fwd.v(iLambda),  pmi.Fwd.ModFreq*1E6, ...
                                         EffpSrc, pmi.Fwd.Src.Amplitude,  ...
                                         pDet, pmi.Fwd.Det.Amplitude, pmi.Debug);
          

         case {'infinite', 'inf'}
          if pmi.Debug
              fprintf(['Executing infinite medium boundary' ...
                       ' computation\n']);
          end
          [PhiScat PhiInc] = DPDWFDJacNB(pmi.Fwd.CompVol,  pmi.Fwd.Mu_sp(iLambda), ...
                                         pmi.Fwd.Mu_a(iLambda), delMu_a, ...
                                         pmi.Fwd.v(iLambda),  pmi.Fwd.ModFreq*1E6, ...
                                         EffpSrc, pmi.Fwd.Src.Amplitude,  ...
                                         pDet, pmi.Fwd.Det.Amplitude, pmi.Debug);

         otherwise
          error(['Unknown boundary condition: ' pmi.Fwd.Boundary.Geometry]);
        end

        if pmi.Fwd.ModFreq > 0
            pmi.Fwd.PhiScat(:, iLambda) = [real(PhiScat); imag(PhiScat)];
            pmi.Fwd.PhiInc(:, iLambda) = [real(PhiInc); imag(PhiInc)];
        else
            pmi.Fwd.PhiScat(:, iLambda) = real(PhiScat);
            pmi.Fwd.PhiInc(:, iLambda) = real(PhiInc);            
        end
    end
    pmi.PhiTotal = pmi.Fwd.PhiScat + pmi.Fwd.PhiInc;

case 'Spherical'
    warning('Spherical harmonic forward solution not fully yet functional');
    %%
    %%  Check the object(s) to make sure that they are spheres
    %%
    nObjects = length(pmi.Object);
    if nObjects >1
        fprintf(['WARNING: Spherical harmonic solution for' ...
                ' multiple spheres is\n']);
        fprintf(['only a simple sum approximation of the' ...
                ' individual scatterd fielpmi\n']);
    end
    for iObj = 1:nObjects
        if ~strcmp(pmi.Object{iObj}.Type, 'sphere')
            error('Spherical Harmonic forward solution is only applicable to spherical objects');
        end
    end

    nLambda = length(pmi.Fwd.Lambda);
    %%
    %%  Source modulation frequency and source & detector positions
    %%
    [pSrc nSrc]= getOptodePos(pmi.Fwd.Src);
    [pDet nDet]= getOptodePos(pmi.Fwd.Det);
    nSDPair = nDet * nSrc;
    nFreq = length(pmi.Fwd.ModFreq);
    nR = nSDPair * (nFreq + sum(pmi.Fwd.ModFreq > 0));
    pmi.Fwd.PhiScat = zeros(nR, nLambda);
    pmi.Fwd.PhiInc = zeros(nR, nLambda);

    %%
    %%  Create the MeasList matrix
    %%
    if ~isfield(pmi.Fwd, 'MeasList')
        pmi.Fwd.MeasList = FullMeasList(nSrc, nDet, nLambda, nLambda);
    end
    
    %%
    %%  Compute the infinite medium solution for each wavelength and
    %%  frequency
    %%
    
    switch lower(pmi.Fwd.Boundary.Geometry)
     case { 'semi-infinite', 'semi', 'extrapolated'}
      error(['Semi-infinte medium is not implemented yet for the spherical' ...
             ' harmonics solution'])
     
     case {'infinite', 'inf'}
      if pmi.Debug
          fprintf(['Executing infinite medium boundary computation\n']);
      end
      for iLambda = 1:nLambda
          opBack.mu_sp = pmi.Fwd.Mu_sp(iLambda);
          EffpSrc = [pSrc(:,1) pSrc(:,2) pSrc(:,3)-(1/pmi.Fwd.Mu_sp(iLambda))];
          opBack.mu_a = pmi.Fwd.Mu_a(iLambda);
          opSphere.mu_sp = pmi.Fwd.Mu_sp(iLambda);
          idxRow =  1;
          for iFreq = 1:nFreq
              w = 2 * pi * pmi.Fwd.ModFreq(iFreq) * 1E6;

              PhiScat = zeros(nSDPair,1);
              for iSphere = 1:nObjects
                  opSphere.mu_a = pmi.Object{iSphere}.Mu_a(iLambda);

                  %%
                  %%  Translate origin to center of sphere.
                  %%
                  tpSrc = EffpSrc - repmat(pmi.Object{iSphere}.Pos, nSrc, 1);
                  tpDet = pDet - repmat(pmi.Object{iSphere}.Pos, nDet, 1);
                      
                  %%
                  %%  Calculate scattered field from current object
                  %%
                  [TmpScat PhiInc] = dpdw_sphere_nb(tpSrc, tpDet, w, pmi.Fwd.v, ...
                                                    opBack, opSphere, ...
                                                    pmi.Object{iSphere}.Radius, ...
                                                    pmi.Fwd.Method.Order, pmi.Debug);
                  PhiScat = PhiScat + TmpScat;
              end

              %%
              %%  Fill in scattered field data
              %%
              pmi.Fwd.PhiScat(idxRow:idxRow+nSDPair-1, iLambda) = real(PhiScat);
              pmi.Fwd.PhiInc(idxRow:idxRow+nSDPair-1, iLambda) = real(PhiInc);
              idxRow = idxRow + nSDPair;
              if w > 0                
                  pmi.Fwd.PhiScat(idxRow:idxRow+nSDPair-1, iLambda) = imag(PhiScat);
                  pmi.Fwd.PhiInc(idxRow:idxRow+nSDPair-1, iLambda) = imag(PhiInc);
                  idxRow = idxRow + nSDPair;
              end
          end
      end
     otherwise
      error(['Unknown boundary condition: ' pmi.Fwd.Boundary.Geometry]);
    end

    pmi.PhiTotal = pmi.Fwd.PhiInc + pmi.Fwd.PhiScat;    

otherwise
    error(['Unknown forward method: ' pmi.Fwd.Method.Type])
end

%%
%%  Calculate the incident to purturbation ratio
%%
if pmi.Debug > 0
   if isfield(pmi.Fwd,'PhiScat')
      pmi.Fwd.IPR = abs(pmi.Fwd.PhiInc) ./ abs(pmi.Fwd.PhiScat);
   end
end
