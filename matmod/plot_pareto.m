%% Setup 
clear

addpath("configs");
addpath("utilities");
addpath("plotting");

sNSGA_comparative_decVar_sparseSR


%% Run setup 
plotting_on = false;
print_latex_table = true;
print_pval_latex_table = false;

% Analysis metrics
metrics = {'HV', 'time', 'nds'};



%% Uncomment for comparative decision variable runs
% output_files = { ...
%     'Z:\Gilgamesh\kroppian\sNSGAIIRuns\finalVersions\sNSGAIIComparative_compDecVar_SMOP1.mat', ...
%     'Z:\Gilgamesh\kroppian\sNSGAIIRuns\finalVersions\sNSGAIIComparative_compDecVar_SMOP2.mat', ...
%     'Z:\Gilgamesh\kroppian\sNSGAIIRuns\finalVersions\sNSGAIIComparative_compDecVar_SMOP3.mat', ...
%     'Z:\Gilgamesh\kroppian\sNSGAIIRuns\finalVersions\sNSGAIIComparative_compDecVar_SMOP4.mat', ...
%     'Z:\Gilgamesh\kroppian\sNSGAIIRuns\finalVersions\sNSGAIIComparative_compDecVar_SMOP5.mat', ...
%     'Z:\Gilgamesh\kroppian\sNSGAIIRuns\finalVersions\sNSGAIIComparative_compDecVar_SMOP6.mat', ...
%     'Z:\Gilgamesh\kroppian\sNSGAIIRuns\finalVersions\sNSGAIIComparative_compDecVar_SMOP7.mat', ...
%     'Z:\Gilgamesh\kroppian\sNSGAIIRuns\finalVersions\sNSGAIIComparative_compDecVar_SMOP8.mat'  ...
%     };
% 
% testProblemsUsed = { ...
%     'SMOP1', ...
%     'SMOP2', ...
%     'SMOP3', ...
%     'SMOP4', ...
%     'SMOP5', ...
%     'SMOP6', ...
%     'SMOP7', ...
%     'SMOP8'  ... 
%     };

% output_files = { ...
%     'C:\Users\i-kropp\Projects\cropover\matmod\data\sNSGAIIComparative_compDecVar_SMOP8.mat'
%     };
% 
% testProblemsUsed = { ...
%     'SMOP1'
%     };

%% Uncomment for ablation study 
% 
% testProblemsUsed = { ...
%     'SMOP1', ...
%     'SMOP2', ...
%     'SMOP3', ...
%     'SMOP4', ...
%     'SMOP5', ...
%     'SMOP6', ...
%     'SMOP7', ...
%     'SMOP8'  ... 
%     };
% 
% output_files = { ...
%   'C:\Users\i-kropp\Projects\cropover\matmod\data\sNSGAIIAblation_compDecVar_SMOP1_new.mat', ...
%   'C:\Users\i-kropp\Projects\cropover\matmod\data\sNSGAIIAblation_compDecVar_SMOP2_new.mat', ...
%   'C:\Users\i-kropp\Projects\cropover\matmod\data\sNSGAIIAblation_compDecVar_SMOP3_new.mat', ...
%   'C:\Users\i-kropp\Projects\cropover\matmod\data\sNSGAIIAblation_compDecVar_SMOP4_new.mat', ...
%   'C:\Users\i-kropp\Projects\cropover\matmod\data\sNSGAIIAblation_compDecVar_SMOP5_new.mat', ...
%   'C:\Users\i-kropp\Projects\cropover\matmod\data\sNSGAIIAblation_compDecVar_SMOP6_new.mat', ...
%   'C:\Users\i-kropp\Projects\cropover\matmod\data\sNSGAIIAblation_compDecVar_SMOP7_new.mat', ...
%   'C:\Users\i-kropp\Projects\cropover\matmod\data\sNSGAIIAblation_compDecVar_SMOP8_new.mat'  ...
% 
%     };
% 
% baseMethods = {'sNSGAII-VariedStripedSparseSampler_v3-polyMutate-cropover_v2', ... 
%                'sNSGAII-VariedStripedSparseSampler_v3-sparsePolyMutate-sbx', ...
%                'sNSGAII-nop-sparsePolyMutate-cropover_v2'};
% 
% proposedMethod = 'sNSGAII-VariedStripedSparseSampler_v3-sparsePolyMutate-cropover_v2';

%% Uncomment for any of the real-world problems

output_files = {'C:\Users\i-kropp\Projects\cropover\matmod\data\Comparative_compDecVar_Sparse_NN_1.mat'};
testProblemsUsed = { 'Sparse_NN_1' };

% output_files = {'C:\Users\i-kropp\Projects\cropover\matmod\data\Comparative_compDecVar_Sparse_NN_2.mat'};
% testProblemsUsed = { 'Sparse_NN_2' };

% output_files = {'C:\Users\i-kropp\Projects\cropover\matmod\data\Comparative_compDecVar_Sparse_NN_3.mat'};
% testProblemsUsed = { 'Sparse_NN_3' };
 
% output_files = {'C:\Users\i-kropp\Projects\cropover\matmod\data\Comparative_compDecVar_Sparse_PO_1.mat'};
% testProblemsUsed = { 'Sparse_PO_1' };

% output_files = {'C:\Users\i-kropp\Projects\cropover\matmod\data\Comparative_compDecVar_Sparse_PO_1.mat'};
% testProblemsUsed = { 'Sparse_PO_1' };

% output_files = {'C:\Users\i-kropp\Projects\cropover\matmod\data\Comparative_compDecVar_Sparse_PO_2.mat'};
% testProblemsUsed = { 'Sparse_PO_2' };

% output_files = {'C:\Users\i-kropp\Projects\cropover\matmod\data\sNSGAIIComparative_compDecVar_Sparse_SR_simple1.mat'};
% testProblemsUsed = {'Sparse_SR_simple'};

% output_files = {'C:\Users\i-kropp\Projects\cropover\matmod\data\sNSGAIIComparative_compDecVar_Sparse_SR_simple2.mat'};
% testProblemsUsed = {'Sparse_SR_simple'};


% output_files = {'C:\Users\i-kropp\Projects\cropover\matmod\data\sNSGAIIComparative_compDecVar_Sparse_SR_simple2.mat'};
% testProblemsUsed = {'Sparse_SR_simple'};

baseMethods = {'SparseEA', 'SparseEA2', 'MOEAPSL', 'PMMOEA'};
proposedMethod = 'sNSGAII-VariedStripedSparseSampler_v3-sparsePolyMutate-cropover_v2';



load(output_files{1});

decVars = 5121;

%% Plot
run_no = 5; 
method_count = numel(baseMethods) + 1;

figure; 

% Loop through and plot all of the fronts for given run
for m = 1:method_count

    if m == method_count
        current_method = proposedMethod;
    else
        current_method = baseMethods{m};
    end

    run_mask = res_final.run == run_no;
    method_mask = strcmp(res_final.alg, current_method);
    dec_var_mask = res_final.D == decVars;

    solutions = res_final{run_mask & method_mask & dec_var_mask,'population'}{1};

    objs = solutions.best.objs;
    
    if m == method_count
        scatter(objs(:,1), objs(:,2), 'filled');
    else
        scatter(objs(:,1), objs(:,2));

    end

    hold on; 

end

legend({'SparseEA', 'SparseEA2', 'MOEAPSL', 'PMMOEA', 'S-NSGA-II'});













