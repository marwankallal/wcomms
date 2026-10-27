function [data,N,s,ts]=tx_QPSK(fs,Rs,Ns,fc)

%fs: vector points per microseconds (sampling frequency)
%Rs: symbol rate in Mbauds (Msymbols/s) 
%Ns: number of symbols to simulate
%fc: carrier frequency in MHz

%data: bits transmitted
%N: points per symbol
%s: signal transmitted
%ts: time vector of the signal transmitted

close all;
N=fs/Rs; %number of points per symbol 
Ts=1/Rs; %symbol duration

% Random generation of bits
data= randi([0 1], 1, 2*Ns);

% Pulse generation
pulse=[ones(1,N)]; %square pulse

I=zeros(1,N); % first sample will store the in-phase component
Q=zeros(1,N); % first sample will store the quadrature component

tsym=0:1/fs:Ts-1/fs; % time vector of symbol
cosine=cos(2*pi*tsym*fc); 
sine=-sin(2*pi*tsym*fc);

sm=zeros(Ns,N); %Matrix that will store one symbol per row


% I and Q components and symbol calculation
for i=1:Ns
    % I component
     if (data(2*i-1)==0)
         I(1)=-1;
     else
         I(1)=1;
     end
     
     %Q component
     if(data(2*i)==0)
         Q(1)=-1;
     else
         Q(1)=1;
     end

     % Pulse shaping 
     % Filter with the pulse as impulse response
     % Input signal has one sample with the value of the I/Q component
     % Output is a signal with the pulse shape*I/Q component
    [Ip, tIm ] = linfilt(pulse, tsym, I, tsym); 
    [Qp, QIm ] = linfilt(pulse, tsym, Q, tsym); 

    %Modulation and symbol "i" calculation
    sm(i,:)=Ip(1:length(tsym)).*cosine+Qp(1:length(tsym)).*sine;
end

%Reshape matrix sm to represent the signal transmitted in a (1xNs*N) array
s= reshape(sm',1,Ns*N);
ts=0:1/fs:Ns*Ts-1/fs; % time vector of the signal transmitted