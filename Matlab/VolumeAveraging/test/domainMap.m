%domainMap      Map variant and non-variant domain arguments
%
%   [argVar argNV1 argNV2] = domainMap(argX, argY, argZ, domain)
%
%   argVar      The variant domain
%
%   argNV1      The non-variant domains.
%   argNV2
%
%   domain      The specific domain to map to argVar
%
%
%   domainMap maps the specific domain to argVar and the remaining domains
%   to non-variant domains
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/11/20 17:38:59 $
%
%  $Revision: 1.1 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [argVar, argNV1, argNV2] = domainMap(argX, argY, argZ, domain)

switch upper(domain)
  case 'X'
    argVar = argX;
    argNV1 = argY;
    argNV2 = argZ;
  case 'Y'
    argVar = argY;
    argNV1 = argX;
    argNV2 = argZ;
  case 'Z'
    argVar = argZ;
    argNV1 = argX;
    argNV2 = argY;
  otherwise
    error(['Unknown domain mapping: ' domain]);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: domainMap.m,v $
%  Revision 1.1  2004/11/20 17:38:59  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
