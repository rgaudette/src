
function err = errcomp_dgsvd(xtrue, xrec)

[junk ntest]= size(xrec);
err = zeros(ntest,1);
for i = 1:ntest
    err(i) = norm(xtrue - xrec(:,i));
end
