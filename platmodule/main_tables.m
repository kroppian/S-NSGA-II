clear;

%% Comparative runs parameters (uncomment/comment to use/not use)
algorithmsUsed = {'SparseEA', 'NSGAII-SPS'};
load('data/runResultsSMOP1.mat');
decVarsUsed = decVars;
fileNames = {'data/runResultsSMOP1.mat', 'data/runResultsSMOP2.mat', ...
 'data/runResultsSMOP3.mat', 'data/runResultsSMOP4.mat', 'data/runResultsSMOP5.mat', ...
 'data/runResultsSMOP6.mat', 'data/runResultsSMOP7.mat', 'data/runResultsSMOP8.mat'};

label = "comparative";

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
numPossibleDecVars = numel(decVarsUsed);
numTestProbs = numel(fileNames);
numAlgorithms = numel(algorithmsUsed);

numRows = numAlgorithms*numPossibleDecVars*numTestProbs*numRepetitions;

% Columns of the table
numDecVars = ones(numRows,1)*-1;
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
        for d = 1:numPossibleDecVars
            
            % For each repetition
            for r = 1:numRepetitions
                
                repetition(row) = r;
                
                % Test problem
                testProbs{row} = testProblemsUsed{t};

                % Decision variables
                decVar = decVarsUsed(d);

                numDecVars(row) = decVar;

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

resultsTable = table(numDecVars, algorithm, testProbs, repetition, hv, runTimes, numNonDom);

filename = strcat(label, '_resultsTable.mat');

save(filename, 'resultsTable', 'algorithmsUsed', 'testProblemsUsed', 'decVarsUsed');


