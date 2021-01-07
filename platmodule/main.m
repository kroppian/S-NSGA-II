%% Environment set up 

clear;

% Path to the install path of plat EMO 
platEMOPath = '/Users/iankropp/Projects/platEMO/SIBEA/';
[workingDir, name, ext]= fileparts(mfilename('fullpath'));
addpath(genpath(platEMOPath));
addpath(workingDir);

%% Parameters
% Number of repetitions for each run configuration
reps = 60;

% Reference point for hypervolume calculation
refPoint = [7,7];

% Algorithms
algorithms = {@SparseEA, @NSGAII, @NSGAII};
colors = ["red", "blue", "green"];
sps_on = {false, true, false};
labels = ["SparseEA", "NSGAII-SPS", "NSGAII"];


% Number of decision variables
Dz = {100, 500, 1000, 5000};

% Dimension one:   repetition
% Dimension two:   # of decision variables
% Dimension three: algorithm
HVResults   = ones(reps, numel(Dz), numel(algorithms))*-1;
timeResults = ones(reps, numel(Dz), numel(algorithms))*-1;
noNonDoms   = ones(reps, numel(Dz), numel(algorithms))*-1;

%% Main 

% for each # of decision variables
for i = 1:size(Dz,2)

    % for each possible algorithm 
    for a = 1:size(algorithms,2)

        fprintf("Running algorithm %s with %d decision variables\n", labels{a}, Dz{i});
        
        % for each repetition
       
        for rep = 1:reps
            
            tStart = cputime;
            final_pop = runOpt(algorithms{a}, Dz{i}, sps_on{a});
            tEnd = cputime - tStart;

            hv = CalHV(final_pop, refPoint);
        
            HVResults(rep, i, a) = hv;
            timeResults(rep, i, a) = tEnd;
            noNonDoms(rep, i, a) = size(final_pop,1);
            
        end
        
    end

end

% Save results so we don't have to 
save('runResults.mat', 'HVResults', 'timeResults', 'noNonDoms');

%% Post processing







