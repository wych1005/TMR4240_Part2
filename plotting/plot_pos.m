subplot(311);
plot(t, (eta.Data(:, 1)),  'linewidth', 2); grid on; hold on
if SimulationToRun > 2
    plot(t, (eta_ref.Data(:, 1)), 'linewidth', 2);
end
if SimulationToRun > 4
    plot(t, (eta_hat.Data(:, 1)), '--',  'linewidth', 2);
end
ylim([min(eta.Data(:, 1))*1.2 max(eta.Data(:, 1))*1.2]);

title('Position North');
xlabel('Time [s]'); ylabel('North [m]');
legend('Actual', 'Reference', 'Estimated', 'orientation', 'horizontal', 'location', 'northoutside');

subplot(312);
plot(t, (eta.Data(:, 2)),  'linewidth', 2); grid on; hold on
if SimulationToRun > 2
    plot(t, (eta_ref.Data(:, 2)), 'linewidth', 2);
end
if SimulationToRun > 4
    plot(t, (eta_hat.Data(:, 2)), '--',  'linewidth', 2);
end
ylim([min(eta.Data(:, 2))*1.2 max(eta.Data(:, 2))*1.2]);
title('Position East');
xlabel('Time [s]'); ylabel('East [m]');
% legend('Actual', 'Estimated', 'Reference');


subplot(313)
plot(t, rad2deg(eta.Data(:, 3)),  'linewidth', 2); grid on; hold on
if SimulationToRun > 2
    plot(t, rad2deg(eta_ref.Data(:, 3)), 'linewidth', 2);
end
if SimulationToRun > 4
    plot(t, rad2deg(eta_hat.Data(:, 3)), '--',  'linewidth', 2);
end
ylim(rad2deg([min(eta.Data(:, 3))*1.2 max(eta.Data(:, 3))*1.2]));
title('Heading');
xlabel('Time [s]'); ylabel('Heading [\psi]');

set(gcf,'Position',[300 200 600 600])