thrust_lim = [thrusters.thrust]./1000;

subplot(3,1,[1 2])
% subplot(311);
plot([0 t(end)], thrust_lim(1).*[1 1], '--k'); hold on
p1 = plot([0 t(end)], -thrust_lim(1).*[1 1], '--k');
p2 = plot(t, u_thr.Data(:, 1:2)./1000, 'k', 'linewidth', 1);
ylim(thrust_lim(1).*[-1.5 1.5])

% subplot(312);
plot([0 t(end)], thrust_lim(3).*[1 1], '--g'); hold on
p3 = plot([0 t(end)], -thrust_lim(3).*[1 1], '--g');
p4 = plot(t, u_thr.Data(:, 3)./1000, 'g', 'linewidth', 1);
ylim(thrust_lim(2).*[-1.5 1.5])

% subplot(313);
plot([0 t(end)], thrust_lim(5).*[1 1], '--r'); hold on
p5 = plot([0 t(end)], -thrust_lim(5).*[1 1], '--r');
p6 = plot(t, u_thr.Data(:, 4:5)./1000, '-r', 'linewidth', 1);
ylim(max(thrust_lim).*[-1.5 1.5])

set(get(get(p1(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
set(get(get(p2(2),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

set(get(get(p3(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
% set(get(get(p4(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');


set(get(get(p5(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
set(get(get(p6(2),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');


leg = legend('Tunnel limits', 'Tunnel thrusters', ...
       'Azi 1 Limits', 'Azi 1 thrust',...
       'Azi aft limits', 'Azi aft thrusters', ...
       'Orientation', 'horizontal', 'location', 'northoutside');
set(leg, 'NumColumns', 2);

title('Thruster forces');
xlabel('Times [s]');
ylabel('Thrust [kN]');
grid on

%%
subplot(313);
plot(t, rad2deg(alpha_thr.Data(:, 3)), 'linewidth', 1); hold on;
plot(t, rad2deg(alpha_thr.Data(:, 4)), 'linewidth', 1); grid on;
plot(t, rad2deg(alpha_thr.Data(:, 5)), 'linewidth', 1);
title('Azimuth direction');
xlabel('Time [s]'); ylabel('Angle [deg]'); hold off;
legend('Azi 1', 'Azi aft SB', 'Azi aft Port', 'orientation' ,'horizontal', 'location', 'northoutside')


set(gcf,'Position',[300 200 700 700])

if savePlots
print(['plotting/plots/sim' num2str(SimulationToRun) '_thrusters' sim2ThrFault '.eps'],'-depsc')
end