step = 30;
for phi1 = -180:step:180
  for theta1 = 0:step:180
    for psi1 = -180:step:180
      r1 = [phi1 theta1 psi1];
      
      for phi2 = -180:step:180
        for theta2 = 0:step:180
          for psi2 = -180:step:180
            r2 = [phi2 theta2 psi2];
            vDiff = rotateTest(r1, r2);
            if any(vec2norm(vDiff) > 1e-10)
              fprintf('error: ');
              fprintf('r1 %f %f %f', r1);
              fprintf('r2 %f %f %f\n', r2)
              vDiff
              error('')
            end
          end
        end
      end
    end
  end
end
