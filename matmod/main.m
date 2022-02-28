
clear

config_comparative
%config_effective

%% Run optimization
res2 = runOptBatch(config);

metric = 1;

plot_metric(metric, config, res);


