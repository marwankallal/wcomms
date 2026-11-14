%% Define constants
num_bits = 100; % Number of input bits
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
h3(round((7.6e-10 * 1e6) * f_s + 1)) = 0.2; % Round to get back to ints

th = ts;

%% Run through channels
[r1,tr1] = channel_and_noise(h1, th, s, ts);
[r2,tr2] = channel_and_noise(h2, th, s, ts);
[r3,tr3] = channel_and_noise(h3, th, s, ts);


%% Run through RX 
[I1, Q1, datar1] = rx_QPSK(f_s, Rs, Ns, f_c, r1);
[I2, Q2, datar2] = rx_QPSK(f_s, Rs, Ns, f_c, r2);
[I3, Q3, datar3] = rx_QPSK(f_s, Rs, Ns, f_c, r3);

%%  Plotting
% Plot transmitted signal
figure(1);
plot(ts,s);
title('Transmitted Signal')
xlabel('Time (s)')
ylabel('Amplitude')

figure(2);
% Plot the 3 received signals
subplot(3,1,1)
plot(tr1, r1)
title('Signal Received Through h1')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(3,1,2)
plot(tr2, r2)
title('Signal Received Through h2')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(3,1,3)
plot(tr3, r3)
title('Signal Received Through h3')
xlabel('Time (s)')
ylabel('Amplitude')

% Plot constellations
figure(3)
scatter(I1,Q1)
xlabel("I")
ylabel("Q")
title("Constellation through h1")

figure(4)
scatter(I2,Q2)
xlabel("I")
ylabel("Q")
title("Constellation through h2")

figure(5)
scatter(I3,Q3)
xlabel("I")
ylabel("Q")
title("Constellation through h3")

%% Compute bit error rates for the three channels
h1_BER = sum(datar1 ~= data) / length(data)
h2_BER = sum(datar2 ~= data) / length(data)
h3_BER = sum(datar3 ~= data) / length(data)