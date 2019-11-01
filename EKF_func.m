function x_hat = EKF(input)
if size(input) ~= [6 1]
    error('Invalid size on inputs, expected [eta,tau] := [3x1, 3x1]')
end

eta = input(1:3);
tau = input(4:6);
global Q_true
persistent x_pri P_pri init_flag f_x f_x_jacobi data R_psi

if isempty(init_flag)
    init_flag = 1;
    data = load('kalman_data.mat');
    
    P_pri = data.P0;
    x_pri = data.x0;

    % Calculate f(x) and the jacobian of f(x)
    xi = sym('xi', [6 1]);
    b = sym('b', [3 1]);
    nu = sym('nu', [3 1]);
    eta_sym = sym('eta', [3 1]);
    
    R_psi = @(psi) [cos(psi) -sin(psi) 0
            sin(psi)  cos(psi) 0
            0         0        1];   
    
    % Set up f(x) symbolically as an anonymous function
    f_x = @(xi, eta, b, nu) ...
        [data.A_w * xi
        R_psi(eta(3)) * nu
       -data.T_b\b
       -data.M\data.D*nu + data.M\R_psi(eta(3)).'*b];
   
    % Calculate the jacobian of f(x) symbolically
    f_x_jacobi_sym = jacobian(f_x(xi, eta_sym, b, nu), ...
                            [xi.' eta_sym.' b.' nu.']);
                        
    % Create an anonymous function of the symbolical jacobian of f(x)
    f_x_jacobi = matlabFunction(f_x_jacobi_sym, ...
                                'Vars', {[xi.' eta_sym.' b.' nu.'].'});
end

% Compute the kalmain gain
K = (P_pri * data.H')/(data.H * P_pri * data.H' + data.R);

% Update the estimate with measurements, gives aposteriori estimates
x_hat = x_pri + K * (eta - data.H*x_pri);

% Update the error covariance matrix
KH = K * data.H;
I = eye(size(KH));
P = (I - KH) * P_pri * (I - KH)' + K*data.R*K';

% Predict states and error covariance, gives a priori estimate
f_xuk = x_hat + ...
    data.Ts * (f_x(x_hat(1:6), x_hat(7:9), x_hat(10:12), x_hat(13:15)) + ...
                data.B * tau);

Phi = eye(size(P_pri)) + data.Ts * f_x_jacobi(x_hat(:));
Gamma = data.Ts * data.E;

P_pri = Phi * P * Phi' + Gamma * data.Q * Gamma';
x_pri = f_xuk;