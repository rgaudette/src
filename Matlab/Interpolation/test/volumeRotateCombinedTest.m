%volumeRotateTest


function volumeRotateTest(vol, vecPhi, vecTheta, vecPsi, method)

srchRadius = 10;
flgZeroMean = 1;
fprintf('Search radius %d  flgZeroMean %d\n', srchRadius, flgZeroMean);

nAngles = length(vecPhi) * length(vecTheta) * length(vecPsi);

for phi = vecPhi
  for theta = vecTheta
    for psi = vecPsi

      % Rotate the volume by the specified Euler angles
      rotFwd = volumeRotate(vol, [phi theta psi], [], method);

      % Inverse rotate the volume
      rotBkwd = volumeRotateInv(rotFwd, -1*[phi theta psi], [], method);
      
      % Compue the cross correlation coefficient
      [xcf peakCCC shift] = maskedCCC3(vol, rotBkwd, srchRadius, flgZeroMean);
      fprintf('phi %6.3f  theta %6.3f  psi %6.3f ', ...
              phi*180/pi, theta *180/pi, psi* 180/pi);
      fprintf('peak CCC %8.6f shift %d %d %d\n', peakCCC, shift);

    end
  end
end
