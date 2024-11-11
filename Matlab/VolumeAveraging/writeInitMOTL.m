%writeInitMOTL(nParticles, fnMotlname)
%   
%    motl = writeInitMOTL(particles, fnMotlname)
% 
%    particles  Either the number of particles or a list of particle indices
%
%    fnMotlname The filename of the motive list to write.
%
%    writeInitMOTL will write out an initial motive list to the filename
%    specified in fnMotlname.

function motl = writeInitMOTL(particles, fnMotlname)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: writeInitMOTL.m,v 1.5 2005/08/15 23:17:37 rickg Exp $\n');
end

if length(particles) > 1
  nParticles = length(particles);
else
  nParticles = particles;
  particles = 1:nParticles;
end
motl = zeros(20, nParticles);
motl(1,:) = 1;
motl(4,:) = particles;
motl(5,:) = 1;
tom_emwrite(fnMotlname, tom_emheader(motl));
