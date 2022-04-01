
clear

addpath("configs");

%comparative
%effective
%mutationTest
%cropoverTest_effective
cropoverTest_comp


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
sample_s_mut_on  = res(res.run == 1 & res.D == 1000 & res.s == targetSparsity & res.s_mut_on, :);
sample_s_mut_off = res(res.run == 1 & res.D == 1000 & res.s == targetSparsity & (~res.s_mut_on), :);

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

%% Checking out individual fronts
run = 3;
s_mut_on_pop = res_final{res_final.run == run & res_final.D == 100 & res_final.alg == "sNSGAII", 'population'};
s_mut_off_pop = res_final{res_final.run == run & res_final.D == 100 & res_final.alg == "SparseEA2", 'population'};

s_mut_on_pop = s_mut_on_pop.best.objs;
s_mut_off_pop = s_mut_off_pop.best.objs; 

figure
scatter(s_mut_on_pop(:,1), s_mut_on_pop(:,2));
hold on;
scatter(s_mut_off_pop(:,1), s_mut_off_pop(:,2));


%% Full metric plots

plot_metric("HV", "D", config, res_final);




