plot_init

figure(1);
plot_xy(eta.Data(:, 1), eta.Data(:, 2), eta.Data(:, 3), t, true, 20);
if savePlots
print(['plotting/plots/sim' num2str(SimulationToRun) '_ned.eps'],'-depsc')
end

% figure(2);
% plot_heading

figure(3);
plot_pos