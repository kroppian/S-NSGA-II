%% Setup 

clear;


load('resultsTable');

numAlgorithms = numel(algorithmsUsed);
numPossibleDecVars = numel(decVarsUsed);
numRows = numAlgorithms*numPossibleDecVars;

%% Build table 

% Columns 

% Columns of the table
numDecVars = ones(numRows,1)*-1;
algorithm = cell(numRows,1);
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


    
% For each algorithm
for a = 1:numAlgorithms

    % for each number of decision variables
    for d = 1:numPossibleDecVars

        %% Gather metadata and raw data

        % Accumulate relevant data
        currentAlgorithms = algorithmsUsed{a};
        currentPossibleDecVars = decVarsUsed(d);


        algorithmMask = strcmp(resultsTable.algorithm, currentAlgorithms);
        decVarMask = resultsTable.numDecVars == currentPossibleDecVars;

        table_for_conifg = resultsTable((algorithmMask & decVarMask),:);

        %% Record table metadata
        numDecVars(row) = currentPossibleDecVars;
        algorithm{row} = currentAlgorithms;

        %% HV

        % Mean HV
        rawHV = table_for_conifg.hv;
        currentMeanHV = mean(rawHV);

        hvAvg(row) = currentMeanHV;

        [lowerCI, upperCI] = calcCIs(rawHV);

        hvLower95(row) = min(lowerCI);
        hvUpper95(row) = max(upperCI);

        %% Run times
        rawRuntime =  table_for_conifg.runTimes;
        currentRunTimeAvg = mean(rawRuntime);

        runTimeAvg(row) = currentRunTimeAvg;

        [lowerCI, upperCI] = calcCIs(rawRuntime);

        runTimeLower95(row) = lowerCI;
        runTimeUpper95(row) = upperCI;

        %% Number of non-dominated members
        rawNoNomDoms = table_for_conifg.numNonDom;
        currentNoNomDomsMean = mean(rawNoNomDoms);

        numNonDomAvg(row) = currentNoNomDomsMean;

        [lowerCI, upperCI]= calcCIs(rawNoNomDoms);
        numNonDomLower95(row) = lowerCI;
        numNonDomUpper95(row) = upperCI;

        %% Prep for next iteration
        row = row + 1; 

    end
end


testProbSummaryTable = table(numDecVars, algorithm, hvAvg, hvLower95, hvUpper95, runTimeAvg, runTimeLower95, runTimeUpper95, numNonDomAvg, numNonDomLower95, numNonDomUpper95);


function [lowerCI, upperCI] = calcCIs(data)
    stdErr = std(data)/sqrt(length(data));
    ts = tinv([0.025  0.975],length(data)-1);
    CI  = mean(data) + ts*stdErr;
    
    lowerCI = min(CI);
    upperCI = max(CI); 
end
