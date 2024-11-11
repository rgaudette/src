% music.m --- computes a MUSIC spatial spectrum for a uniform linear array
%             with interelement spacing of half-wavelength.
%             
% Usage: [pdb eigval eigvec ] = music(x, nsrc, th)
%
% Inputs:   x    -- (nch x nsnap) data matrix
%           nsrc -- Expected number of sources -- number of signal eigenvalues
%                    to toss
%	    th   -- (npts x 1) vector of angles [degrees].
%
% Outputs:  pdb  -- (npts x 1) vector of MUSIC spectrum values at the angles
%                    of th [dB].
%	    eigval  (nch x 1) vector of the eigenvalues.
%
%	    eigvec  (nch x nch) matrix of the eigvectors.
%		    both eigval & eigvec are in the same form as the MATLAB
%		    eig routine.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:03 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: music_j.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:03  rickg
%  Matlab Source
%
%  
%     Rev 1.3   01 Sep 1993 15:05:14   rjg
%  Added units to help comments.
%  
%     Rev 1.2   03 Mar 1993 20:02:24   rjg
%  Now returns eigenvalues & eigenvectors with spacial spectrum.
%  
%     Rev 1.1   22 Feb 1993 16:34:06   rjg
%  Added entry of theta as a calling parameter.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [pdb, eigval, eigvec] = music(x, nsrc, th)

[nch,nsnap]=size(x);
npts = length(th);

rxx = (x*x') / nsnap;
[eigvec lambda] = eig(rxx);
eigval = diag(lambda);
lvec = todb1(eigval);

%%
%%  Order the eigenvalues from largest to smallest
%%
[lvec ilvec] = sort(lvec);
lvec = flipud(lvec);
ilvec = flipud(ilvec);

% Denote the noise eigenvectors as those corresponding to the
%  smallest nch-nsrc eigenvalues

en = eigvec(:, ilvec(nsrc+1:nch)); % The noise eigenvectors

u=svlin(nch,th);

% Inner product of steering vectors with noise eigenvectors

y=en'*u;

p=zeros(npts,1);
for k=1:npts,
    p(k)=1/(y(:,k)'*y(:,k));
end

pdb=todb1(p);

% Find the peak locations

[pdbord,iord]=sort(pdb);
pdbord=flipud(pdbord);
iord=flipud(iord);
thord=th(iord);
aoaest=thord(1:nsrc);

return
