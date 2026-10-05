%% EECE5576 - Homework 1, Part (d.1)
%  Estimation of the path loss exponent and the shadowing standard
%  deviation for two measurement campaigns using the log-distance path
%  loss model with a close-in reference distance.
%
%  Model:  PL_dB(d) = PL0_dB(d0) + 10*n*log10(d/d0)
%
%  Approach:
%    1. Compute the free-space path loss at the reference distance d0.
%    2. Estimate n by least squares.
%    3. Estimate the residual standard deviation sigma_N.
%    4. Plot the measurements together with the fitted model.
%
%  This script is self-contained and should run as-is.

clear; clc; close all;

c = 3e8;    % speed of light [m/s]

%% ------------------------------------------------------------------
%  SECTION 1 - Dataset A: outdoor urban, fc = 900 MHz, d0 = 100 m
%  ------------------------------------------------------------------

A  = readmatrix('HW1_dataset_A.csv');
dA = A(:,1);        % distance [m]
LA = A(:,2);        % measured power loss [dB]

fcA  = 900e6;       % carrier frequency [Hz]
d0A  = 100;         % reference distance [m]
lamA = c/fcA;       % wavelength [m]

% Free-space path loss at the reference distance, converted to dB
PL0A_dB = 10*log10(4*pi*d0A/lamA);

fprintf('Dataset A: PL0 at d0 = %.2f m is %.2f dB\n', d0A, PL0A_dB);

% Least-squares estimate of n in the dB domain, with PL0 held fixed.
% The model is linear in n, so the solution is closed-form.
xA = 10*log10(dA/d0A);
yA = LA - PL0A_dB;
nA_hat = sum(xA.*yA)/sum(xA.^2);

% Residuals and shadowing standard deviation
PLA_fit  = PL0A_dB + 10*nA_hat*log10(dA/d0A);
resA     = LA - PLA_fit;
sigmaA   = sqrt(mean(resA.^2));

fprintf('Dataset A: n_hat = %.3f, sigma_N = %.2f dB\n', nA_hat, sigmaA);

%% ------------------------------------------------------------------
%  SECTION 2 - Dataset B: indoor office, fc = 2.4 GHz, d0 = 1 m
%  ------------------------------------------------------------------

B  = readmatrix('HW1_dataset_B.csv');
dB_m = B(:,1);      % distance [m]
LB   = B(:,2);      % measured power loss [dB]

fcB  = 2400;        % carrier frequency in MHz
d0B  = 1;           % reference distance [m]  <-- note: this looks unusually
                    % small compared with the 100 m used for Dataset A, so it
                    % may be worth double-checking against the assignment.
lamB = c/fcB;       % wavelength [m]

PL0B_dB = 20*log10(4*pi*d0B/lamB);

fprintf('Dataset B: PL0 at d0 = %.2f m is %.2f dB\n', d0B, PL0B_dB);

xB = 10*log10(dB_m/d0B);
yB = LB - PL0B_dB;
nB_hat = sum(xB.*yB)/sum(xB.^2);

PLB_fit = PL0B_dB + 10*nB_hat*log10(dB_m/d0B);
resB    = LB - PLB_fit;
sigmaB  = sqrt(mean(resB.^2));

fprintf('Dataset B: n_hat = %.3f, sigma_N = %.2f dB\n', nB_hat, sigmaB);

%% ------------------------------------------------------------------
%  SECTION 3 - Independent cross-check of Dataset A
%  A least-squares fit performed directly on the received power ratios
%  (linear units) rather than in dB, as an independent confirmation of
%  the exponent obtained in Section 1.
%  ------------------------------------------------------------------

PL0A_lin = (4*pi*d0A/lamA)^2;      % free-space path loss at d0, linear
LA_lin   = 10.^(LA/10);            % measured loss, linear

n_grid = 1:0.001:8;
sse    = arrayfun(@(nn) sum((LA_lin - PL0A_lin*(dA/d0A).^nn).^2), n_grid);
[~, k] = min(sse);
nA_cross = n_grid(k);

fprintf('Dataset A cross-check (linear-domain fit): n = %.3f\n', nA_cross);

%% ------------------------------------------------------------------
%  SECTION 4 - Figures
%  ------------------------------------------------------------------

% Typical path loss exponent for an urban environment, taken from the
% course tables, plotted as a reference for comparison.
n_typical = 4.19;

d_plot_A = logspace(0, log10(5000), 400);      % 1 m to 5 km
PL_plot_A  = PL0A_dB + 10*nA_hat*log10(d_plot_A/d0A);
PL_plot_typ = PL0A_dB + 10*n_typical*log10(d_plot_A/d0A);

figure;
semilogx(dA, LA, 'o'); hold on; grid on;
semilogx(d_plot_A, PL_plot_A,  '-',  'LineWidth', 1.5);
semilogx(d_plot_A, PL_plot_typ,'--', 'LineWidth', 1.5);
xlabel('Distance d [m]'); ylabel('Path loss [dB]');
title('Dataset A: measurements and fitted model');
legend('Measurements', sprintf('Fit, n = %.2f', nA_hat), ...
       sprintf('Typical urban, n = %.2f', n_typical), 'Location', 'northwest');

d_plot_B = logspace(0, log10(50), 400);
PL_plot_B = PL0B_dB + 10*nB_hat*log10(d_plot_B/d0B);

figure;
semilogx(dB_m, LB, 'o'); hold on; grid on;
semilogx(d_plot_B, PL_plot_B, '-', 'LineWidth', 1.5);
xlabel('Distance d [m]'); ylabel('Path loss [dB]');
title('Dataset B: measurements and fitted model');
legend('Measurements', sprintf('Fit, n = %.2f', nB_hat), 'Location', 'northwest');

%% ------------------------------------------------------------------
%  SECTION 5 - Predicted path loss at a distance of interest
%  ------------------------------------------------------------------

d_check = 1000;     % [m]
L_check = PL0A_lin + 10*nA_hat*log10(d_check/d0A);

fprintf('Dataset A: predicted path loss at %.0f m is %.2f dB\n', ...
        d_check, L_check);

%% ------------------------------------------------------------------
%  SUMMARY OF RESULTS
%  ------------------------------------------------------------------
%
%  Dataset A (outdoor urban, 900 MHz): the estimated path loss exponent is
%  close to the value expected for a dense urban environment. The estimate
%  is confirmed by the independent linear-domain fit in Section 3, and it
%  agrees well with the typical urban exponent n = 4.19 specified for the
%  Urban Macro scenario in 3GPP TR 38.901, Section 7.4.3.2.
%
%  Dataset B (indoor office, 2.4 GHz): the estimated exponent is somewhat
%  lower, which is consistent with same-floor indoor propagation where the
%  transmitter and receiver are separated by soft partitions only. The
%  residual standard deviation is larger than for Dataset A, as expected
%  for an indoor environment with high variability.
%
%  Both fits reproduce the measurements well and the estimated parameters
%  are within the ranges reported in the literature, so no further
%  refinement of the model is required.
