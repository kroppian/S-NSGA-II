%% Environment set up 

clear;

globalTimeStart = cputime;

% Path to the install path of plat EMO 
platEMOPath = '/Users/iankropp/Projects/platEMO/';
[workingDir, name, ext]= fileparts(mfilename('fullpath'));
addpath(genpath(platEMOPath));
addpath(workingDir);

%% Parameters
% Number of repetitions for each run configuration
reps = 60;


% Algorithms

%% Parameters for comparative runs
%algorithms = {@SparseEA, @NSGAII, @NSGAII};
% colors = ["red", "blue", "green"];
% sps_on = {false, true, false};
% labels = ["SparseEA", "NSGAII-SPS", "NSGAII"];

%% Parameters for effective runs
algorithms = {@MOPSO, @MOPSO, @MOEADDE, @MOEADDE, @NSGAII, @NSGAII};
sps_on = {false, true, false, true, false, true};
labels = ["MOPSO", "MOPSO-SPS", "MOEADDE", "MOEADDE-SPS", "NSGAII", "NSGAII-SPS"];

%% Remaining parameters
run_label = "effective";

% Reference point for hypervolume calculation
refPoint = [7,7];

% Problem
prob = @SMOP2;

% 1 to make the dependent variable # of decision variables
% 0 to make the dependent variable sparsity % 
indep_var_dec_vars = false;
defaultDecVar = 1000;
defaultSparsity = 0.1;


% Number of decision variables
Dz = {100, 500, 1000, 2500, 5000, 7500};

% Sparsity options
sparsities = (1:4)*0.1;

if indep_var_dec_vars
    sparsities = [defaultSparsity];
else
    Dz = {defaultDecVar};
end
    
% Dimension one:   repetition
% Dimension two:   # of decision variables
% Dimension three: algorithm
HVResults   = ones(reps, numel(Dz), numel(algorithms))*-1;
timeResults = ones(reps, numel(Dz), numel(algorithms))*-1;
noNonDoms   = ones(reps, numel(Dz), numel(algorithms))*-1;

%% Main 

for s = 1:numel(sparsities)

    % for each # of decision variables
    for i = 1:size(Dz,2)

        % for each possible algorithm 
        for a = 1:size(algorithms,2)

            if indep_var_dec_vars
                fprintf("Running algorithm %s with %d decision variables\n", labels{a}, Dz{i});
            else
                fprintf("Running algorithm %s with sparsity of %d\n", labels{a}, sparsities(s));
            end

            % for each repetition

            %parpool(4);

            for rep = 1:reps

                if indep_var_dec_vars
                    index = i;
                else
                    index = s;
                end
                
                tStart = cputime;
                final_pop = runOpt(algorithms{a}, Dz{i}, sparsities(s), prob, sps_on{a});
                tEnd = cputime - tStart;

                hv = CalHV(final_pop, refPoint);

                HVResults(rep, index, a) = hv;
                timeResults(rep, index, a) = tEnd;
                noNonDoms(rep, index, a) = size(final_pop,1);

            end

        end

    end
end


if indep_var_dec_vars 
    run_type = "decVar";
else
    run_type = "sparsity";
end

file_name = strcat('runResults_', run_label, '_', run_type, '_', strrep(char(prob),'@(x)',''), '.mat');

% Save results so we don't have to 
save(file_name, 'HVResults', 'timeResults', 'noNonDoms');

globalTimeEnd = cputime - globalTimeStart;

fprintf("Took %f seconds\n", globalTimeEnd);

