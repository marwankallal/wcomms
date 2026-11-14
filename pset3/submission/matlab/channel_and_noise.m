function [r,tr]=channel_and_noise(h,th,s,ts)

%h:  impulse response of the channel
%th: time (tau) vector for h (time vector used to create h --> You could consider th=ts)
%s:  transmitted signal at the input of the channel
%ts: time vector for s

%r:   signal after channel transmission and the addition of AWGN noise
%tr:  time vector of the signal r



[xconv, txconv ] = linfilt(h, th, s, ts );
tr=ts;
x=xconv(1:length(tr)); %output signal is a longer signal than the input duration. Only interested in the output during ts.

% AWGN noise generation and addition
r=awgn(x,10,'measured');

