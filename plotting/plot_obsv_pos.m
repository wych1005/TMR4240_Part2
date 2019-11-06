if useEKF
    clf
    subplot(221)
    plot(t, eta.Data(:, 1), t, eta_hat.Data(:, 1), '--', 'linewidth', 1); grid on
    title('Position North'); xlabel('Time [s]'); ylabel('Position [m]'); hold on

    subplot(222);
    plot(t, eta.Data(:, 2), t, eta_hat.Data(:, 2), '--', 'linewidth', 1); grid on
    title('Position East'); xlabel('Time [s]'); ylabel('Position [m]'); hold on

    subplot(2,2,[3 4]);
    plot(t, rad2deg(eta.Data(:, 3)), t, rad2deg(eta_hat.Data(:, 3)),'--', 'linewidth', 1);
    title('Heading'); grid on; hold on;
    xlabel('Time [s]');
    ylabel('Heading [deg]');

else
%%
    subplot(221)
    plot(t, eta_hat.Data(:, 1), '-.', 'linewidth', 1); hold off
    subplot(222);
    plot(t, eta_hat.Data(:, 2), '-.', 'linewidth', 1); grid on; hold off
    
    
    subplot(2,2, [3 4]);
    plot(t, rad2deg(eta_hat.Data(:, 3)),'-.', 'linewidth', 1); hold off
    legend('Actual', 'EKF', 'NPO', 'orientation', 'horizontal', 'location', 'northoutside')
    
    if savePlots
    print(['plotting/plots/sim' num2str(SimulationToRun) '_obsv_xyz' sim4NoEnv '.eps'],'-depsc')
    end
end


set(gcf,'Position',[300 200 900 500])