% Sigma square_n (AWGN variance)
sigma2_n = 0.02; % 0.02

% QPSK (4 ary)
M = 4;

% Number of blocks
Nb = (10^4);

% Repeat given symbols Nb times
d1_tx = repmat(1 + 1j, 1, Nb);
d2_tx = repmat(-1 + 1j, 1, Nb);

% Build channels
chan_A = [0.8*exp(1j*pi/4), 0.05*exp(1j*pi/8)];
chan_B = [0.9*exp(1j*pi/4), 0.9*exp(1j*pi/8)];
chan_C = [0.05*exp(1j*pi/4), 0.2*exp(1j*pi/8)];
chan_D = [0.9*exp(1j*pi/4), 0.9*exp(1j*pi/4)];

% Transmit
[st1, st2] = tx_MISO(d1_tx, d2_tx);

% Channels
[rt1_A, rt2_A] = channel_MISO(st1, st2, chan_A(1), chan_A(2), sigma2_n);
[rt1_B, rt2_B] = channel_MISO(st1, st2, chan_B(1), chan_B(2), sigma2_n);
[rt1_C, rt2_C] = channel_MISO(st1, st2, chan_C(1), chan_C(2), sigma2_n);
[rt1_D, rt2_D] = channel_MISO(st1, st2, chan_D(1), chan_D(2), sigma2_n);

% Receives
[d1r_A, d2r_A, alpha_A] = rx_MISO(rt1_A, rt2_A, chan_A(1), chan_A(2));
[d1r_B, d2r_B, alpha_B] = rx_MISO(rt1_B, rt2_B, chan_B(1), chan_B(2));
[d1r_C, d2r_C, alpha_C] = rx_MISO(rt1_C, rt2_C, chan_C(1), chan_C(2));
[d1r_D, d2r_D, alpha_D] = rx_MISO(rt1_D, rt2_D, chan_D(1), chan_D(2));

% Print alphas
disp("alpha A: " + alpha_A)
disp("alpha B: " + alpha_B)
disp("alpha C: " + alpha_C)
disp("alpha D: " + alpha_D)

% Print symbols for noiseless 
if(sigma2_n == 0 && Nb == 1)
    disp("Symbols A: " + d1r_A + ", " + d2r_A);
    disp("Symbols B: " + d1r_B + ", " + d2r_B);
    disp("Symbols C: " + d1r_C + ", " + d2r_C);
    disp("Symbols D: " + d1r_D + ", " + d2r_D);
end

% Compute SNR
P_s = 2; % Symbol power from assignment
P_s_computed = mean(abs([d1_tx, d2_tx]).^2)
rho = P_s / sigma2_n;

d_A = [d1_tx, d2_tx];
dhat_A = [d1r_A, d2r_A];
sqerrvec_A = abs(dhat_A - (alpha_A * d_A)) .^ 2;
gamma_hat_A = 10 * log10(alpha_A^2 * P_s / mean(sqerrvec_A));

sqerrvec_B = abs(d1r_B - (alpha_B * d1_tx)) .^ 2;
gamma_hat_B = 10 * log10(alpha_B^2 * P_s / mean(sqerrvec_B));

sqerrvec_C = abs(d1r_C - (alpha_C * d1_tx)) .^ 2;
gamma_hat_C = 10 * log10(alpha_C^2 * P_s / mean(sqerrvec_C));

sqerrvec_D = abs(d1r_D - (alpha_D * d1_tx)) .^ 2;
gamma_hat_D = 10 * log10(alpha_D^2 * P_s / mean(sqerrvec_D));

% Theoretical SNR
gamma_A = 10 * log10(alpha_A * rho);
gamma_B = 10 * log10(alpha_B * rho);
gamma_C = 10 * log10(alpha_C * rho);
gamma_D = 10 * log10(alpha_D * rho);

disp("A SNR Theory: " + gamma_A + " SNR Computed: " + gamma_hat_A);
disp("B SNR Theory: " + gamma_B + " SNR Computed: " + gamma_hat_B);
disp("C SNR Theory: " + gamma_C + " SNR Computed: " + gamma_hat_C);
disp("D SNR Theory: " + gamma_D + " SNR Computed: " + gamma_hat_D);

figure(1);
subplot(2,2,1);
scatter(real(d1r_A), imag(d1r_A));
hold on;
scatter(real(d2r_A), imag(d2r_A));
scatter(real(alpha_A * d1_tx), imag(alpha_A * d1_tx));
scatter(real(alpha_A * d2_tx), imag(alpha_A * d2_tx));
hold off;
ax = gca;
set(gca, 'Layer', 'top')
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
axis equal;
title("Channel A");
legend("d1r", "d2r", "alpha d1", "alpha d2");

subplot(2,2,2);
scatter(real(d1r_B), imag(d1r_B));
hold on;
scatter(real(d2r_B), imag(d2r_B));
scatter(real(alpha_B * d1_tx), imag(alpha_B * d1_tx));
scatter(real(alpha_B * d2_tx), imag(alpha_B * d2_tx));
hold off;
ax = gca;
set(gca, 'Layer', 'top')
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
axis equal;
title("Channel B");
legend("d1r", "d2r", "alpha d1", "alpha d2");

subplot(2,2,3);
scatter(real(d1r_C), imag(d1r_C));
hold on;
scatter(real(d2r_C), imag(d2r_C));
scatter(real(alpha_C * d1_tx), imag(alpha_C * d1_tx));
scatter(real(alpha_C * d2_tx), imag(alpha_C * d2_tx));
hold off;
ax = gca;
set(gca, 'Layer', 'top')
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
axis equal;
title("Channel C");
legend("d1r", "d2r", "alpha d1", "alpha d2");

subplot(2,2,4);
scatter(real(d1r_D), imag(d1r_D));
hold on;
scatter(real(d2r_D), imag(d2r_D));
scatter(real(alpha_D * d1_tx), imag(alpha_D * d1_tx));
scatter(real(alpha_D * d2_tx), imag(alpha_D * d2_tx));
hold off;
ax = gca;
set(gca, 'Layer', 'top')
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
axis equal;
title("Channel D");
legend("d1r", "d2r", "alpha d1", "alpha d2");
