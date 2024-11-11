%GETNOISEINFO   Get the noise model info from the GUI.
%
%   ds = getNoiseInfo(ds)
%
%   ds          The DPDW Imaging data structure to fill in.  If this is
%               not present in the input argument list it will be
%               created.
%
%   GETNOISEINFO extracts the noise model info from the GUI and fills
%   in the DPDW imaging data structure with the appropriate values.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:41 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: getNoiseInfo.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:41  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ds = getNoiseInfo(ds)

if nargin < 1
    ds = [];
end

%%
%%  Get the handle structure from the current figure's user data.
%%
UIHandles = get(gcf, 'UserData');

%%
%%  Noise level parameters
%%
ds.Noise.SrcSNRflag = get(UIHandles.SrcSNRflag,'value');
temp = get(UIHandles.SrcSNR,'string');
if ~isempty(temp)
    ds.Noise.SrcSNR = eval(get(UIHandles.SrcSNR, 'string'));
end

ds.Noise.DetSNRflag = get(UIHandles.DetSNRflag,'value');
temp = get(UIHandles.DetSNR,'string');
if ~isempty(temp)
    ds.Noise.DetSNR = eval(get(UIHandles.DetSNR, 'string'));
end

ds.Noise.ScatSNRflag = get(UIHandles.ScatSNRflag,'value');
temp = get(UIHandles.ScatSNR,'string');
if ~isempty(temp)
    ds.Noise.ScatSNR = eval(get(UIHandles.ScatSNR, 'string'));
end

ds.Noise.VecNormSNRflag = get(UIHandles.VecNormSNRflag,'value');
temp = get(UIHandles.VecNormSNR,'string');
if ~isempty(temp)
    ds.Noise.VecNormSNR = eval(get(UIHandles.VecNormSNR, 'string'));
end


