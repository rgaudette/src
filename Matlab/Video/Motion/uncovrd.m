function [newCompImg, tmpCompImg] = uncovrd(compImg,predImg);

[yDim xDim] = size(compImg);
tmpCompImg = compImg;
newCompImg = compImg;

binImg = 255*ones(yDim,xDim);

%
% Find uncovered border pixels
%
uncovrdIdx = find(compImg==0);

%
% Create binary image from uncovered pixel areas. 
% Background = 255, edges = 0;
%
binImg(uncovrdIdx) = zeros(length(uncovrdIdx),1);

%
% Erode binary image to remove non-boundary vertical and
% horizontal edges
%
bndImg = erodeIm(binImg);

%
% Dilate binary image to add in band of boundary pixels
% which was removed due to erosion
%
bndImg = dilateIm(bndImg);

%
% Fill in boundary pixels with previous reconstructed image values
%
bndIdx = find(bndImg==0);
tmpCompImg(uncovrdIdx) = predImg(uncovrdIdx);
newCompImg(bndIdx) = predImg(bndIdx);

%
% Detect occurences of the following templates in the 
% boundary image: [255 0] [0 255] [255 0]' [0 255]'
% For each transition detected, replace both corresponding
% pixels in newCompImg with the average of their 
% directionally adjacent neighbors.
% 

%
% Detect [255 0] 
%
idx = find(bndImg(:,1:xDim-1)==255 & bndImg(:,2:xDim)==0);
newCompImg(idx) = (tmpCompImg(idx)+tmpCompImg(idx-yDim)+tmpCompImg(idx+yDim))/3;
idx = idx+yDim;
newCompImg(idx) = (tmpCompImg(idx)+tmpCompImg(idx-yDim)+tmpCompImg(idx+yDim))/3;

%
% Detect [0 255]
%
idx = find(bndImg(:,1:xDim-1)==0 & bndImg(:,2:xDim)==255);
newCompImg(idx) = (tmpCompImg(idx)+tmpCompImg(idx-yDim)+tmpCompImg(idx+yDim))/3;
idx = idx+yDim;
newCompImg(idx) = (tmpCompImg(idx)+tmpCompImg(idx-yDim)+tmpCompImg(idx+yDim))/3;

%
% Transpose bndImg, tmpCompImg and newCompImg
% 
bndImg = bndImg';
tmpCompImg = tmpCompImg';
newCompImg = newCompImg';

%
% Detect [255 0]' 
%
idx = find(bndImg(:,1:yDim-1)==255 & bndImg(:,2:yDim)==0);
newCompImg(idx) = (tmpCompImg(idx)+tmpCompImg(idx-xDim)+tmpCompImg(idx+xDim))/3;
idx = idx+xDim;
newCompImg(idx) = (tmpCompImg(idx)+tmpCompImg(idx-xDim)+tmpCompImg(idx+xDim))/3;

%
% Detect [0 255]'
%
idx = find(bndImg(:,1:yDim-1)==0 & bndImg(:,2:yDim)==255);
newCompImg(idx) = (tmpCompImg(idx)+tmpCompImg(idx-xDim)+tmpCompImg(idx+xDim))/3;
idx = idx+xDim;
newCompImg(idx) = (tmpCompImg(idx)+tmpCompImg(idx-xDim)+tmpCompImg(idx+xDim))/3;

tmpCompImg = tmpCompImg';
newCompImg = newCompImg';

% 
% For the non-boundary edges, average the previous reconstructed
% image values in a 4-connected sense to generate the pixels in
% newCompImg.
%
tmpCompImg = -1*ones(yDim+2,xDim+2);
tmpCompImg(2:yDim+1,2:xDim+1) = newCompImg;
nonBndIdx = find(tmpCompImg==0);

tmpCompImg = zeros(yDim+2,xDim+2);
tmpCompImg(2:yDim+1,2:xDim+1) = newCompImg;
newCompImg = tmpCompImg;

for i=1:length(nonBndIdx)
        count = 0;
	%
	% Count number of non-zero neighbors
	%
        
        % Upper neighbor check
	if (tmpCompImg(nonBndIdx(i)-1)~=0)
	   count = count + 1;
        end;

	% Lower neighbor check
	if (tmpCompImg(nonBndIdx(i)+1)~=0)
	   count = count + 1;
	end;

	% Left neighbor check
	if (tmpCompImg(nonBndIdx(i)-(yDim+2))~=0)
	   count = count + 1;
	end;

	% Right neighbor check
	if (tmpCompImg(nonBndIdx(i)+(yDim+2))~=0)
	   count = count + 1;
	end;

        if (count ~= 0)
	   newCompImg(nonBndIdx(i)) = (tmpCompImg(nonBndIdx(i)-1)+...
           tmpCompImg(nonBndIdx(i)+1) + tmpCompImg(nonBndIdx(i)-(yDim+2)) +...
           tmpCompImg(nonBndIdx(i)+(yDim+2)))/count;
        end;
end;

%
% Extract border
%
tmpCompImg = tmpCompImg(2:yDim+1,2:xDim+1);
newCompImg = newCompImg(2:yDim+1,2:xDim+1);

%
% Check to insure no more uncovered areas. If so, fill in with values
% from predicted image
%
idx = find(newCompImg==0);
newCompImg(idx) = predImg(idx);



