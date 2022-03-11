
clear

%config_comparative
%config_effective
config_mutationTest

%% Run optimization
res = runOptBatch(config);

metric = 1;

plot_metric(metric, config, res);


