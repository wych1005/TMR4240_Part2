disp('NPO Init');
EKF_init; % Required for the wave model

% Tuning values
w_o = 2*pi/9; % Wave peak frequency
lambda = 0.1;
w_c = 1.1 * w_o; % Filter cut off

T = eye(3) * 1000; % Bias time constants


K_1i = -2*(1-lambda) * w_c/w_o;
K_1i3 = 2*(1-lambda) * w_o;
K_2i = w_c;

K_1 = [diag([K_1i K_1i K_1i]);
       diag([K_1i3 K_1i3 K_1i3])];
   
K_2 = diag([K_2i K_2i K_2i]);

K_4 = diag([0.1 0.1 0.01]);
K_3 = 0.1 * K_4;


if w_o > w_c; error('NPO requires w_0 < w_ci'); end
if any(diag(K_3/K_4) > w_c); error('NPO requires K_3/K_4 > w_ci'); end
if any(1./diag(T) > diag(K_3/K_4)); error('NPO requires 1/T < K_3/K_4'); end