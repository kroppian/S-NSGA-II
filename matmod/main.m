
clear

addpath("configs");
addpath("utilities");
addpath("plotting");
addpath("problems")

%sNSGA_eff_sparsity;
%sNSGA_comparative_Sparse_NN
%sNSGA_comparative;
%sNSGA_ablation;
%sNSGA_comparative_decVar_sparseSR
NSGA_TIME_RUN

if config.saveData
    file_name = strcat(config.run_label, '_', config.runType, '_', strrep(char(config.prob),'@(x)',''), '_new.mat');
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
alg = getAlgIds(config);
plot_generational_info(res, config, run, D, {alg{1}});

figure;
plot_final_pareto(res_final, config, run, D);

figure;
plot_strip_scatter(res_final, config, D);

% Full metric plots
% Example load command: 
%load('Z:\Gilgamesh\kroppian\sNSGAIIRuns\finalVersions\sNSGAIIEffective_effDecVar_SMOP1.mat')
%load('Z:\Gilgamesh\kroppian\sNSGAIIRuns\classicLineup\sNSGAIIEffective_effDecVar_SMOP5.mat')
load('Z:\Gilgamesh\kroppian\sNSGAIIRuns\finalVersions\Comparative_compDecVar_Sparse_NN_3.mat')
load('/mnt/nas/kroppian/sNSGAIIRuns/ablationRuns/sNSGAIIAblation_compDecVar_SMOP1_new.mat');

algs =    {'sNSGAII-VariedStripedSparseSampler_v3-sparsePolyMutate-cropover_v2', 'SparseEA', 'SparseEA2', 'MOEAPSL', 'PMMOEA'};
figure;
plot_metric("HV",   "D", config, res_final, alg);






