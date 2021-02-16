%% Setup 
clear

load('comparative_resultsTable.mat')


%% Run setup 

% Analysis metrics
metrics = {'hv', 'numNonDom', 'runTimes'};
baseMethods = {'SparseEA'};
proposedMethod = 'NSGAII-SPS';

% Result set up

numDecVar    = numel(decVarsUsed);
numbaseMeths = numel(baseMethods);
numTestProbs = numel(testProblemsUsed);
numRows = numDecVar*numbaseMeths*numTestProbs;

numDecVars = ones(numRows, 1)*-1;
testProb = cell(numRows, 1);
baseMethod = cell(numRows, 1);
sig_hv = ones(numRows, 1)*-1;
sig_runTimes = ones(numRows, 1)*-1;
sig_numNonDom = ones(numRows, 1);


sigTable = table(numDecVars, baseMethod, testProb, sig_hv, sig_runTimes, sig_numNonDom);

disp('************');

plot_no = 1;

row = 1;
%% Iterate through every decision variable, test prob, and performance metric


% For every metric
for m_metric = 1:numel(metrics)

    for d = 1:numel(decVarsUsed)

        % For every base method
        for m_baseMethods = 1:numel(baseMethods)

            % For every test problem
            for test_prob_i = 1:numTestProbs


                currentBaseMethod = baseMethods{m_baseMethods};
                currentTestProb = testProblemsUsed{test_prob_i};
                currentDecVars = decVarsUsed(d);

                sigTable.numDecVars(row) = currentDecVars;
                sigTable.baseMethod{row} = currentBaseMethod;
                sigTable.testProb{row} = currentTestProb;

                test_prob_mask = strcmp(resultsTable.testProbs, currentTestProb);
                dec_var_mask = resultsTable.numDecVars == currentDecVars;

                %% Perform significance testing
                metric = metrics{m_metric};

                % Retrieve the data for the proposed method
                method_mask = strcmp(resultsTable.algorithm, proposedMethod);
                mask = method_mask & test_prob_mask & dec_var_mask;
                propMethRaw = resultsTable.(metric);
                propMethRaw = propMethRaw(mask,:);

                % Retrieve the data for the base method 
                method_mask = strcmp(resultsTable.algorithm, currentBaseMethod);
                mask = method_mask & test_prob_mask & dec_var_mask;
                baseMethRaw = resultsTable.(metric);
                baseMethRaw = baseMethRaw(mask,:);

                alpha = 0.05;
                pVal = ranksum(propMethRaw, baseMethRaw);

                % Record outcome
                sigTable.(strcat('sig_',metric))(row) = alpha >= pVal;

                %% Plot outcome

                %% Move on to next row, or go back to the beginning
                
                if (row + 1) > numRows
                    row = 1;
                else
                    row = row + 1;
                end
                
            end


        end % End - every metric

    end % Decision var

end
