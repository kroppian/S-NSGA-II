
clear

%config_comparative
%config_effective
%config_mutationTest
config_cropoverTest

%% Run optimization
res = runOptBatch(config);


%% Calc metrics
medSparsities = calcMedianSparsities(res);
res.medSparsities = medSparsities;

% Plot the sparsity over generations
targetSparsity = config.defaultSparsity;
sample_s_mut_on  = res(res.run == 1 & res.D == 2500 & res.s == targetSparsity & res.sps_on & res.s_mut_on, :);
sample_s_mut_off = res(res.run == 1 & res.D == 2500 & res.s == targetSparsity & res.sps_on & (~res.s_mut_on), :);

subplot(2,1,1);
plot(sample_s_mut_on.medSparsities); hold on;
plot(sample_s_mut_off.medSparsities); hold on;
plot(ones(length(sample_s_mut_on.medSparsities),1)*(1 -targetSparsity)); hold on;
legend("sparse mutation on", "sparse mutation off", "Optimal sparsity");
xlabel("Generation");
ylabel("Median population sparsity");

subplot(2,1,2);
plot(sample_s_mut_on.HV);
hold on;
plot(sample_s_mut_off.HV);
legend("sparse mutation on", "sparse mutation off");
xlabel("Generation");
ylabel("Median solution HV");






