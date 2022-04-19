
clear

addpath("configs");
addpath("utilities");


%sNSGA_eff;
sNSGA_eff_500;
%sNSGA_comparative;

if config.saveData
    file_name = strcat(config.run_label, '_', config.runType, '_', strrep(char(config.prob),'@(x)',''), '.mat');
    fullSavePath = strcat(config.savePath, file_name);
    if ~exist(config.savePath, 'dir')
        error("Output path does not exist.");
    end
end


%% Run optimization
res = runOptBatch(config);


%% Post processing
medSparsities = calcMedianSparsities(res);
res.medSparsities = medSparsities;

% Get a last generation cross section of the results 
res_final = res(res.gen == res.max_gen,:);

if config.saveData
    save(fullSavePath, 'res_final');
end

run = 3;

%% Genome observation

%test_pop_mut_off = res_final{res_final.run == 1 & res_final.D == 100 & res_final.alg == "SparseEA2", 'population'};
test_pop_status_quo = res_final{res_final.run == run & res_final.D == 100 & (~res_final.stripe_s), 'population'};
test_pop_new        = res_final{res_final.run == run & res_final.D == 100 & res_final.stripe_s, 'population'};

test_pop_status_quo = test_pop_status_quo{1}.best.decs;
test_pop_new        = test_pop_new{1}.best.decs;

%% Quick plot
% Plot the sparsity/HV over generations

%algorithms = unique(res_final.alg); 

alg_count = numel(unique(res_final.alg));
legend_entries = cell(alg_count+1 ,1);

max_gen = -1; 

subplot(2,1,1);

% Plot each algorithm sparsity performance 
for a = 1:alg_count
    alg = genRunId(config, a);
    medSparsity = res{res.run == run & res.D == 400 & strcmp(res.alg, alg), 'medSparsities'};
    plot(medSparsity);
    legend_entries{a} = config.labels{a}; 
    %legend_entries{a} = cleanLegendEntry(alg); 

    max_gen = max(max_gen, numel(medSparsity));
    hold on;
end

% Plot optimal sparsity 
targetSparsity = config.defaultSparsity;
plot(ones(max_gen,1)*(1 -targetSparsity)); 

% labeling 
legend_entries{alg_count + 1} = "Target sparsity";
legend(legend_entries);

xlabel("Generation");
ylabel("Median population sparsity");
title(func2str(config.prob));

% Next, hypervolume 
subplot(2,1,2);

% Plot each algorithm HV performance 
for a = 1:alg_count
    alg = genRunId(config, a);
    medSparsity = res{res.run == run & res.D == 400 & strcmp(res.alg, alg), 'HV'};
    plot(medSparsity);
    max_gen = max(max_gen, numel(medSparsity));
    hold on;
end

xlabel("Generation");
ylabel("Population HV");

%% Checking out individual fronts
pop_status_quo = res_final{res_final.run == run & res_final.D == 100 & (~res_final.stripe_s), 'population'};
pop_new = res_final{res_final.run == run & res_final.D == 100 & res_final.stripe_s, 'population'};

pop_status_quo = pop_status_quo{1}.best.objs; 
pop_new = pop_new{1}.best.objs;

figure
scatter(pop_new(:,1), pop_new(:,2));
hold on;
scatter(pop_status_quo(:,1), pop_status_quo(:,2));
legend("New method", "Status quo");

%% Full metric plots
% Example load command: 
% load('Z:\Gilgamesh\kroppian\sNSGAIIRuns\sNSGAIIComparative_compDecVar_SMOP1.mat')
plot_metric("HV",   "D", config, res_final);




