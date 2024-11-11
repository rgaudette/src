%FINDOBJPEAK    Find the subscripts for the peak value in a 3D object function
%
%    [peaksub value index] = findobjpeak(objfct, nDomain)

function [peaksub, value, index]= findobjpeak(objfct, nDomain)

objfct = objfct(:);
[value index] = max(objfct);
peaksub = zeros(1,3);
[peaksub(1) peaksub(2) peaksub(3)] = ind2sub(nDomain, index);


