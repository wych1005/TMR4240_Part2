subplot(311)
plot(t, tau_d.Data(:, 1)/1000, 'linewidth', 1); grid on; hold on;
plot(t, tau_thr.Data(:, 1)/1000, 'linewidth', 1); hold off;
title('Thrust in X-direction')
xlabel('Time [s]'); ylabel('Thrust [kN]');

legend('Desired', 'Actual', 'orientation', 'horizontal', 'location', 'northoutside')

subplot(312)
plot(t, tau_d.Data(:, 2)/1000, 'linewidth', 1); grid on; hold on;
plot(t, tau_thr.Data(:, 2)/1000, 'linewidth', 1); hold off;
title('Thrust in Y-direction')
xlabel('Time [s]'); ylabel('Thrust [kN]');

subplot(313)
plot(t, tau_d.Data(:, 6)/1000, 'linewidth', 1); grid on; hold on;
plot(t, tau_thr.Data(:, 6)/1000, 'linewidth', 1); hold off;
title('Moment in Yaw-direction')
xlabel('Time [s]'); ylabel('Moment [kNm]');

set(gcf,'Position',[300 200 700 600])

if savePlots
print(['plotting/plots/sim' num2str(SimulationToRun) '_forces.eps'],'-depsc')
end