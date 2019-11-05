plot_init

figure(1); clf
ax = polaraxes;
polarplot(ax, deg2rad(thrAvgData(:, 1)), thrAvgData(:, 2), '*-')
ax.ThetaDir = 'clockwise';
ax.ThetaZeroLocation = 'top';
thetaticks(0:10:360)
rlim([0 1.2*ceil(max(thrAvgData(:, 2)))])
rticks(0:10:ceil(max(thrAvgData(:, 2)))*1.2);

title({'Thruster capability plot', ...
    sprintf('$U_w = %.1f$ [m/s], $U_c = %.1f$ [m/s], $H_s = %.1f$ [m], $T_p = %.1f$ [s]', 15, 0.2, 15, 10)}, 'interpreter', 'latex')


set(gcf,'Position',[300 200 700 700])

if savePlots
print(['plotting/plots/sim' num2str(SimulationToRun) '_capability.eps'],'-depsc')
end