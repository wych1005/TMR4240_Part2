if useEKF
    clf
    subplot(221)
    plot(t, nu.Data(:, 1), t, nu_hat.Data(:, 1), '--', 'linewidth', 1); grid on
    title('Velocity North'); xlabel('Time [s]'); ylabel('Velocity [m/s]'); hold on

    subplot(222);
    plot(t, nu.Data(:, 2), t, nu_hat.Data(:, 2), '--', 'linewidth', 1); grid on
    title('Velocity East'); xlabel('Time [s]'); ylabel('Velocity [m/s]'); hold on

    subplot(2,2,[3 4]);
    plot(t, rad2deg(nu.Data(:, 3)), t, rad2deg(nu_hat.Data(:, 3)),'--', 'linewidth', 1);
    title('Heading rate'); grid on; hold on;
    xlabel('Time [s]');
    ylabel('Angular Velocity [deg]');

else
%%
    subplot(221)
    plot(t, nu_hat.Data(:, 1), '-.', 'linewidth', 1); hold on
    subplot(222);
    plot(t, nu_hat.Data(:, 2), '-.', 'linewidth', 1); grid on
    
    
    subplot(2,2, [3 4]);
    plot(t, rad2deg(nu_hat.Data(:, 3)),'-.', 'linewidth', 1);
    legend('Actual', 'EKF', 'NPO', 'orientation', 'horizontal', 'location', 'northoutside')
end


set(gcf,'Position',[300 200 700 500])

if savePlots
saveas(gcf,['plotting/plots/sim' num2str(SimulationToRun) '_obsv_speed.eps']);
end