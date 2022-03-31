
clear

%config_comparative
%config_effective
%config_mutationTest
config_cropoverTest_effective

%% Run optimization
res = runOptBatch(config);


%% Post processing
medSparsities = calcMedianSparsities(res);
res.medSparsities = medSparsities;

% Get a last generation cross section of the results 
res_final = res(res.gen == res.max_gen,:);

%% Quick plot
% Plot the sparsity over generations
targetSparsity = config.defaultSparsity;
sample_s_mut_on  = res(res.run == 2 & res.D == 1000 & res.s == targetSparsity & res.s_mut_on, :);
sample_s_mut_off = res(res.run == 2 & res.D == 1000 & res.s == targetSparsity & (~res.s_mut_on), :);

subplot(2,1,1);
plot(sample_s_mut_on.medSparsities); hold on;
plot(sample_s_mut_off.medSparsities); hold on;
plot(ones(length(sample_s_mut_on.medSparsities),1)*(1 -targetSparsity)); hold on;
legend("sparse mutation on", "sparse mutation off", "Optimal sparsity");
xlabel("Generation");
ylabel("Median population sparsity");
title(func2str(config.prob));

subplot(2,1,2);
plot(sample_s_mut_on.HV);
hold on;
plot(sample_s_mut_off.HV);
legend("sparse mutation on", "sparse mutation off");
xlabel("Generation");
ylabel("Median solution HV");


%% Full metric plots

plot_metric("HV", "D", config, res_final);




