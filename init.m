%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% init()                                                                  %
%                                                                         %
% Set initial parameters for part1.slx and part2.slx                      %
%                                                                         %
% Created:      2018.07.12	Jon Bjørnø                            %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

addpath('simulink');
addpath('plotting');

load('supply.mat');
load('supplyABC.mat');
load('thrusters_sup.mat');

% Initial position x, y, z, theta, phi, psi
eta0 = [0,0,0,0,0,0]';
% Initial velocity u, v, w, p, q, r
nu0 = [0,0,0,0,0,0]';

Ts = 0.1; % Step size

simFile = "part2_main.slx";

EKF_init;
NPO_init;
reference_model_init;
DP_controller_init;

savePlots = false; % true: Save plots as ESP in the /plots folder

% SimulationToRun = 6; % Manual control in simulink
SimulationToRun = input('Select which task to simulate, from 1 to 7 or 8 for Simulink control: '); 
if SimulationToRun < 1 || SimulationToRun > 8
    error('There is no such task');
end

sim6CurrentAngle = 0;
sim4NoEnv = '';
sim2ThrFault = '';

useEKF = true;
useRefM = true;
useWindM = true;
useWaveM = true;
useObsv = true;
useThr = true;
useCurrentM = true;

simTimes = [0 300;
            0 1600;
            0 2000;
            0 200;
            0 1600;
            0 400;
            0 1000];

load_system(simFile); load_system('wind_model.slx');
% Configure waves
set_param('part2_main/Wave', 'waveforces', 'on');
set_param('part2_main/Waves', 'hs', '2.5'); % 2.5 m
set_param('part2_main/Waves', 'omega_peak', '2*pi/9'); %Tp = 9s
set_param('part2_main/Waves', 'psi_mean', 'pi*5/4'); % From NE

% Configure wind
set_param('wind_model/Wind1', 'u_mean_10', '10'); %Avg speed 10 m/s
set_param('wind_model/Wind1', 'dir_mean', 'pi'); % From north

%% Simulation 1
%%Simulate for 300 seconds with current from East, with average speed of 0.2 [m/s] and wind
% from the north, with average speed of 10 [m/s]. Waves from Northeast with a significant
% wave height Hs of 2.5 [m] and a peak wave period Tp of 9 [s]. Note that the wind and
% current direction slow variation shall not exceed 5 degrees. Use the same parameters as in
% Assignment 5

if SimulationToRun == 1  
    useThr = false;
%     run(['plotting_' num2str(SimulationToRun )]);
end

%% Simulation 2
% Disable the environmental forces and plot the desired force calculated by your controller,
% the force applied by the thruster dynamics and the force set-point for each thruster. The
% duration that the vessel stays in one position should be long enough to achieve stability
% before it can move to another set-point.
% Perform the 4 corner DP test from Part 1:

if SimulationToRun == 2
    useWindM = false;
    useWaveM = false;
    useObsv = false;
    set_param('part2_main/Wave', 'waveforces', 'off');
end

%% Simulation 3
% Perform the 4 corner DP test using the environmental conditions presented in Simulation
% 1 and the thrust allocation from Simulation 2 (without thruster failure). There shall be
% no observer used.
% Plot the position and heading until you reach steady state, both as individual and in a
% xy-plot. In addition, put the desired trajectory in the individual plots. If the reference
% model contains velocity trajectories, then plot these with the actual velocities.
if SimulationToRun == 3
    useWindM = true;
    set_param('part2_main/Wave', 'waveforces', 'on');    
    useObsv = false;
end

%% Simulation 4
% Use the same environmental conditions as in Simulation 1. The desired DP force shall be
% fixed at [1 1 1] Â· 104
% . Simulate for enough time such that you can choose observer later.
% Do a new simulation, now without wave forces/moment. We just want you to compare
% your observer output with the real measurements (before and after wave forces/moment
% are added to the signal).
if SimulationToRun == 4
    useObsv = true;
    
    disp('With environmental forces');
    disp('Using EKF');
    useEKF = true;
    sim('part2_main.slx', simTimes(SimulationToRun, :));
    run(['plotting_' num2str(SimulationToRun )]);
    
    disp('Using NPO');
    useEKF = false;    
    
    sim('part2_main.slx', simTimes(SimulationToRun, :));
    run(['plotting_' num2str(SimulationToRun )]);
    
    set_param('part2_main/Wave', 'waveforces', 'off');
    useCurrentM = false;
    useWindM = false;
    
    sim4NoEnv = '_NoEnv';
    
    disp('Without environmental forces');
    disp('Using EKF');
    useEKF = true;
    sim('part2_main.slx', simTimes(SimulationToRun, :));
    run(['plotting_' num2str(SimulationToRun )]);
    
    disp('Using NPO');
    useEKF = false;   
end

%% Simulation 5
% With the selected observer, run a 4 corner DP test, including the full DP system and the
% environmental conditions.
% Use the same environmental conditions as in Simulation 1.
% Plot the position and heading until you reach steady state, both as individual and in a
% xy-plot. In addition, put the desired trajectory in the individual plots. If the reference
% model contains velocity trajectories, then plot these with the actual velocities.
if SimulationToRun == 5
    %
end


%% Simulation 6
% Make a thrust utilization plot for the vessel for a fixed weather condition, U3 = 15 [m/s],
% Uc = 0.2 [m/s], Hs = 5 [m] and Tp = 10 [s].
% To make the capability plot, find the average thrust percentage used to keep the vessel
% stable at [xSP ySP] = [0 0], given that the current, wind and waves are coming from North.
% Change the environmental direction with increment of 10 degrees. The wind, wave and current 
% directions are co-linear (having the same direction) and vessel heading ÏˆSP = 0
% degree.
if SimulationToRun == 6
    tic;
    disp('Calculating Capability Plot');
    % Configure waves
    set_param('part2_main/Wave', 'waveforces', 'on');
    set_param('part2_main/Waves', 'hs', '5');
    set_param('part2_main/Waves', 'omega_peak', '2*pi/10'); 

    % Configure wind
    set_param('wind_model/Wind1', 'u_mean_10', '15');
    
    for angle = 0:10:360
        fprintf('Environmental forces from %.0f degree\n', angle);
        sim6CurrentAngle = angle;
        set_param('wind_model/Wind1', 'dir_mean', num2str(deg2rad(angle)));
        set_param('part2_main/Waves', 'psi_mean', num2str(deg2rad(angle))); 
        pause(1);
        sim('part2_main.slx', simTimes(SimulationToRun, :));
        plot_init;
        thrAvgData(angle/10+1, :) = [angle, sum(mean(abs(u_thr.Data(t>100, :))))];
    end
    
    thrAvgData(:, 2) = thrAvgData(:, 2)./sum([thrusters.thrust])*100;
    toc;
end
%% Simulation 7
% Verify if your observers are robust by changing the wave height to 8 [m] and period to 13
% [s], use the same current and wind values from Simulation 1. Then plot the vessel position
% over 1000 seconds, for station keeping at the origin (Î·SP = [0 0 0]).

if SimulationToRun == 7
    % Configure waves
    useEKF = true;
    set_param('part2_main/Waves', 'hs', '8'); % 2.5 m
    set_param('part2_main/Waves', 'omega_peak', '2*pi/13'); %Tp = 9s
end


%% Run Simulation and plotting
if SimulationToRun ~= 6
    fprintf('Total Simulation time: %.0f sec\n', simTimes(SimulationToRun, 2));
    sim('part2_main.slx', simTimes(SimulationToRun, :));
end
run(['plotting_' num2str(SimulationToRun )]);
