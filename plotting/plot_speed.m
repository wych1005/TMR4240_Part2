subplot(221);
plot(t, (nu.Data(:, 1)),  'linewidth', 1); grid on; hold on
if SimulationToRun > 1
    plot(t, (nu_ref.Data(:, 1)), 'linewidth', 1);
end
if SimulationToRun > 4
    plot(t, (nu_hat.Data(:, 1)), '--',  'linewidth', 1);
end
xlim([0 t(end)])

title('Velocity North');
xlabel('Time [s]'); ylabel('Speed [m/s]');

subplot(222);
plot(t, (nu.Data(:, 2)),  'linewidth', 1); grid on; hold on
if SimulationToRun > 1
    plot(t, (nu_ref.Data(:, 2)), 'linewidth', 1);
end
if SimulationToRun > 4
    plot(t, (nu_hat.Data(:, 2)), '--',  'linewidth', 1);
end
xlim([0 t(end)])

title('Velocity East');
xlabel('Time [s]'); ylabel('Speed [m/s]');

subplot(2,2, [3 4]);
plot(t, rad2deg(nu.Data(:, 3)),  'linewidth', 1); grid on; hold on
if SimulationToRun > 1
    plot(t, rad2deg(nu_ref.Data(:, 3)), 'linewidth', 1);
end
if SimulationToRun > 4
    plot(t, rad2deg(nu_hat.Data(:, 3)), '--',  'linewidth', 1);
end

legend('Actual', 'Reference', 'Estimated', 'orientation', 'horizontal', 'location', 'northoutside');

title('Velocity Heading');
xlabel('Time [s]'); ylabel('Speed [deg/s]');

set(gcf,'Position',[300 200 700 500])

if savePlots
print(['plotting/plots/sim' num2str(SimulationToRun) '_speed' sim2ThrFault '.eps'],'-depsc')
end