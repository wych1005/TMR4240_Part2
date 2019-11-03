subplot(311);
plot(t, (nu.Data(:, 1)),  'linewidth', 2); grid on; hold on
if SimulationToRun > 2
    plot(t, (nu_ref.Data(:, 1)), 'linewidth', 2);
end
if SimulationToRun > 4
    plot(t, (nu_hat.Data(:, 1)), '--',  'linewidth', 2);
end

title('Velocity North');
xlabel('Time [s]'); ylabel('Speed [m/s]');
legend('Actual', 'Reference', 'Estimated', 'orientation', 'horizontal', 'location', 'northoutside');

subplot(312);
plot(t, (nu.Data(:, 2)),  'linewidth', 2); grid on; hold on
if SimulationToRun > 2
    plot(t, (nu_ref.Data(:, 2)), 'linewidth', 2);
end
if SimulationToRun > 4
    plot(t, (nu_hat.Data(:, 2)), '--',  'linewidth', 2);
end

title('Velocity East');
xlabel('Time [s]'); ylabel('Speed [m/s]');

subplot(313);
plot(t, (nu.Data(:, 3)),  'linewidth', 2); grid on; hold on
if SimulationToRun > 2
    plot(t, (nu_ref.Data(:, 3)), 'linewidth', 2);
end
if SimulationToRun > 4
    plot(t, (nu_hat.Data(:, 3)), '--',  'linewidth', 2);
end

title('Velocity Heading');
xlabel('Time [s]'); ylabel('Speed [m/s]');

set(gcf,'Position',[300 200 600 500])