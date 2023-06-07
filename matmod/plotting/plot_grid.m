
%% Setup 
clear

addpath("../configs/");
addpath("../plotting/");

addpath("..");

sNSGA_comparative;

%% Run setup 
plotting_on = false;
print_latex_table = false;
print_pval_latex_table = true;

% Analysis metrics
metrics = {'HV', 'time', 'nds'};

%% Uncomment for comparative decision variable runs
output_files = { ...
    'Z:\Gilgamesh\kroppian\sNSGAIIRuns\comparative\sNSGAIIComparative_compDecVar_SMOP1.mat', ...
    'Z:\Gilgamesh\kroppian\sNSGAIIRuns\comparative\sNSGAIIComparative_compDecVar_SMOP2.mat', ...
    'Z:\Gilgamesh\kroppian\sNSGAIIRuns\comparative\sNSGAIIComparative_compDecVar_SMOP3.mat', ...
    'Z:\Gilgamesh\kroppian\sNSGAIIRuns\comparative\sNSGAIIComparative_compDecVar_SMOP4.mat', ...
    'Z:\Gilgamesh\kroppian\sNSGAIIRuns\comparative\sNSGAIIComparative_compDecVar_SMOP5.mat', ...
    'Z:\Gilgamesh\kroppian\sNSGAIIRuns\comparative\sNSGAIIComparative_compDecVar_SMOP6.mat', ...
    'Z:\Gilgamesh\kroppian\sNSGAIIRuns\comparative\sNSGAIIComparative_compDecVar_SMOP7.mat', ...
    'Z:\Gilgamesh\kroppian\sNSGAIIRuns\comparative\sNSGAIIComparative_compDecVar_SMOP8.mat'  ...
    };

testProblemsUsed = { ...
    'SMOP1', ...
    'SMOP2', ...
    'SMOP3', ...
    'SMOP4', ...
    'SMOP5', ...
    'SMOP6', ...
    'SMOP7', ...
    'SMOP8'  ... 
    };
% end -- comparative decision variable runs


results = cell(numel(testProblemsUsed),1);
configs = cell(numel(testProblemsUsed),1); 

disp("Loading files...");
for p = 1:numel(testProblemsUsed)
    
    load(output_files{p});

    results{p} = res_final;
    configs{p} = config;

end
disp("Done.");


%% Plotting

for m = 1:numel(metrics)
    figure; 
    for p = 1:numel(testProblemsUsed)
        subplot(3,3,p);
        
        res_final = results{p};

        config = configs{p};

        plot_metric(metrics{m},   "D", config, res_final);


    end
end



