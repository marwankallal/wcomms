function [st1, st2] = tx_MISO(d1,d2)
    % st1 and st2: the transmitted signal matrices 
    %    (2 × Nb, one column per block) at 
    %    time instant 1 and 2, respectively
    % d1 and d2: row vectors (1 × Nb) with the 
    %    transmitted complex baseband data symbols

    % Check lengths are the same
    if (length(d1) ~= length(d2))
        error("Symbol vectors different sizes");
    end
    
    Nb = length(d1);

    st1 = zeros(2,Nb);
    st2 = zeros(2,Nb);

    % Encode every pair of symbols
    for sym_idx = 1:Nb
        st1(:,sym_idx) = (1/sqrt(2)) * [d1(sym_idx); d2(sym_idx)];
        st2(:,sym_idx) = (1/sqrt(2)) * [-conj(d2(sym_idx)), conj(d1(sym_idx))];
    end