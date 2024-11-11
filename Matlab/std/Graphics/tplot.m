%TPLOT         Display a text legend as well as a plot.
%
%    tplot(yv1, ['string1', 'string2', ...., 'string15');
%    tplot(xv1, yv1, ['string1', 'string2', ... , 'string14'])
%    tplot(xv1, yv1, xv2, yv2, ['string1', 'string2', ... , 'string12'])
%
%    yv*       Y vector data to be plotted.
%
%    xv*       X vector data to be plotted.
%
%    string#   Text lines to be printed on the right of the graph.


function tplot(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, ...
    arg10, arg11, arg12, arg13, arg14, arg15, arg16);

%%
%%    Find number of lines to plot and strings to write
%%
flgBothXandY = 0;
nStrings = 0;
if isstr(arg2),
    nData = 1;
    nStrings = nargin - 1;
    iStringStart = 2;
else
    flgBothXandY = 1;

    if isstr(arg3),
        nData = 1;
        nStrings = nargin - 2;
        iStringStart = 3;
    else
        for iarg = 4:nargin,
            if isstr(eval(['arg' num2str(iarg)])),
                %%
                %%   Check to see all data is in pairs.
                %%
                if rem(iarg,2) == 0,
                    error('Data not in x y vector pairs.');
                end

                nStrings = nargin - iarg + 1;
                iStringStart = iarg;
                nData = (iarg - 1) / 2;
                break;
            end
        end
    end
end

%%
%%    Output text strings
%%
clf
axes('visible', 'off')
for iString = 0:nStrings-1
    StartX = 0.80;
    StartY = .95 - iString * 0.06;
    htext = text(StartX, StartY, eval(['arg' num2str(iStringStart + iString)]));
    set(htext, 'FontSize', 14)
    set(htext, 'FontWeight', 'bold')
end

%%
%%    Position axis for plotting
%%
axes('position', [0.1 0.1 0.6 0.8]);

%%
%%    Compile a string that defines the input arguments tobe plotted.
%%
strDataVector = [];
for iData = 1:nData,
    if flgBothXandY,
        strDataVector = [strDataVector 'arg' num2str(2*iData-1) ',arg' ...
            num2str(2*iData) ',' ];
    else
        strDataVector = 'arg1,';
    end
end

%%
%%    Remove trailing comma
%%
strDataVector = strDataVector(1:length(strDataVector)-1);

%%
%%    Plot data vectors.
eval(['h = plot(' strDataVector ');']);
set(h, 'LineWidth', 2);
