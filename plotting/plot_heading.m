plot(t, rad2deg(eta.Data(:, 3)),  'linewidth', 2); grid on; hold on
if SimulationToRun > 2
    plot(t, rad2deg(eta_ref.Data(:, 3)), 'linewidth', 2);
end
if SimulationToRun > 4
    plot(t, rad2deg(eta_hat.Data(:, 3)), '--',  'linewidth', 2);
end

title('Heading');
xlabel('Time [s]'); ylabel('Heading [deg]');

legend('Actual heading', 'Reference heading', 'Estimated heading', 'location', 'best');