%% b.i
f_c = [900, 2600, 28000]; %MHz
d_0 = 100; %m
d_max = 10000; %m

PL_0_db = zeros(length(f_c),1);

for i_f_c = 1:length(f_c)
    PL_0_db(i_f_c) = 32.45 + (20 * log10(f_c(i_f_c))) + (20 * log10(d_0 / 1000));
end


d = linspace(d_0,d_max);

n = 3.5;

PLs = zeros(length(d), length(f_c));

for i_f_c = 1:length(f_c)
    for i_d = 1:length(d)
        PLs(i_d,i_f_c) = PL_0_db(i_f_c) + 10 * n * log10(d(i_d) / d_0);
    end
end

figure
plot(d, PLs);
legend("f_c = 900MHz","f_c = 2.5GHz", "f_c = 28GHz")
xlabel("Distance (m)")
ylabel("Path Loss (dB)")
xscale log;
grid on;
