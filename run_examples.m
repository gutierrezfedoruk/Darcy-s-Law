%% =========================================================================
%  PRODUCTIVITY INDEX - EXAMPLE RUNNER
%  Run this script to test the PI calculator with sample data
%
%  Author: Enrique Philippe Gutiérrez Fedoruk
%  LinkedIn: https://www.linkedin.com/in/enrique-philippe-guti%C3%A9rrez-fedoruk-493060123/
%  Date: 2026
%  License: MIT License
% =========================================================================

clc; clear; close all;

fprintf('==============================================\n');
fprintf('  PRODUCTIVITY INDEX CALCULATOR - EXAMPLES\n');
fprintf('==============================================\n\n');

%% Example 1: Typical oil well
fprintf('--- EXAMPLE 1: Typical Oil Well ---\n');
params1.h    = 50;       % ft - reservoir thickness
params1.k    = 100;      % mD - permeability
params1.B    = 1.2;      % rb/stb - formation volume factor
params1.mu   = 0.8;      % cp - oil viscosity
params1.R    = 1000;     % ft - drainage radius
params1.rw   = 0.328;    % ft - wellbore radius (7-7/8" hole)
params1.S    = 0;        % dimensionless - no skin damage
params1.P_R  = 4000;     % psi - reservoir pressure
params1.P_BH = 2000;     % psi - flowing BHP

res1 = productivity_index(params1);

%% Example 2: Damaged well (positive skin)
fprintf('--- EXAMPLE 2: Damaged Well (S=10) ---\n');
params2 = params1;
params2.S = 10;          % significant formation damage

res2 = productivity_index(params2);

%% Example 3: Stimulated well (negative skin)
fprintf('--- EXAMPLE 3: Stimulated Well (S=-3) ---\n');
params3 = params1;
params3.S = -3;          % hydraulic fracture or acidizing

res3 = productivity_index(params3);

%% Example 4: Low permeability reservoir
fprintf('--- EXAMPLE 4: Low Permeability (k=5 mD) ---\n');
params4 = params1;
params4.k = 5;           % tight reservoir

res4 = productivity_index(params4);

%% Comparison table
fprintf('\n============================================\n');
fprintf('          COMPARISON TABLE\n');
fprintf('============================================\n');
fprintf('%-20s %10s %10s %10s\n', 'Case', 'PI', 'Q', 'Q_BH');
fprintf('%-20s %10s %10s %10s\n', '', 'stb/d/psi', 'stb/day', 'rb/day');
fprintf('--------------------------------------------\n');
fprintf('%-20s %10.4f %10.1f %10.1f\n', 'No damage (S=0)',  res1.PI, res1.Q, res1.Q_BH);
fprintf('%-20s %10.4f %10.1f %10.1f\n', 'Damaged (S=10)',   res2.PI, res2.Q, res2.Q_BH);
fprintf('%-20s %10.4f %10.1f %10.1f\n', 'Stimulated (S=-3)', res3.PI, res3.Q, res3.Q_BH);
fprintf('%-20s %10.4f %10.1f %10.1f\n', 'Low perm (k=5)',   res4.PI, res4.Q, res4.Q_BH);
fprintf('============================================\n');

%% Run sensitivity analysis
fprintf('\nRunning sensitivity analysis...\n');
sensitivity_analysis();
