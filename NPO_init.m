EKF_init; % Required for the wave model

% Tuning values
w_oi = 2*pi/20; % Wave peak frequency
zeta_ni = 1;
lambda_i = 0.1;
w_ci = 1.1 * w_oi;

if w_oi > w_ci; error('NPO requires w_0 < w_ci'); end

T = eye(3) * 1000;

K_1i = -2 * (zeta_ni-lambda_i) * w_ci/w_oi;
K_1i3 = 2*w_oi*(zeta_ni-lambda_i);
K_2i = w_ci;

K_1 = [diag([K_1i K_1i K_1i]);
       diag([K_1i3 K_1i3 K_1i3])];
   
K_2 = diag([K_2i K_2i K_2i]);

K_3 = 0.1 * K_4;
K_4 = 0.1 * diag([1 1 0.1]);