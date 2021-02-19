clear;

%% Comparative runs parameters for # of decision variables 
%  (uncomment/comment to use/not use)
% algorithmsUsed = {'SparseEA', 'NSGAII-SPS'};
% load('data/runResults_comparative_decVar_SMOP1.mat');
% decVarsUsed = [100, 500, 1000, 2500, 5000, 7500];
% 
% 
% fileNames = {'data/runResults_comparative_decVar_SMOP1.mat', ... 
%              'data/runResults_comparative_decVar_SMOP2.mat', ... 
%              'data/runResults_comparative_decVar_SMOP3.mat', ...
%              'data/runResults_comparative_decVar_SMOP4.mat', ...
%              'data/runResults_comparative_decVar_SMOP5.mat', ...
%              'data/runResults_comparative_decVar_SMOP6.mat', ...
%              'data/runResults_comparative_decVar_SMOP7.mat', ...
%              'data/runResults_comparative_decVar_SMOP8.mat'};
% 
% 
% label = "comparative";
% % Set to true if the run is on decision variables. False for sparsrity 
% usesDecVar = true

%% Comparative runs parameters for # of decision variables 
algorithmsUsed = {'SparseEA', 'NSGAII-SPS'};
load('data/runResults_comparative_sparsity_SMOP1.mat');
sparsitiesUsed = (1-linspace(0.05, 0.45,9))*100;

fileNames = {'data/runResults_comparative_sparsity_SMOP1.mat', ... 
             'data/runResults_comparative_sparsity_SMOP2.mat', ... 
             'data/runResults_comparative_sparsity_SMOP3.mat', ...
             'data/runResults_comparative_sparsity_SMOP4.mat', ...
             'data/runResults_comparative_sparsity_SMOP5.mat', ...
             'data/runResults_comparative_sparsity_SMOP6.mat', ...
             'data/runResults_comparative_sparsity_SMOP7.mat', ...
             'data/runResults_comparative_sparsity_SMOP8.mat'};

label = "comparative";
% Set to true if the run is on decision variables. False for sparsrity 
usesDecVar = false;

%% Effective run parameters (uncomment/comment to use/not use)
% algorithmsUsed = {'MOPSO', 'MOPSO-SPS', 'MOEADDE', 'MOEADDE-SPS', 'NSGAII', 'NSGAII-SPS'};
% decVarsUsed = [100, 500, 1000, 2500, 5000, 7500];
% fileNames = {'data/runResults_comparative_SMOP1.mat', 'data/runResults_comparative_SMOP2.mat', ...
%  'data/runResults_comparative_SMOP3.mat', 'data/runResults_comparative_SMOP4.mat', ...
%  'data/runResults_comparative_SMOP5.mat', 'data/runResults_comparative_SMOP6.mat', ...
%  'data/runResults_comparative_SMOP7.mat', 'data/runResults_comparative_SMOP8.mat'};
% load(fileNames{1});
% label = "effective";

%% Remaining parameters

testProblemsUsed = {'SMOP1','SMOP2','SMOP3','SMOP4','SMOP5','SMOP6','SMOP7','SMOP8'};

numRepetitions = size(HVResults,1);
numTestProbs = numel(fileNames);
numAlgorithms = numel(algorithmsUsed);
if usesDecVar
    numDependentVar = numel(decVarsUsed);
else
    numDependentVar = numel(sparsitiesUsed);
end

numRows = numAlgorithms*numDependentVar*numTestProbs*numRepetitions;


% Columns of the table
if usesDecVar
    numDecVars = ones(numRows,1)*-1;
else
    sparsities = ones(numRows,1)*-1;
end

algorithm = cell(numRows,1);
testProbs = cell(numRows,1);
hv = ones(numRows,1)*-1;
runTimes = ones(numRows,1)*-1;
numNonDom = ones(numRows,1)*-1;
repetition = ones(numRows,1)*-1;

%% Build table

row = 1;

% For each test problem type
for t = 1:numTestProbs
    load(fileNames{t});
    
    % For each algorithm
    for a = 1:numAlgorithms
        
        % for each number of decision variables
        for d = 1:numDependentVar
            
            % For each repetition
            for r = 1:numRepetitions
                
                repetition(row) = r;
                
                % Test problem
                testProbs{row} = testProblemsUsed{t};

                if usesDecVar
                    % Decision variables
                    decVar = decVarsUsed(d);
                    numDecVars(row) = decVar;
                else
                    sparsity = sparsitiesUsed(d);
                    sparsities(row) = sparsity;
                end
                
                %% algorithms
                currentAlgorithm = algorithmsUsed{a};

                algorithm{row} = currentAlgorithm;

                % HV
                hv(row) = HVResults(r,d,a);

                % Run times
                runTimes(row) = timeResults(r,d,a);

                % Number of non-dominated members
                numNonDom(row) = noNonDoms(r,d,a);

                %% Prep for next iteration
                row = row + 1;

            end
           
        end
    end
end


%% Make the table


if usesDecVar
    resultsTable = table(numDecVars, algorithm, testProbs, repetition, hv, runTimes, numNonDom);
    filename = strcat(label, '_decVar_resultsTable.mat');
    save(filename, 'resultsTable', 'algorithmsUsed', 'testProblemsUsed', 'decVarsUsed');
else
    resultsTable = table(sparsities, algorithm, testProbs, repetition, hv, runTimes, numNonDom);
    filename = strcat(label, '_sparsity_resultsTable.mat');
    save(filename, 'resultsTable', 'algorithmsUsed', 'testProblemsUsed', 'sparsitiesUsed');
end





