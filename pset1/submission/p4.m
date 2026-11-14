datasetA = readtable("HW1_dataset_A.csv");
datasetB = readtable("HW1_dataset_B.csv");

% Compute PL_0s
dsetA_PL0 = 20 * log10(100) + 20 * log10(900e6) - 147.56;
dsetB_PL0 = 20 * log10(1) + 20 * log10(2.4e9) - 147.56;

% Reference distances
dsetA_d0 = 100;
dsetB_d0 = 1;

% Compute errors compared to path loss model
dsetA_errors = [length(datasetA.d_m)];
dsetB_errors = [length(datasetB.d_m)];

nomA = 0;
denomA = 0;
for d_idx = 1:length(datasetA.d_m)
    nomA = nomA + (log10(datasetA.d_m(d_idx) / dsetA_d0)*(datasetA.L_dB(d_idx) - dsetA_PL0));
    denomA = denomA + (10 * log10(datasetA.d_m(d_idx) / dsetA_d0)^2);
end

nomB = 0;
denomB = 0;
for d_idx = 1:length(datasetB.d_m)
    nomB = nomB + (log10(datasetB.d_m(d_idx) / dsetB_d0)*(datasetB.L_dB(d_idx) - dsetB_PL0));
    denomB = denomB + (10 * log10(datasetB.d_m(d_idx) / dsetB_d0)^2);
end

nA = nomA / denomA
nB = nomB / denomB

% Compute model path losses
dsetA_model_Ls = zeros(length(datasetA.L_dB),1);
dsetB_model_Ls = zeros(length(datasetB.L_dB),1);

% Dataset A losses
for d_idx = 1:length(datasetA.d_m)
    dsetA_model_Ls(d_idx) = dsetA_PL0 + 10 * nA * log10(datasetA.d_m(d_idx) / dsetA_d0);
end

% Dataset B losses
for d_idx = 1:length(datasetB.d_m)
    dsetB_model_Ls(d_idx) = dsetB_PL0 + 10 * nB *log10(datasetB.d_m(d_idx) / dsetB_d0);
end

stdA = sqrt((1 / length(datasetA.d_m)) * sum((datasetA.L_dB - dsetA_model_Ls).^2))
stdB = sqrt((1 / length(datasetB.d_m)) * sum((datasetB.L_dB - dsetB_model_Ls).^2))

figure(1);
subplot(2,1,1);
scatter(datasetA.d_m, datasetA.L_dB);
hold on;
plot(datasetA.d_m, dsetA_model_Ls);
hold off;
title("Dataset A")
xscale log;
legend("Dataset A", "Path Loss Model")
xlabel("Distance (m)")
ylabel("Path Loss (dB)")

subplot(2,1,2);
scatter(datasetB.d_m, datasetB.L_dB);
hold on;
plot(datasetB.d_m, dsetB_model_Ls);
hold off;
title("Dataset B")
xscale log;

legend("Dataset B", "Path Loss Model")
xlabel("Distance (m)")
ylabel("Path Loss (dB)")