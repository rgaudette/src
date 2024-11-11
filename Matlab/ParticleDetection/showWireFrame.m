function showWireFrame(wireFrame, curve)
nBoxes = size(wireFrame, 3);

clf
hold on
front = [1 5 6 2];
back = [3 7 8 4];
for iBox = 1:nBoxes
  plot3(wireFrame([1:4 1], 1, iBox),  wireFrame([1:4 1], 2, iBox),  ...
        wireFrame([1:4 1], 3, iBox));
  plot3(wireFrame([5:8 5], 1, iBox),  wireFrame([5:8 5], 2, iBox),  ...
        wireFrame([5:8 5], 3,iBox));  
  plot3(wireFrame(front, 1, iBox),  wireFrame(front, 2, iBox),  ...
        wireFrame(front, 3, iBox));  
  plot3(wireFrame(back, 1, iBox),  wireFrame(back, 2, iBox),  ...
        wireFrame(back, 3, iBox));  
end

if nargin > 1
  plot3(curve(:,1), curve(:,2), curve(:,3), 'r');
  plot3(curve(:,1), curve(:,2), curve(:,3), 'ro');
end
 
grid on
