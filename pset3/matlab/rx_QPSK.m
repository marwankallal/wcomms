function [I,Q,datar]=rx_QPSK(fs,Rs,Ns,fc,r)

%fs: vector points per microseconds (sampling frequency)
%Rs: symbol rate in Mbauds (Msymbols/s) 
%Ns: number of symbols to simulate
%fc: carrier frequency in MHz
%r:  input signal to the receiver

%I:      In-phase componenet after demodulation
%Q:      Quadrature componenet after demodulation
%datar:  recovered data 

N=fs/Rs; %number of points per symbol
Ts=1/Rs; %symbol duration

% Pulse generation
pulse=[ones(1,N)]; %square pulse

% Impulse response of matched filter to both basis functions for one symbol duration 
tsym=0:1/fs:Ts-1/fs;
ksym=0:1:N-1;

k= 2/Ts; %scale factor given cosine and sine do not have unit energy. k=1/Energy cosine (sine)
mfI=k*pulse(N-ksym).*cos(2*pi*(Ts-tsym)*fc);
mfQ=-k*pulse(N-ksym).*sin(2*pi*(Ts-tsym)*fc);

% Separate symbols from the input signal
sRef=reshape(r,N,Ns); %one symbol per column

% Demodulation (calculate the I and Q components with matched filters) and decide (ML detector) 

for i=1:Ns
    % Demodulation
    [Im, tIm ] = linfilt(mfI, tsym, sRef(:,i), tsym ); 
    [Qm, tQm ] = linfilt(mfQ, tsym, sRef(:,i), tsym );

    % Check only the last sample at the output of the matched filters
    I(i)=Im(N+1)*(1/fs); %sampling interval (1/fs) factor to account for the discrete nature of Matlab convolution (sum -> integral)
    Q(i)=Qm(N+1)*(1/fs); %sampling interval (1/fs) factor to account for the discrete nature of Matlab convolution (sum -> integral)

    % Decision
    if (I(i)>= 0)
        datar(2*i-1)=1;
    else 
        datar(2*i-1)=0;
    end
    
     if (Q(i)>= 0)
        datar(2*i)=1;
    else 
        datar(2*i)=0;
    end
end 
