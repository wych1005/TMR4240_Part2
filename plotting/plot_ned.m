% NED position
% plot(eta.Data(:, 2), eta.Data(:, 1), '-', 'LineWidth', 2); hold on
% plot(eta.Data(1, 2), eta.Data(1, 1), 'r*');
% plot(eta.Data(end, 2), eta.Data(end, 1), 'r^');
plot_xy(eta.Data(:, 1), eta.Data(:, 2), eta.Data(:, 3), t, true, 20)
% title('NED-position')
% xlabel('East [m]'); ylabel('North [m]');
% legend('Trajectory', 'Initial Position', 'Final Position', 'location', 'Best')

grid on;
axis equal

if savePlots
print(['plotting/plots/sim' num2str(SimulationToRun) '_ned.eps'],'-depsc')
end