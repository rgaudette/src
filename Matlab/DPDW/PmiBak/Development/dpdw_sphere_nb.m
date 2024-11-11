%DPDW_SPHERE_NB Compute the DPDW response from a spherical inhomogeneity.
%
%   [phi_scat phi_inc] = ...
%       dpdw_sphere_nb(pSrc, pDet, w, v, opBack, opSphere, radius, L, Debug)
%
%   phi_scat    The scattered field at each detector.
%
%   phi_inc     The incident field at each detector.
%
%   pSrc        The position of the sources, realtive to the center of the
%               sphere [x y z].
%
%   pDet        The position of the detectors, realtive to the center of the
%               sphere, each row contains the poistion of a detector.
%
%   w           The radian frequency of the source modulation.
%
%   v           The velocity of propagation in the medium.
%
%   opBack      The optical propoerties of the background.  A structure with
%               the field mu_sp and mu_a.
%
%   opSphere    The optical propoerties of the sphere.  A structure with
%               the field mu_sp and mu_a.
%
%   radius      The radius of the sphere.
%
%   L           The order of the approximation, 0,1,...,L.
%
%   Debug       OPTIONAL: Print out debugging info.
%
%   DPDW_SPHERE_NB computes the DPDW response from a spherical inhomogenity
%   in a free space diffusive medium.  The scattered and incident field for
%   a number of detectors from a single source are computed.  Note that this
%   function assumes that the center of the sphere is the origin of the
%   coordinate system.
%
%   Ref: Diffuse Photon Probes of Structureal and Dymanical Properties of
%   Turbid Media: Theory and Biomedical Applications,  David Boas
%   (Ph.D. Thesis), 1996, University of Pennsylvania
%
%   Calls: spbesselj, spbesselh, spbesselj_d1, spbesselh_d1, spharmonic.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:32 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: dpdw_sphere_nb.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:32  rickg
%  Matlab Source
%
%  Revision 1.2  1999/02/10 18:08:31  rjg
%  Added the ability to compute response from multiple sources.
%  Changed spherical Hankel functions to second kind in A_l_m
%  calculations.  This seems to give the best agreement with born
%  and PMI?
%  Added incident field calculation.
%
%  Revision 1.1  1999/02/05 19:35:37  rjg
%  Added forgotten K coefficent in A_{l,m}
%
%  Revision 1.0  1999/02/04 21:20:04  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [phi_scat, phi_inc] = ...
    dpdw_sphere_nb(pSrc, pDet, w, v, opBack, opSphere, radius, L, Debug)
if nargin < 9
    Debug = 0;
    if nargin < 8
        L = 2;
    end
end

nSrc = size(pSrc, 1);
nDet = size(pDet, 1);
phi_scat = zeros(nSrc*nDet, 1);
phi_inc = zeros(nSrc*nDet, 1);

%%
%%  Compute the medium parameters
%%
%D_in = v / (3 * (opSphere.mu_sp + opSphere.mu_a));
disp('Using David''s defn: D = v / (3 * mu_sp)')
D_in = v / (3 * (opSphere.mu_sp ));
k_in = sqrt((-v * opSphere.mu_a + j * w) / D_in);

%D_out = v / (3 * (opBack.mu_sp + opBack.mu_a));
D_out = v / (3 * (opBack.mu_sp));
k_out = sqrt((-v * opBack.mu_a + j * w) / D_out);
if Debug
    fprintf('D_in:  %e\n', D_in);
    fprintf('k_in:  %e + j %e\n', real(k_in), imag(k_in));
    fprintf('D_out: %e\n', D_out);
    fprintf('k_out: %e + j %e\n', real(k_out), imag(k_out));
end
%%
%%  Loop over each of the sources
%%
if Debug
    fprintf('Src: ');
end

for iSrc = 1:nSrc
    if Debug
        fprintf('%d  ', iSrc);
    end
    
    Src = pSrc(iSrc, :);
    idxBlk = [((iSrc-1) * nDet + 1):iSrc*nDet];
    %%
    %%  Compute the distance to the source, this will also become the new
    %%  -z direction, also the distance to the detectors.
    %%
    rSrc = norm(Src);
    rDet = sqrt(sum((pDet') .^2))';

    %%
    %%  Compute the angle of each detector relative to the z axis.
    %%
    theta = acos(sum((repmat(Src, nDet, 1) .* pDet)')' ./ (rSrc .* rDet)) + pi;

    %%
    %%  Loop over the requested order of the approximation
    %%
    x = k_out * radius;
    y = k_in * radius;

    for l = 0:L
        c0 = j * v / D_out * k_out * spbesselh(l, 1, k_out*rSrc) * ...
            spharmonic(l, 0, pi, 0);

        j_l_x = spbesselj(l, x);
        dj_l_x = spbesselj_d1(l, x);

        j_l_y = spbesselj(l, y);
        dj_l_y = spbesselj_d1(l, y);

        h_l_x = spbesselh(l, 1, x);
        dh_l_x = spbesselh_d1(l, 1, x);

        Al = c0 * ...
            ((D_out * x * dj_l_x * j_l_y - D_in * y * j_l_x * dj_l_y) / ...
            (D_out * x * dh_l_x * j_l_y - D_in * y * h_l_x * dj_l_y));

        phi_scat(idxBlk) = phi_scat(idxBlk) + ...
            Al * spbesselh(l, 1, k_out * rDet) .* ...
            spharmonic(l, 0, theta, 0);
    end

    %%
    %%  Compute the incident response at each detector for the current
    %%  source.
    %%
    rsrcdet = sqrt(sum(((repmat(Src, nDet, 1) - pDet).^2)'));
    phi_inc(idxBlk) = v / D_out * ...
        exp(j * k_out * rsrcdet) ./ (4 * pi * rsrcdet);
    
end
if Debug
    fprintf('\n');
end
