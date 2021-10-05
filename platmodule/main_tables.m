clear;

%% Comparative runs parameters for # of decision variables 
%  (uncomment/comment to use/not use)
algorithmsUsed = {'SparseEA', 'NSGAII-SPS'};
load('/Volumes/data/Gilgamesh/kroppian/spsRuns/2021-10-04/runResults_comparative_decVar_SMOP1.mat');
decVarsUsed = [100, 500, 1000, 2500, 5000, 7500];


fileNames = {'/Volumes/data/Gilgamesh/kroppian/spsRuns/2021-10-04/runResults_comparative_decVar_SMOP1.mat', ... 
             '/Volumes/data/Gilgamesh/kroppian/spsRuns/2021-10-04/runResults_comparative_decVar_SMOP2.mat', ... 
             '/Volumes/data/Gilgamesh/kroppian/spsRuns/2021-10-04/runResults_comparative_decVar_SMOP3.mat', ...
             '/Volumes/data/Gilgamesh/kroppian/spsRuns/2021-10-04/runResults_comparative_decVar_SMOP4.mat', ...
             '/Volumes/data/Gilgamesh/kroppian/spsRuns/2021-10-04/runResults_comparative_decVar_SMOP5.mat', ...
             '/Volumes/data/Gilgamesh/kroppian/spsRuns/2021-10-04/runResults_comparative_decVar_SMOP6.mat', ...
             '/Volumes/data/Gilgamesh/kroppian/spsRuns/2021-10-04/runResults_comparative_decVar_SMOP7.mat', ...
             '/Volumes/data/Gilgamesh/kroppian/spsRuns/2021-10-04/runResults_comparative_decVar_SMOP8.mat'};


label = "comparative";
% Set to true if the run is on decision variables. False for sparsrity 
usesDecVar = true;

%% Effective run parameters for # of decision variables (uncomment/comment to use/not use)
% algorithmsUsed = {'MOPSO', 'MOPSO-SPS', 'MOEADDE', 'MOEADDE-SPS', 'NSGAII', 'NSGAII-SPS'};
% decVarsUsed = [100, 500, 1000, 2500, 5000, 7500];
% fileNames = {'data/runResults_effective_decVar_SMOP1.mat', 'data/runResults_effective_decVar_SMOP2.mat', ...
%  'data/runResults_effective_decVar_SMOP3.mat', 'data/runResults_effective_decVar_SMOP4.mat', ...
%  'data/runResults_effective_decVar_SMOP5.mat', 'data/runResults_effective_decVar_SMOP6.mat', ...
%  'data/runResults_effective_decVar_SMOP7.mat', 'data/runResults_effective_decVar_SMOP8.mat'};
% usesDecVar = true;
% 
% load(fileNames{1});
% label = "effective";

%% Effective run parameters for sparsity (uncomment/comment to use/not use)
% algorithmsUsed = {'MOPSO', 'MOPSO-SPS', 'MOEADDE', 'MOEADDE-SPS', 'NSGAII', 'NSGAII-SPS'};
% sparsitiesUsed = (1-linspace(0.05, 0.45,9))*100;
% fileNames = {'data/runResults_effective_sparsity_SMOP1.mat', 'data/runResults_effective_sparsity_SMOP2.mat', ...
%  'data/runResults_effective_sparsity_SMOP3.mat', 'data/runResults_effective_sparsity_SMOP4.mat', ...
%  'data/runResults_effective_sparsity_SMOP5.mat', 'data/runResults_effective_sparsity_SMOP6.mat', ...
%  'data/runResults_effective_sparsity_SMOP7.mat', 'data/runResults_effective_sparsity_SMOP8.mat'};
% 
% load(fileNames{1});
% label = "effective";
% % Set to true if the run is on decision variables. False for sparsrity 
% usesDecVar = false;

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
hv1 = ones(numRows,1)*-1;
hv2 = ones(numRows,1)*-1;
hv3 = ones(numRows,1)*-1;
hv4 = ones(numRows,1)*-1;
hv5 = ones(numRows,1)*-1;
hv6 = ones(numRows,1)*-1;
hv7 = ones(numRows,1)*-1;

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
                hv_ref = 1; 
                hv_set = HVResults(r,d,a);
                hv = arrayfun(@(x)(x{1}(hv_ref)), hv_set, 'UniformOutput', false);
                hv = arrayfun(@(x)(x{1}), hv);
                hv1(row) = hv;
                
                hv_ref = 2; 
                hv_set = HVResults(r,d,a);
                hv = arrayfun(@(x)(x{1}(hv_ref)), hv_set, 'UniformOutput', false);
                hv = arrayfun(@(x)(x{1}), hv);
                hv2(row) = hv;

                hv_ref = 3; 
                hv_set = HVResults(r,d,a);
                hv = arrayfun(@(x)(x{1}(hv_ref)), hv_set, 'UniformOutput', false);
                hv = arrayfun(@(x)(x{1}), hv);
                hv3(row) = hv;

                hv_ref = 4; 
                hv_set = HVResults(r,d,a);
                hv = arrayfun(@(x)(x{1}(hv_ref)), hv_set, 'UniformOutput', false);
                hv = arrayfun(@(x)(x{1}), hv);
                hv4(row) = hv;
                
                hv_ref = 5; 
                hv_set = HVResults(r,d,a);
                hv = arrayfun(@(x)(x{1}(hv_ref)), hv_set, 'UniformOutput', false);
                hv = arrayfun(@(x)(x{1}), hv);
                hv5(row) = hv;
                
                hv_ref = 6; 
                hv_set = HVResults(r,d,a);
                hv = arrayfun(@(x)(x{1}(hv_ref)), hv_set, 'UniformOutput', false);
                hv = arrayfun(@(x)(x{1}), hv);
                hv6(row) = hv;
                
                
                hv_ref = 7; 
                hv_set = HVResults(r,d,a);
                hv = arrayfun(@(x)(x{1}(hv_ref)), hv_set, 'UniformOutput', false);
                hv = arrayfun(@(x)(x{1}), hv);
                hv7(row) = hv;
                
                
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
    resultsTable = table(numDecVars, algorithm, testProbs, repetition, hv1, hv2, hv3, hv3, hv4, hv5, hv6, hv7, runTimes, numNonDom);
    filename = strcat(label, '_decVar_resultsTable.mat');
    save(filename, 'resultsTable', 'algorithmsUsed', 'testProblemsUsed', 'decVarsUsed');
else
    resultsTable = table(sparsities, algorithm, testProbs, repetition, hv1, hv2, hv3, hv3, hv4, hv5, hv6, hv7, runTimes, numNonDom);
    filename = strcat(label, '_sparsity_resultsTable.mat');
    save(filename, 'resultsTable', 'algorithmsUsed', 'testProblemsUsed', 'sparsitiesUsed');
end





