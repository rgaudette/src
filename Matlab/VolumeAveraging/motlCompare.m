%motlCompare Compare the alignment parameters of two motive lists

function motlCompare(motl_1, label_1, motl_2, label_2)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: motlCompare.m,v 1.3 2005/08/15 23:17:36 rickg Exp $\n');
end

lt1 = 'b--';
lt2 = 'b-.';

% Compare the rotation parameters

% Nomralize?? the phi and theta 
% nParticles = size(motl_1, 2);
% for iParticle = 1:nParticles
% if motl(18, iParticle) ~= 0
%     diffPhi_1 = motl(17, iParticle) - motl(18, iParticle);
%     diffTheta_1 = + motl(19, iParticle);
%   else
% 	  diffPhi_1 = motl(17, iParticle);
%     diffTheta_1 = motl(19, iParticle);
%   end
% end

figure(1)
clf
[dnPhi_1 dnTheta_1 dnPsi_1] =eulerDenormalize(motl_1)
[dnPhi_2 dnTheta_2 dnPsi_2] =eulerDenormalize(motl_2)
subplot(3,1,1)
plot(dnPhi_1, lt1)
hold on
plot(dnPhi_2, lt2)
xlabel('Particle index');
ylabel('Rotation');
title('Phi');
grid on

subplot(3,1,2)
plot(dnTheta_1, lt1)
hold on
plot(dnTheta_2, lt2)
grid on
xlabel('Particle index');
ylabel('Rotation');
title('Theta');

subplot(3,1,3)
plot(dnPsi_1, lt1)
hold on
plot(dnPsi_2, lt2)
grid on
xlabel('Particle index');
ylabel('Rotation');
title('Psi');
legend(label_1, label_2)

% Compare the shift parameters
figure(2)
clf
subplot(3,1,1)
plot(motl_1(11,:), lt1)
hold on
plot(motl_2(11,:), lt2)
xlabel('Particle index');
ylabel('Shift value');
title('X axis');
grid on

subplot(3,1,2)
plot(motl_1(12,:), lt1)
hold on
plot(motl_2(12,:), lt2)
grid on
xlabel('Particle index');
ylabel('Shift value');
title('Y axis');

subplot(3,1,3)
plot(motl_1(13,:), lt1)
hold on
plot(motl_2(13,:), lt2)
grid on
xlabel('Particle index');
ylabel('Shift value');
title('Y axis');
legend(label_1, label_2)

orient landscape

function [dnPhi dnTheta dnPsi] = eulerDenormalize(motl)
% Normalize?? the phi and theta 
 nParticles = size(motl, 2);
for iParticle = 1:nParticles
if motl(18, iParticle) ~= 0
    dnPhi(iParticle) = motl(17, iParticle) - motl(18, iParticle);
    dnTheta(iParticle)= + motl(19, iParticle);
    dnPsi(iParticle) = motl(18, iParticle);
  else
	  dnPhi(iParticle) = motl(17, iParticle);
    dnTheta(iParticle) = motl(19, iParticle);
    dnPsi(iParticle) = motl(18, iParticle);
  end
end

