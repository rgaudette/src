%  Compare my zeroed projection idea to a true zero value
%  projection
%
%  the input image is in the variable sl1

theta=[0:179];
idxSubIm = 256:768;
idxZero = [1:255 769:1024];
subSl1 = sl1;
subSl1(:,idxZero) = 0;


% Full size region
rsl1 = radon(sl1, theta);
irsl1 = iradon(rsl1, theta);

% non zero projected reconstruction
%rSubnzpSl1 = radon(subzpSl1, theta);
%iRSubnzpSl1 = iradon(rSubnzpSl1, theta);

% zeroed projection reconstruction
%rSubzpSl1 = zeroproj(rSubnzpSl1, theta, 51);
%iRSubzpSl1 = iradon(rSubzpSl1, theta);
