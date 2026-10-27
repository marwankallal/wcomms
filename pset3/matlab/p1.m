%% Define constants
num_bits = 8000; % Number of input bits
f_c = 1000; % Carrier frequency (MHz)
f_s = 50e3; % Sample frequency (MHz)
T_s = 2e-9; % Symbol period (s)
Rs = round((1/T_s) / 1e6); % Megasymbols per second. Rounded to avoid integer issues
M = 2; % bits per symbol (QPSK)
Ns = round(num_bits / M); % Number of symbols

%% Run through TX
[data,N,s,ts] = tx_QPSK(f_s, Rs, Ns, f_c);

%% Build channels
h1 = zeros(1,length(ts));
h2 = zeros(1,length(ts));
h3 = zeros(1,length(ts));

% Build h1 = 0.8δ(τ)
h1(1) = 0.8; % Tap at 0

% Build h2 = 0.4δ(τ) + 0.25δ(τ − 2.2e−10) + 0.175δ(τ − 4.8e−10)
h2(1) = 0.4; % Tap at 0
h2(round((2.2e-10 * 1e6) * f_s + 1)) = 0.25; % Round to get back to ints
h2(round((4.8e-10 * 1e6) * f_s + 1)) = 0.175;

% Build h3 = 0.4δ(τ) + 0.35δ(τ − 6e−10) + 0.2δ(τ − 7.6e−10)
h3(1) = 0.4; % Tap at 0
h3(round((6e-10 * 1e6) * f_s + 1)) = 0.35; % Round to get back to ints
h3(round((7.6e-10 * 1e6) * f_s + 1)) = 0.2;

th = ts;

%% Run through channels
[r1,tr1] = channel_and_noise(h1, th, s, ts);
[r2,tr2] = channel_and_noise(h2, th, s, ts);
[r3,tr3] = channel_and_noise(h3, th, s, ts);


%% Run through RX 
[I1, Q1, datar1] = rx_QPSK(f_s, Rs, Ns, f_c, r1);
[I2, Q2, datar2] = rx_QPSK(f_s, Rs, Ns, f_c, r2);
[I3, Q3, datar3] = rx_QPSK(f_s, Rs, Ns, f_c, r3);