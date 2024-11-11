%PRISM_CM       Prism color map.
%
%    map = prism_cm
function prsim1 = prism_cm
kred = .2;
kblue = .05;
kgreen = .15;


%%
%%  Purple to blue section
%%
red = 0.5*exp(kred * [0:-1:-11]).';
green = zeros(12,1);
blue = ones(12,1);
prism1 = [red green blue];

%%
%%    Blue to green section
%%
red = zeros(13,1);
green = exp(kgreen * [-13:1:-1]).';
blue = exp(kblue * [-0:-1:-12]).';
prism1 = [prism1 ; [red green blue]];

%%
%% Green to yellow section 
%%
red = exp(kred * [-13:1:-1]).';
green = ones(13,1);
blue = zeros(13,1);
prism1 = [prism1 ; [red green blue]];

%%
%%    Yellow to orange to red section
%%
red = ones(26,1);
green = exp(1.3*kgreen * [-.5:-.5:-13]).';
blue = zeros(26,1);
prism1 = [prism1 ; [red green blue]];