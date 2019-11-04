%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% init()                                                                  %
%                                                                         %
% Set initial parameters for part1.slx and part2.slx                      %
%                                                                         %
% Created:      2018.07.12	Jon Bj�rn�                                %
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

savePlots = true; % true: Save plots as ESP in the /plots folder
SimulationToRun = 3; % Manual control in simulink

useEKF = true;
useRefM = true;
useWindM = true;
useWaveM = true;
useObsv = true;
useThr = true;

simTimes = [0 300;
            0 1600;
            0 2000;
            0 200;
            0 1600;
            0 1000;
            0 1000];
        
% Configure waves
set_param('part2_main/Wave', 'waveforces', 'on');
set_param('part2_main/Waves', 'hs', '2.5'); % 2.5 m
set_param('part2_main/Waves', 'omega_peak', '2*pi/9'); %Tp = 9s
set_param('part2_main/Waves', 'psi_mean', 'pi*5/4'); % From NE

% Configure wind
set_param('wind_model/Wind1', 'u_mean_10', '10'); %Avg speed 10 m/s
set_param('wind_model/Wind1', 'dir_mean', 'pi'); % From north

%% Simulation 1
if SimulationToRun == 1  
    useThr = false;
%     run(['plotting_' num2str(SimulationToRun )]);
end

%%Simulate for 300 seconds with current from East, with average speed of 0.2 [m/s] and wind
% from the north, with average speed of 10 [m/s]. Waves from Northeast with a significant
% wave height Hs of 2.5 [m] and a peak wave period Tp of 9 [s]. Note that the wind and
% current direction slow variation shall not exceed 5 degrees. Use the same parameters as in
% Assignment 5


%% Simulation 2
if SimulationToRun == 2
    useWindM = false;
    useWaveM = false;
    useObsv = false;
    set_param('part2_main/Wave', 'waveforces', 'off');
end

% Disable the environmental forces and plot the desired force calculated by your controller,
% the force applied by the thruster dynamics and the force set-point for each thruster. The
% duration that the vessel stays in one position should be long enough to achieve stability
% before it can move to another set-point.
% Perform the 4 corner DP test from Part 1:
%% Simulation 3
if SimulationToRun == 3
    useWindM = true;
    set_param('part2_main/Wave', 'waveforces', 'on');    
    useObsv = false;
end
% Perform the 4 corner DP test using the environmental conditions presented in Simulation
% 1 and the thrust allocation from Simulation 2 (without thruster failure). There shall be
% no observer used.
% Plot the position and heading until you reach steady state, both as individual and in a
% xy-plot. In addition, put the desired trajectory in the individual plots. If the reference
% model contains velocity trajectories, then plot these with the actual velocities.
%% Simulation 4
if SimulationToRun == 4
    useObsv = true;
    
    disp('Using EKF');
    useEKF = true;
    sim('part2_main.slx', simTimes(SimulationToRun, :));
    run(['plotting_' num2str(SimulationToRun )]);
    
    disp('Using NPO');
    useEKF = false;    
end
% Use the same environmental conditions as in Simulation 1. The desired DP force shall be
% fixed at [1 1 1] · 104
% . Simulate for enough time such that you can choose observer later.
% Do a new simulation, now without wave forces/moment. We just want you to compare
% your observer output with the real measurements (before and after wave forces/moment
% are added to the signal).
%% Simulation 5
if SimulationToRun == 5

end
% With the selected observer, run a 4 corner DP test, including the full DP system and the
% environmental conditions.
% Use the same environmental conditions as in Simulation 1.
% Plot the position and heading until you reach steady state, both as individual and in a
% xy-plot. In addition, put the desired trajectory in the individual plots. If the reference
% model contains velocity trajectories, then plot these with the actual velocities.

%% Simulation 6
if SimulationToRun == 6
    %
end

% Make a thrust utilization plot for the vessel for a fixed weather condition, U3 = 15 [m/s],
% Uc = 0.2 [m/s], Hs = 5 [m] and Tp = 10 [s].
% To make the capability plot, find the average thrust percentage used to keep the vessel
% stable at [xSP ySP] = [0 0], given that the current, wind and waves are coming from North.
% Change the environmental direction with increment of 10 degrees. The wind, wave and current 
% directions are co-linear (having the same direction) and vessel heading ψSP = 0
% degree.
%% Simulation 7
if SimulationToRun == 7
    % Configure waves
    useEKF = true;
    set_param('part2_main/Waves', 'hs', '8'); % 2.5 m
    set_param('part2_main/Waves', 'omega_peak', '2*pi/13'); %Tp = 9s
end
% Verify if your observers are robust by changing the wave height to 8 [m] and period to 13
% [s], use the same current and wind values from Simulation 1. Then plot the vessel position
% over 1000 seconds, for station keeping at the origin (ηSP = [0 0 0]).




fprintf('Total Simulation time: %.0f sec\n', simTimes(SimulationToRun, 2));
sim('part2_main.slx', simTimes(SimulationToRun, :));
run(['plotting_' num2str(SimulationToRun )]);