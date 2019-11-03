if useEKF
    clf
    subplot(211)
    plot(t, nu.Data(:, 1), t, nu.Data(:, 2), 'linewidth', 2); hold on
    plot(t, nu_hat.Data(:, 1), '--', t, nu_hat.Data(:, 2), '--', 'linewidth', 2); grid on

    title('Actual vs. Estimated speed')
    xlabel('Time [s]');
    ylabel('Speed [m/s]');

    subplot(212);
    plot(t, rad2deg(nu.Data(:, 3)), t, rad2deg(nu_hat.Data(:, 3)),'--', 'linewidth', 2);
    title('Actual vs Estimated angular velocity'); grid on; hold on;
    xlabel('Time [s]');
    ylabel('Angular Velocity [deg/s]');

else
%%
    subplot(211)
    plot(t, nu_hat.Data(:, 1), '-.', 'linewidth', 2); hold on
    plot(t, nu_hat.Data(:, 2), '-.', 'linewidth', 2); grid on
    
    legend('Actual X-speed', 'Actualy Y-speed', 'EKF X-speed', 'EKF Y-speed', 'NPO X-speed', 'NPO Y-speed');
    
    subplot(212);
    plot(t, rad2deg(nu_hat.Data(:, 3)),'-.', 'linewidth', 2);
    legend('Actual', 'EKF', 'NPO', 'location', 'best');
end


set(gcf,'Position',[300 200 600 700])