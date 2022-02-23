
clear

config_comparative
%config_effective

%% Run optimization
res = runOptBatch(config);

metric = 3;

plot_metric(metric, config, res);


