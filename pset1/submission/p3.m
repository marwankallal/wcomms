n = linspace(2,5);

R = zeros(length(n),1);

for n_idx = 1:length(n)
    R(n_idx) = 100 * 10^(71.47/(10 * n(n_idx)));
end

figure
plot(n,R/1000)
xlabel("Path Loss Exponent")
ylabel("Distance (km)")
yscale log;
