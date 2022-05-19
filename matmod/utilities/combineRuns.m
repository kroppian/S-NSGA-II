
clear;

addpath("..");
addpath("../configs");
addpath("../utilities");

INPUT_FILES = {
    '/Volumes/Gilgamesh/kroppian/sNSGAIIRuns/sNSGAIIComparative_compDecVar_SMOP8_MOEAPSL', ...
    '/Volumes/Gilgamesh/kroppian/sNSGAIIRuns/sNSGAIIComparative_compDecVar_SMOP8_MPMMEA', ...
    '/Volumes/Gilgamesh/kroppian/sNSGAIIRuns/sNSGAIIComparative_compDecVar_SMOP8_sparseEA'    
};

OUTPUT_FILE = '/Volumes/Gilgamesh/kroppian/sNSGAIIRuns/sNSGAIIComparative_compDecVar_SMOP8.mat';

sNSGA_eff_400;

% Establish base variables
disp("Loading file 1...");
file = INPUT_FILES{1};
load(file);

config_core = config;
res = res_final; 


for f = 2:numel(INPUT_FILES)

    fprintf("Loading file %d...\n", f);
    file = INPUT_FILES{f};
    load(file);
    
    config_core.algorithms = [config_core.algorithms, config.algorithms];
    config_core.mutation_method = [config_core.mutation_method, config.mutation_method];
    config_core.crossover_method = [config_core.crossover_method, config.crossover_method];
    config_core.sampling_method = [config_core.sampling_method, config.sampling_method];
    config_core.labels = [config_core.labels, config.labels];

    res = [res; res_final];
    
end

res_final = res; 
config = config_core;

disp("Saving results...");
save(OUTPUT_FILE, 'res_final', 'config');
disp("Done.");
