clear;

algorithmsUsed = {'SparseEA', 'NSGAII-SPS'};

load('runResultsSMOP3.mat')

% cols = {'# of decision vars', 'Algorithm', 'Average HV', ...
%     'Lower within 95% conf', 'Highest within 95% conf', ...
%     'Run time', 'Number of non-dom. solution'};

fileNames = {'runResultsSMOP1.mat', 'runResultsSMOP2.mat', ...
    'runResultsSMOP3.mat', 'runResultsSMOP4.mat', 'runResultsSMOP5.mat',...
    'runResultsSMOP6.mat','runResultsSMOP7.mat', 'runResultsSMOP8.mat'};

testProblemsUsed = {'SMOP1','SMOP2','SMOP3','SMOP4','SMOP5','SMOP6','SMOP7','SMOP8'};

numPossibleDecVars = numel(decVars);
numTestProbs = numel(fileNames);
numAlgorithms = numel(algorithmsUsed);

numRows = numAlgorithms*numPossibleDecVars*numTestProbs;


% Columns of the table
numDecVars = ones(numRows,1)*-1;
algorithm = cell(numRows,1);
testProbs = cell(numRows,1);
% HV
hvAvg = ones(numRows,1)*-1;
hvLower95 = ones(numRows,1)*-1;
hvUpper95 = ones(numRows,1)*-1;
% Runtime
runTimeAvg = ones(numRows,1)*-1;
runTimeLower95 = ones(numRows,1)*-1;
runTimeUpper95 = ones(numRows,1)*-1;
% Number of non-dominated solutions
numNonDomAvg = ones(numRows,1)*-1;
numNonDomLower95 = ones(numRows,1)*-1;
numNonDomUpper95 = ones(numRows,1)*-1;


row = 1;

% For each test problem type
for t = 1:numTestProbs
    load(fileNames{t});
    
    % For each algorithm
    for a = 1:numAlgorithms
        
        % for each number of decision variables
        for d = 1:numPossibleDecVars
            
            testProbs{row} = testProblemsUsed{t};
            
            %% Decision variables
            decVar = decVars(d);
            
            numDecVars(row) = decVar;
            
            %% algorithms
            currentAlgorithm = algorithmsUsed{a};
            
            algorithm{row} = currentAlgorithm;
            
            %% HV
            
            % Mean HV
            rawHV = HVResults(:,d,a);
            currentMeanHV = mean(rawHV);
            
            hvAvg(row) = currentMeanHV;
            
            stdErr = std(rawHV)/sqrt(length(rawHV));
            ts = tinv([0.025  0.975],length(rawHV)-1);
            CI  = currentMeanHV + ts*stdErr;

            hvLower95(row) = min(CI);
            hvUpper95(row) = max(CI);
            
            %% Run times
            rawRuntime = timeResults(:,d,a);
            currentRunTimeAvg = mean(rawRuntime);
            
            runTimeAvg(row) = currentRunTimeAvg;
            
            stdErr = std(rawRuntime)/sqrt(length(rawRuntime));
            ts = tinv([0.025  0.975],length(rawRuntime)-1);
            CI  = currentRunTimeAvg + ts*stdErr;

            runTimeLower95(row) = min(CI);
            runTimeUpper95(row) = max(CI);
            
            %% Number of non-dominated members
            rawNoNomDoms = noNonDoms(:,d,a);
            currentNoNomDomsMean = mean(rawNoNomDoms);
            
            numNonDomAvg(row) = currentNoNomDomsMean;
            
            stdErr = std(rawNoNomDoms)/sqrt(length(rawNoNomDoms));
            ts = tinv([0.025  0.975],length(rawNoNomDoms)-1);
            CI  = currentNoNomDomsMean + ts*stdErr;

            numNonDomLower95(row) = min(CI);
            numNonDomUpper95(row) = max(CI);
            
            
            %% Prep for next iteration
            row = row + 1;

            
        end
    end
end


%% Make the table

resultsTable = table(numDecVars, algorithm, testProbs, hvAvg, hvLower95, hvUpper95, runTimeAvg, runTimeLower95, runTimeUpper95, numNonDomAvg, numNonDomLower95, numNonDomUpper95);



