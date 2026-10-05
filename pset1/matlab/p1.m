%% a.i
f_c = 900; %MHz
d_0 = 100; %m
d_max = 10000; %m

PL_0_db = 32.45 + (20 * log10(f_c)) + (20 * log10(d_0 / 1000));

d = linspace(d_0,d_max);

n = [2., 2.7, 3.5];

PLs = zeros(length(d), length(n));

for i_n = 1:length(n)
    for i_d = 1:length(d)
        PLs(i_d,i_n) = PL_0_db + 10 * n(i_n) * log10(d(i_d) / d_0);
    end
end


figure
plot(d, PLs);
legend("n=2","n=2.7", "n=3.5")
xlabel("Distance (m)")
ylabel("Path Loss (dB)")
xscale log;
grid on;

