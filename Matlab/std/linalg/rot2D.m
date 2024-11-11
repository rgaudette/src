%rot2D          Compute a 2D rotation matrix
function r = rot2D(theta);
 r = [cos(theta) sin(theta)
      -sin(theta) cos(theta)];
 
