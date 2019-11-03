plot_init

figure(1); clf
plot_xy(eta.Data(:, 1), eta.Data(:, 2), eta.Data(:, 3), t, true, 100);

% figure(2);
% plot_heading

figure(3); clf
plot_pos

figure(4); clf
plot_speed

figure(5); clf
plot_thrust

figure(6); clf
plot_thrusters