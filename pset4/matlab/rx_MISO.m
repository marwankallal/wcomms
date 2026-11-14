function [d1r,d2r,alpha]=rx_MISO(rt1,rt2,h1,h2)
    % d1r and d2r: the recovered complex baseband data 
    %   symbols (1 × Nb row vectors)
    % alpha: the scale factor obtained from the matrix 
    %   implementation of the Alamouti code in the receiver
    % rt1 and rt2: the signals received at time instants 1 and 2
    % h1 and h2: the complex channel gains of the channel 
    %   for transmit antenna 1 and 2, respectively

    H = (1/sqrt(2)) * [h1, h2; conj(h2), -conj(h1)];

    dr = H' * [rt1; conj(rt2)];

    alpha = (abs(h1)^2 + abs(h2)^2) / 2;

    d1r = dr(1, : ) ;
    d2r = dr(2, : ) ;
