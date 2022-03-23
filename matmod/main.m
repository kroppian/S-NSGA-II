
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
targetSparsity = 0.1;
sample_s_mut_on  = res(res.run == 2 & res.D == 1000 & res.s == targetSparsity & res.sps_on & res.s_mut_on, :);
sample_s_mut_off = res(res.run == 2 & res.D == 1000 & res.s == targetSparsity & res.sps_on & (~res.s_mut_on), :);

subplot(2,1,1);
plot(sample_s_mut_on.medSparsities);
hold on;
plot(sample_s_mut_off.medSparsities);
plot(ones(length(sample_s_mut_on.medSparsities))*(1 -targetSparsity));
legend("on", "off", "perfect");


subplot(2,1,2);
plot(sample_s_mut_on.HV);
hold on;
plot(sample_s_mut_on.HV);
plot(sample_s_mut_off.HV);
legend("on", "off");







%% Plot median sparsity 

disp("Plotting...")
metric = 1;


%% Plot final results 


disp("Plotting...")
metric = 1;

final_pops = res(res.gen == 200,:);

plot_metric(metric, config, final_pops);
disp("Done.")


