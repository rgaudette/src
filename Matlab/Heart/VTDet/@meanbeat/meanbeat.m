%MEANBEAT       Meanbeat class constructor
%
%   obj = meanbeat(EGStruct, wdQRS = 0.180, wdBeat = 0.300, nBeats = 10,
%                  minCC = 0.9, idxRange)
%
%   obj         The initialized Meanbeat structure.
%
%   EGStruct    OPTIONAL: An Electrogram structure to use for initializing
%               the mean beat.  If this parameter is not present the mean
%               beat remains uninitialized.
%
%   wdQRS       OPTIONAL: The QRS complex width, in seconds, to use in the search
%               for independent peaks.
%
%   wdBeat      OPTIONAL: The width of the mean beat to generate, in seconds.
%
%   nBeats      OPTIONAL: The number of beats to employ to generate the
%               average beat.  A value of zero implies the use of all beats
%               present in the valid range of the electrogram.
%
%   minCC       The minimum cross correlation coefficient necessary to
%               update a beat.
%
%   idxRange    OPTIONAL: The range within the electrogram to search for
%               intialization beats,
%
%
%   MEANBEAT initializes a Meanbeat object.  The electrogram sequence in
%   EGStruct is used to compute an initial mean beat estimate.
%
%   Methods:
%       intialize   Same function as constructor.
%       update      Possibly update the oldest beat with a new beat.
%       beat        Return the current mean beat.
%       idxrwave    Return the index of the R wave in the mean beat.
%       beatmat     Return the beat matrix structure.
%       
%   Calls: rwavedet
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:02 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: meanbeat.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:02  rickg
%  Matlab Source
%
%  Revision 1.2  1997/12/19 18:40:33  rjg
%  Help section fixes.
%
%  Revision 1.1  1997/11/12 16:52:30  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function obj = meanbeat(varargin)

%%
%%  Which version of the constructor is beaing called
%%
switch nargin
    %%
    %%  Unintialized object
    %%
    case 0,
        obj.Beat = [];
        obj.BeatMatrix = [];
        obj.nBeats;
        obj.NextBeat = 0;
        obj.wdQRS = 0;
        obj.wdBeat = 0;
        obj.idxRwave = 0;
        obj.FSamp = 0;
        obj.Units = '';
        obj.MinCC = 0;
        obj.MinRtoR = 0;
        return;

    %%
    %%  Initilize with the supplied argument
    %%
    case 1,
        obj.wdQRS = 0.180;
        obj.wdBeat = 0.300;
        obj.nBeats = 10;
        obj.MinCC = 0.9;    
    case 2,
        obj.wdQRS = varargin{2};
        obj.wdBeat = 0.250;
        obj.nBeats = 10;
        obj.MinCC = 0.9;    
    case 3,
        obj.wdQRS = varargin{2};
        obj.wdBeat = varargin{3};
        obj.nBeats = 10;
        obj.MinCC = 0.9;        
    case 4,
        obj.wdQRS = varargin{2};
        obj.wdBeat = varargin{3};
        obj.nBeats = varargin{4};
        obj.MinCC = 0.9;    
    case 5,
        obj.wdQRS = varargin{2};
        obj.wdBeat = varargin{3};
        obj.nBeats = varargin{4};
        obj.MinCC = varargin{5};
end
obj.NextBeat = 1;
obj.FSamp = varargin{1}.FSamp;
obj.Units = varargin{1}.Units;

%%
%%  Find the indices of the R waves in the electrogram 
%%
idxRwaveSeq = rwavedet(varargin{1}, obj.wdQRS);


%%
%%  Fill in the minimum R-to-R period
%%
obj.MinRtoR = min(diff(idxRwaveSeq));

%%
%%  Calculate the template width and the start and stop indices relative to
%%  the R wave
%%
nTemplate = ceil(obj.wdBeat * obj.FSamp);
PreRSamps = ceil(0.3 * nTemplate);
obj.idxRwave = PreRSamps + 1;

%%
%%  Initialize the beat vector and beat matrix
%%
obj.Beat = zeros(nTemplate,1);
if obj.nBeats > 0
    obj.BeatMatrix = zeros(nTemplate, obj.nBeats);
else
    obj.BeatMatrix = zeros(nTemplate, length(idxRwaveSeq));
end

%%
%%  Extract the number of beats requested
%%
nUsedBeats = 0;
for iRwave = 1:length(idxRwaveSeq)

    %%
    %%  Compute the first and last samples of the current beat
    %%
    idxStart = idxRwaveSeq(iRwave) - PreRSamps;
    idxStop = idxStart + nTemplate - 1;
    if (idxStart > 0) & (idxStop <= length(varargin{1}.Seq))
        nUsedBeats = nUsedBeats + 1;
        obj.BeatMatrix(:, nUsedBeats) = varargin{1}.Seq(idxStart:idxStop);
    end
    
    %%
    %%  Break out of the loop if we have the desired number of beats
    %%
    if (obj.nBeats > 0) & (nUsedBeats == obj.nBeats)
        break
    end
end

if obj.nBeats == 0
    obj.nBeats = nUsedBeats;
end

%%
%%  Average the extracted beats and update the next pointer
%%
obj.Beat = sum(obj.BeatMatrix')' ./ obj.nBeats;

obj.NextBeat = rem(nUsedBeats, obj.nBeats) + 1;

%%
%%  Register the class
%%
obj = class(obj, 'meanbeat');
