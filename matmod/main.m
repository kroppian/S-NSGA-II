
clear

%config_comparative
%config_effective
config_mutationTest

%% Run optimization
res = runOptBatch(config);

disp("Plotting...")
metric = 1;

%% Calc metrics
medSparsities = calcMedianSparsities(res);
res.medSparsities = medSparsities;

%% Plot final results 
final_pops = res(res.gen == 200,:);

plot_metric(metric, config, final_pops);
disp("Done.")


