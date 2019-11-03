plot(t, rad2deg(eta.Data(:, 3)),  'linewidth', 2); grid on; hold on
plot(t, rad2deg(eta_hat.Data(:, 3)), '--',  'linewidth', 2);
plot(t, rad2deg(eta_ref.Data(:, 3)), 'linewidth', 2);

title('Heading');
xlabel('Time [s]'); ylabel('Heading [deg]');

legend('Actual heading', 'Estimated heading', 'Reference heading', 'location', 'best');