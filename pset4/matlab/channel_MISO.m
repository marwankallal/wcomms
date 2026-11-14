function [rt1,rt2]=channel_MISO(st1,st2,h1,h2,sigma2)

% st1: 2xNb matrix, signals transmitted by antennas 1 and 2 at instant 1
%      (each column is one Alamouti block; Nb blocks in total)
% st2: 2xNb matrix, signals transmitted by antennas 1 and 2 at instant 2
% h1 and h2: complex channel gains for tx antenna 1 and 2 respectively
% sigma2: noise variance per sample, CN(0,sigma2), linear units.
%         Optional: if omitted or 0, the channel is noiseless.
% rt1: 1xNb vector, signal received at time instant 1
% rt2: 1xNb vector, signal received at time instant 2

if nargin < 5
    sigma2 = 0;
end

h=[h1 h2];
Nb=size(st1,2);

% Independent complex Gaussian noise
n1=sqrt(sigma2/2)*(randn(1,Nb)+1j*randn(1,Nb));
n2=sqrt(sigma2/2)*(randn(1,Nb)+1j*randn(1,Nb));

rt1=h*st1+n1;
rt2=h*st2+n2;
