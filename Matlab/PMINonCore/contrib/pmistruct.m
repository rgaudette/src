function ds=pmistruct();
%
%	This is used to create the correct stucture used in PMI
%

ds.Version 	=	3;
ds.Debug	=	0;

Model.idxRefr			=	1.37;
Model.Mu_s				=	20;
Model.g					=	0.8;
Model.Mu_a				=	0.02;
Model.Mu_sp				=	10;
Model.v					=	3e10/Model.idxRefr;

Model.SrcPos.Type		=	'uniform';
Model.SrcPos.X			=	[1,2,3];
Model.SrcPos.Y			=	[1,2,3];
Model.SrcPos.Z			=	[0];
Model.SrcAmp			=	0;

Model.DetPos.Type		=	'uniform';
Model.DetPos.X			=	[1,2,3];
Model.DetPos.Y			=	[1,2,3];
Model.DetPos.Z			=	[0];
Model.SensorError		=	0;

Model.ModFreq			=	0;
Model.Boundary			=	'Extrapolated';

Model.Method.Type		=	'Born';
Model.Method.Order		=	1;

Model.CompVol.Type		=	'uniform';
Model.CompVol.X			=	[0 0.5000 1 1.5000 2 2.5000 3 3.5000 4 4.5000 5 5.5000 6 6.5000];
Model.CompVol.Y			=	[0 0.5000 1 1.5000 2 2.5000 3 3.5000 4 4.5000 5 5.5000 6 6.5000];
Model.CompVol.Z			=	[-5 -4.5000 -4 -3.5000 -3 -2.5000 -2 -1.5000 -1 -0.5000 0];
Model.CompVol.XStep		=	0.5000;
Model.CompVol.YStep		=	0.5000;
Model.CompVol.ZStep		=	0.5000;

ds.Fwd=Model;
