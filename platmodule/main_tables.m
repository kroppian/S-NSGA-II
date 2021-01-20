clear;

algorithmsUsed = {'SparseEA', 'NSGAII-SPS'};

load('runResultsSMOP3.mat')

decVarsUsed = decVars;

% cols = {'# of decision vars', 'Algorithm', 'Average HV', ...
%     'Lower within 95% conf', 'Highest within 95% conf', ...
%     'Run time', 'Number of non-dom. solution'};

fileNames = {'runResultsSMOP1.mat', 'runResultsSMOP2.mat', ...
    'runResultsSMOP3.mat', 'runResultsSMOP4.mat', 'runResultsSMOP5.mat',...
    'runResultsSMOP6.mat','runResultsSMOP7.mat', 'runResultsSMOP8.mat'};

testProblemsUsed = {'SMOP1','SMOP2','SMOP3','SMOP4','SMOP5','SMOP6','SMOP7','SMOP8'};

numRepetitions = size(HVResults,1);
numPossibleDecVars = numel(decVars);
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
                decVar = decVars(d);

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

save('resultsTable.mat', 'resultsTable', 'algorithmsUsed', 'testProblemsUsed', 'decVarsUsed')


