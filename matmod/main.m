
clear

addpath("configs");
addpath("utilities");
addpath("plotting");


%sNSGA_eff_sparsity;
sNSGA_eff_400;
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
    if config.saveAllGens
        save(fullSavePath, 'res_final', 'res', 'config', '-v7.3');
    else        
        save(fullSavePath, 'res_final', 'config', '-v7.3');
    end

end

run = 1;

%% Genome observation

%test_pop_mut_off = res_final{res_final.run == 1 & res_final.D == 100 & res_final.alg == "SparseEA2", 'population'};
% test_pop_status_quo = res_final{res_final.run == run & res_final.D == 100 & (~res_final.stripe_s), 'population'};
% test_pop_new        = res_final{res_final.run == run & res_final.D == 100 & res_final.stripe_s, 'population'};
% 
% test_pop_status_quo = test_pop_status_quo{1}.best.decs;
% test_pop_new        = test_pop_new{1}.best.decs;

%% Plotting
%load("Z:\Gilgamesh\kroppian\sNSGAIIRuns\400run\sNSGAIIEffective_compDecVar_SMOP2.mat");

D = 100;

figure;
%plot_generational_info(res, config, run, D, getAlgIds(config));
algs = getAlgIds(config);
plot_generational_info(res, config, run, D, {algs{1}});

figure;
plot_final_pareto(res_final, config, run, D);

figure;
plot_strip_scatter(res_final, config, D);

% Full metric plots
% Example load command: 
%load('Z:\Gilgamesh\kroppian\sNSGAIIRuns\finalVersions\sNSGAIIEffective_effDecVar_SMOP1.mat')
load('C:\Users\Ian Kropp\Desktop\sNSGAII\sNSGAIIComparative_compDecVar_SMOP4.mat')

algs = getAlgIds(config);

toInclude = ~strcmp(algs,'sNSGAII_island_v2-VariedStripedSparseSampler_v2-sparsePolyMutate-cropover_v2') & ~strcmp(algs,'sNSGAII_island_v1-VariedStripedSparseSampler_v2-sparsePolyMutate-cropover_v2') & ~strcmp(algs,'sNSGAII-VariedStripedSparseSampler_v2-sparsePolyMutate-cropover_v2');
%toInclude = ~strcmp(algs,'sNSGAII_island_v2-VariedStripedSparseSampler_v2-sparsePolyMutate-cropover_v2') & ~strcmp(algs,'sNSGAII_island_v1-VariedStripedSparseSampler_v2-sparsePolyMutate-cropover_v2');


figure;
plot_metric("HV",   "D", config, res_final, algs(toInclude));

