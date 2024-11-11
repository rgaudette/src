%dyneinFilter   Cross-correlate a dynein volume with a 3D tube
%
%   xcFunc = dyneinFilter(tube, dynein)

function xcFunc = dyneinFilter(tube, dynein)

xcFunc = xcorr3d(tube, dynein, 'valid');
