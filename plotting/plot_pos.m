subplot(221);
plot(t, (eta.Data(:, 1)),  'linewidth', 1); grid on; hold on
if SimulationToRun > 1
    plot(t, (eta_ref.Data(:, 1)), 'linewidth', 1);
end
if SimulationToRun > 4
    plot(t, (eta_hat.Data(:, 1)), '--',  'linewidth', 1);
end
ylim([min(eta.Data(:, 1))*1.2 max(eta.Data(:, 1))*1.2]);
xlim([0 t(end)])

title('Position North');
xlabel('Time [s]'); ylabel('North [m]');

subplot(222);
plot(t, (eta.Data(:, 2)),  'linewidth', 1); grid on; hold on
if SimulationToRun > 1
    plot(t, (eta_ref.Data(:, 2)), 'linewidth', 1);
end
if SimulationToRun > 4
    plot(t, (eta_hat.Data(:, 2)), '--',  'linewidth', 1);
end
ylim([min(eta.Data(:, 2))*1.2 max(eta.Data(:, 2))*1.2]);
xlim([0 t(end)])

title('Position East');
xlabel('Time [s]'); ylabel('East [m]');
% legend('Actual', 'Estimated', 'Reference');


subplot(2,2,[3 4])
plot(t, rad2deg(eta.Data(:, 3)),  'linewidth', 1); grid on; hold on
if SimulationToRun > 1
    plot(t, rad2deg(eta_ref.Data(:, 3)), 'linewidth', 1);
end
if SimulationToRun > 4
    plot(t, rad2deg(eta_hat.Data(:, 3)), '--',  'linewidth', 1);
end

legend('Actual', 'Reference', 'Estimated', 'orientation', 'horizontal', 'location', 'northoutside');
ylim(rad2deg([min(eta.Data(:, 3))*1.2 max(eta.Data(:, 3))*1.2]));
title('Heading');
xlabel('Time [s]'); ylabel('Heading [\psi]');

set(gcf,'Position',[300 200 700 500])

if savePlots
print(['plotting/plots/sim' num2str(SimulationToRun) '_xyz' sim2ThrFault '.eps'],'-depsc')
end