% Tuning values
w_0 = 2*pi/20; % Wave peak frequency
zeta_ni = 1;
lambda_i = 0.5;
w_ci = 1.1 * w_0;

K_1i = -2 * (zeta_ni-lambda_i) * w_ci/w_0;
K_1i3 = 2*w_0*(zeta_ni-lambda_i);
K_2i = w_ci;

K_1 = [diag([K_1i K_1i K_1i]);
       diag([K_1i3 K_1i3 K_1i3])];
   
K_2 = diag([K_2i K_2i K_2i]);
K_3 = 1 * diag([1 1 1]);
K_4 = K_3 / (w_0/10);