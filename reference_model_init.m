% Use Refecende model?
useRefM = 1;

% Reference model
omega_refm = [0.03 0.03 0.05];
delta_refm = [1 1 1];

% Saturation limits
nu_sat = [1 1 deg2rad(200/60)]; % Velocity
nu_dot_sat = [inf inf inf]; % Acceleration