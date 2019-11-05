plot_init

if isempty(sim4NoEnv); figure(1);
else figure(3); end
plot_obsv_pos

if isempty(sim4NoEnv); figure(2);
else figure(4); end
plot_obsv_speed