if useEKF
    clf
    subplot(211)
    plot(t, eta.Data(:, 1), t, eta.Data(:, 2), 'linewidth', 2); hold on
    plot(t, eta_hat.Data(:, 1), '--', t, eta_hat.Data(:, 2), '--', 'linewidth', 2); grid on

    title('Actual vs. Estimated position')
    xlabel('Time [s]');
    ylabel('Position [m]');

    subplot(212);
    plot(t, rad2deg(eta.Data(:, 3)), t, rad2deg(eta_hat.Data(:, 3)),'--', 'linewidth', 2);
    title('Actual vs Estimated heading'); grid on; hold on;
    xlabel('Time [s]');
    ylabel('Heading [deg]');

else
%%
    subplot(211)
    plot(t, eta_hat.Data(:, 1), '-.', 'linewidth', 2); hold on
    plot(t, eta_hat.Data(:, 2), '-.', 'linewidth', 2); grid on
    
    legend('Actual X-pos', 'Actualy Y-pos', 'EKF X-pos', 'EKF Y-Pos', 'NPO X-Pos', 'NPO Y-Pos');
    
    subplot(212);
    plot(t, rad2deg(eta_hat.Data(:, 3)),'-.', 'linewidth', 2);
    legend('Actual', 'EKF', 'NPO', 'location', 'best');
end


set(gcf,'Position',[300 200 600 700])