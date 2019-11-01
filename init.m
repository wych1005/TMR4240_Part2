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

simFile = "final_v2_R2019a.slx";

savePlots = 0; % 1: Save plots as ESP in the /plots folder
SimulationToRun = 5; % Manual control in simulink

useEKF = true;
% useRefM = 1;

