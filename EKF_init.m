%% Wave model
% Wave periods
T_w1 = 10;
T_w2 = 5;
T_w3 = 5;

% Wave damping
zeta_1 = 0.05;
zeta_2 = 0.1;
zeta_3 = 0.1;

% Wave frequencies and damping
Omega = diag(2*pi ./ [T_w1 T_w2 T_w3]);
Delta = diag([zeta_1 zeta_2 zeta_3]);

A_w = [zeros(size(Omega)),  eye(size(Omega));
           -Omega^2,            -2*Delta*Omega];
C_w = [zeros(3) eye(3)];

% Noise
K_w1 = 2;
K_w2 = 3;
K_w3 = 4;
K_w = diag([K_w1 K_w2 K_w3]);
       
E_w = [zeros(3)
       K_w];
   
%% Bias model
T_b1 = 1;
T_b2 = 1;
T_b3 = 1;
T_b = diag([T_b1, T_b2, T_b3]);

% Noise
E_b1 = 1;
E_b2 = 1;
E_b3 = 1;
E_b = diag([E_b1 E_b2 E_b3]);


%% Vessel mass and damping matrices
M = [6.8177e6       0           0
     0              7.8784e6    -2.5955e6
     0              -2.5955e6   3.57e9];
 
D = [2.6485e5       0           0
     0              8.8164e5    0
     0              0           3.3774e8];

B = [zeros(12, 3)
     inv(M)];
 
E = [E_w            zeros(6,3);
         zeros(3, 6);
     zeros(3)     E_b
         zeros(3, 6)];
     
H = [C_w     eye(3)     zeros(3, 6)];

%%
Q = diag([1000 10000 1000 0.00001 1000000 0.00001]);
R = diag([10 1 1000]);
P_0_priori = eye(15)*.1;    
x0 = zeros(15, 1);

 %%
kalman_data = struct('M',   M, ...
                     'D',   D, ...
                     'H',     H, ...
                     'B',     B, ...
                     'E',     E, ...
                     'Q',     Q, ...
                     'R',     R, ...
                     'A_w',   A_w, ...
                     'T_b',   T_b, ...
                     'P0',    P_0_priori, ...
                     'x0',    x0, ...
                     'Ts',    Ts);
save('kalman_data.mat', '-struct', 'kalman_data');

clear EKF_2
% sim('part2.slx')