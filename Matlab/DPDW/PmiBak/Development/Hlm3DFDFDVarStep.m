%Hlm3DFDFDVarStep
%
%   phi = Hlm3DFDFDVarStep(ksq, S, hx, hy, hz)
%
%   result      Output description.
%
%   parm        Input description [units: MKS].
%
%   Optional    OPTIONAL: This parameter is optional (default: value).
%
%
%   TEMPLATE Describe function, it's methods and results.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:33 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: Hlm3DFDFDVarStep.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:33  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function phi = Hlm3DFDFDVarStep(ksq, S, hx, hy, hz)


%%
%%  Preallocate the sparse operator matrix
%%
hx = hx(:);
hy = hy(:);
hz = hz(:);
nX = length(hx);
nY = length(hy);
nZ = length(hz);
nElem = nX * nY * nZ;
nNZ = (nX-2) * (nY-2) * (nZ-2) * 7 + 2 * ((nX*nY)+(nX*nZ)+(nZ*nY)) * 6
A = sparse([],[],[], nElem, nElem, nNZ);

nDomain = [nY nX nZ];

%%
%%  Fill in coefficients
%%
for iZ = 1:nZ
    if iZ > 1
        zPrev =  2 / (hz(iZ-1) * (hz(iZ) + hz(iZ-1)));
        zCurr = -2 / (hz(iZ) * hz(iZ-1));
        zNext =  2 / (hz(iZ) * (hz(iZ) + hz(iZ-1)));
    else
        zNext =  1 / (hz(1)^2);
        zCurr = -2 * zNext;
    end

        
    for iX = 1:nX
        if iX > 1
            xPrev =  2 / (hx(iX-1) * (hx(iX) + hx(iX-1)));
            xCurr = -2 / (hx(iX) * hx(iX-1));
            xNext =  2 / (hx(iX) * (hx(iX) + hx(iX-1)));
        else
            xNext =  1 / (hx(1)^2);
            xCurr = -2 * xNext;

        end

        
        idxR = sub2ind(nDomain, [1:nY]', repmat(iX, nY, 1), repmat(iZ, nY, 1));

        %%
        %%  Previous Y element
        %%
        yPrev =  2 ./ (hy(1:nY-1) .* (hy(2:nY) + hy(1:nY-1)));
        idxC = sub2ind(nDomain, [1:nY-1]', repmat(iX, nY-1, 1), ...
            repmat(iZ, nZ-1, 1));
        A(sub2ind([nElem nElem], idxR(2:end), idxC)) = yPrev;
        
        %%
        %%  Current Y element
        %%
        yCurr = -2 ./ ([hy(1); hy(1:nY-1)] .* hy);
        A(sub2ind([nElem nElem], idxR, idxR)) = xCurr + zCurr + yCurr + ...
            ksq(:, iX, iZ);
            
        %%
        %%  Next Y element
        yNext =  2 ./ (hy(2:nY) .* (hy(2:nY) + hy(1:nY-1)));
        idxC = sub2ind(nDomain, [2:nY]', repmat(iX, nY-1, 1) , ...
            repmat(iZ, nY-1, 1));
        A(sub2ind([nElem nElem], idxR(1:end-1), idxC)) = yNext;

        %%
        %%  X neighbors
        %%
        if iX > 1
            idxC = sub2ind(nDomain, [1:nY]', repmat(iX-1, nY, 1), ...
                repmat(iZ, nY, 1));
            A(sub2ind([nElem nElem],idxR, idxC)) = xPrev;
        end
        if iX < nX
            idxC = sub2ind(nDomain, [1:nY]', repmat(iX+1, nY, 1), ...
                repmat(iZ, nY, 1));
            A(sub2ind([nElem nElem], idxR, idxC)) = xNext;
        end
            
        %%
        %%  Z neighbors
        %%
        if iZ > 1
            idxC = sub2ind(nDomain, [1:nY]', repmat(iX, nY, 1), ...
                repmat(iZ-1, nY, 1));
            A(sub2ind([nElem nElem], idxR, idxC)) = zPrev;
        end
        if iZ < nZ
            idxC = sub2ind(nDomain, [1:nY]', repmat(iX, nY, 1), ...
                repmat(iZ+1, nY, 1));
            A(sub2ind([nElem nElem], idxR, idxC)) = zNext;
        end
    end
end

phi =  A \ S(:);
