%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function takes the backward and forward estimated motion
% vectors and reconstructs the middle images in the video sequence.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function comp_img2 = motion_comp2(img1,img2,img3,x_mot_bck,y_mot_bck,x_mot_for,y_mot_for)

dim = size(x_mot_bck);
y_mot_dim = dim(1);
x_mot_dim = dim(2);

dim = size(img1);
y_sub_dim = dim(1);
x_sub_dim = dim(2);

blk_x = 8;
blk_y = 8;

% Compute compensated image intensities
for i=1:y_mot_dim
    for j=1:x_mot_dim
	% Inner loop dimensions correspond to block size
	for k=0:blk_y-1
            for l=0:blk_x-1
		% Account for possible edge problems

                % Y-dim back
		if (blk_y*(i-1)+1+k+y_mot_bck(i,j)<1)
                   y_pos_bck = 1;
		elseif (blk_y*(i-1)+1+k+y_mot_bck(i,j)>y_sub_dim)	
		   y_pos_bck = y_sub_dim;
		else
		   y_pos_bck = blk_y*(i-1)+1+k+y_mot_bck(i,j);
                end;

		% X-dim back
                if (blk_x*(j-1)+1+l+x_mot_bck(i,j)<1)
		   x_pos_bck = 1;
		elseif (blk_x*(j-1)+1+l+x_mot_bck(i,j)>x_sub_dim)	
		   x_pos_bck = x_sub_dim;
		else
		   x_pos_bck = blk_x*(j-1)+1+l+x_mot_bck(i,j);
		end;	

                % Y-dim forward
		if (blk_y*(i-1)+1+k+y_mot_for(i,j)<1)
                   y_pos_for = 1;
		elseif (blk_y*(i-1)+1+k+y_mot_for(i,j)>y_sub_dim)	
		   y_pos_for = y_sub_dim;
		else
		   y_pos_for = blk_y*(i-1)+1+k+y_mot_for(i,j);
                end;

		% X-dim forward
                if (blk_x*(j-1)+1+l+x_mot_for(i,j)<1)
		   x_pos_for = 1;
		elseif (blk_x*(j-1)+1+l+x_mot_for(i,j)>x_sub_dim)	
		   x_pos_for = x_sub_dim;
		else
		   x_pos_for = blk_x*(j-1)+1+l+x_mot_for(i,j);
		end;	

		% Generate compensated intensity value
		comp_img2(blk_y*(i-1)+1+k,blk_x*(j-1)+1+l)=(img1(y_pos_bck,x_pos_bck)+img3(y_pos_for,x_pos_for))/2;
	    end;
	end;
     end;
end;



