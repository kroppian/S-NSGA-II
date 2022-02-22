
%% Comparative runs
platPath = 'M:\Projects\PlatEMO_3.4.0\PlatEMO\';
sNSGAIIPath = 'M:\Projects\cropover\matmod\sNSGAII';
repetitions = 30;
algorithms = {@SparseEA, @sNSGAII};
sps_on = {false, true};
labels = ["SparseEA", "NSGAII-SPS"];
run_label = "comparative";

% Reference point for hypervolume calculation
max_ref = 7;
refPoints = 1:max_ref;

% Problem
prob = @SMOP1;

% true to make the dependent variable # of decision variables
% false to make the dependent variable sparsity % 
indep_var_dec_vars = false;

defaultDecVar = 1000;
defaultSparsity = 0.1;

% Number of decision variables
Dz = {100, 500, 1000, 2500, 5000, 7500};

% Sparsity options
sparsities = linspace(0.05, 0.45,9);
