%% Parameters for effective runs

repetitions = 30;
algorithms = {@MOPSO, @MOPSO, @MOEADDE, @MOEADDE, @NSGAII, @NSGAII};
sps_on = {false, true, false, true, false, true};
labels = ["MOPSO", "MOPSO-SPS", "MOEADDE", "MOEADDE-SPS", "NSGAII", "NSGAII-SPS"];
run_label = "effective";

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