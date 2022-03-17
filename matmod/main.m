
clear

%config_comparative
%config_effective
config_mutationTest

%% Run optimization
res = runOptBatch(config);


%% Calc metrics
medSparsities = calcMedianSparsities(res);
res.medSparsities = medSparsities;

sample = res(res.run == 1 & res.D == 100 & res.s == 0.1 & res.sps_on & res.s_mut_on, :);
subplot(2,1,1);
plot(sample.medSparsities);

subplot(2,1,2);
plot(sample.HV);




%% Plot median sparsity 

disp("Plotting...")
metric = 1;


%% Plot final results 


disp("Plotting...")
metric = 1;

final_pops = res(res.gen == 200,:);

plot_metric(metric, config, final_pops);
disp("Done.")


