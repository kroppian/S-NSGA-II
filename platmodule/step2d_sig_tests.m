%% Setup 
clear

%% Run setup 
plotting_on = false;
print_latex_table = false;
print_pval_latex_table = true;

% Analysis metrics
metrics = {'hv2', 'runTimes', 'numNonDom'};

%% Uncomment for comparative decision variable runs
load('/Volumes/data/Gilgamesh/kroppian/spsRuns/2021-10-04/comparative_decVar_resultsTable.mat')
baseMethods = {'SparseEA'};
proposedMethod = 'NSGAII-SPS';
include_dep_var = true;
include_test_prob = true;
include_hv = true;
include_runTime = true;
include_numNonDom = true;
include_backslash = true;
usesDecVar = true;
% end -- comparative decision variable runs

%% Uncomment for effective decision variable runs
% load('effective_decVar_resultsTable.mat')
% baseMethods = {'MOEADDE'};      % Toggle between the different algorithms
% proposedMethod = 'MOEADDE-SPS'; % on this line 
% include_dep_var = false;
% include_test_prob = false;
% include_hv = true;
% include_runTime = false;
% include_numNonDom = true;
% include_backslash = false;
% usesDecVar = true;
% end -- effective decision variable runs

%% Uncomment for effective sparsity runs
% load('effective_sparsity_resultsTable.mat')
% baseMethods = {'MOEADDE'};
% proposedMethod = 'MOEADDE-SPS';
% include_dep_var = false;
% include_test_prob = false;
% include_hv = true;
% include_runTime = false;
% include_numNonDom = true;
% include_backslash = true;
% usesDecVar = false;
% end -- effective sparsity runs


% Result set up
numbaseMeths = numel(baseMethods);
numTestProbs = numel(testProblemsUsed);
if usesDecVar
    numDependentVar  = numel(decVarsUsed);
else
    numDependentVar = numel(sparsitiesUsed);
end
    
numRows = numDependentVar*numbaseMeths*numTestProbs;


% Allocate space for the data
if usesDecVar
    numDecVars = ones(numRows, 1)*-1;
else
    sparsities = ones(numRows, 1)*-1;
end

testProb = cell(numRows, 1);
baseMethod = cell(numRows, 1);
median_hv_base = ones(numRows, 1)*-1;
median_hv_prop = ones(numRows, 1)*-1;
sig_hv = ones(numRows, 1)*-1;
pval_hv = ones(numRows, 1)*-1;
median_runTimes_base = ones(numRows, 1)*-1;
median_runTimes_prop = ones(numRows, 1)*-1;
sig_runTimes = ones(numRows, 1)*-1;
pval_runTimes = ones(numRows, 1)*-1;
median_numNonDom_base = ones(numRows, 1)*-1;
median_numNonDom_prop = ones(numRows, 1)*-1;
sig_numNonDom = ones(numRows, 1);
pval_runTimes = ones(numRows, 1);

if usesDecVar
    sigTable = table(numDecVars, baseMethod, testProb,  ... 
        median_hv_prop, median_hv_base, sig_hv, pval_hv, ...
        median_runTimes_prop, median_runTimes_base, sig_runTimes, pval_runTimes, ...
        median_numNonDom_prop, median_numNonDom_base, sig_numNonDom, pval_runTimes);
else
    sigTable = table(sparsities, baseMethod, testProb,  ... 
        median_hv_prop, median_hv_base, sig_hv, pval_hv, ...
        median_runTimes_prop, median_runTimes_base, sig_runTimes, pval_runTimes, ...
        median_numNonDom_prop, median_numNonDom_base, sig_numNonDom, pval_runTimes);    
end
    
    
plot_no = 1;

row = 1;
%% Iterate through every decision variable, test prob, and performance metric

% For every metric
for m_metric = 1:numel(metrics)

    if plotting_on 
        figure 
    end
    
    metric = metrics{m_metric};
    
    for d = 1:numDependentVar

        % For every base method
        for m_baseMethods = 1:numel(baseMethods)

            % For every test problem
            for test_prob_i = 1:numTestProbs

                currentBaseMethod = baseMethods{m_baseMethods};
                currentTestProb = testProblemsUsed{test_prob_i};
                
                if usesDecVar
                    current_dep_var = decVarsUsed(d);
                    sigTable.numDecVars(row) = current_dep_var;
                    dep_var_mask = resultsTable.numDecVars == current_dep_var;
                else
                    current_dep_var = sparsitiesUsed(d);
                    sigTable.sparsities(row) = current_dep_var;
                    dep_var_mask = resultsTable.sparsities == current_dep_var;
                end

                sigTable.baseMethod{row} = currentBaseMethod;
                sigTable.testProb{row} = currentTestProb;

                test_prob_mask = strcmp(resultsTable.testProbs, currentTestProb);

                %% Perform significance testing


                % Retrieve the data for the proposed method
                method_mask = strcmp(resultsTable.algorithm, proposedMethod);
                mask = method_mask & test_prob_mask & dep_var_mask;
                propMethRaw = resultsTable.(metric);
                propMethRaw = propMethRaw(mask,:);

                % Retrieve the data for the base method 
                method_mask = strcmp(resultsTable.algorithm, currentBaseMethod);
                mask = method_mask & test_prob_mask & dep_var_mask;
                baseMethRaw = resultsTable.(metric);
                baseMethRaw = baseMethRaw(mask,:);

                alpha = 0.025; % test_prob_i == 3 && strcmp(metric, 'numNonDom')
                pVal = ranksum(propMethRaw, baseMethRaw); % test_prob_i == 3 && m_metric == 3
                
                % Value is sometimes nan if the population is identical 
                % I think this is a bug
                if isnan(pVal)
                    pVal = 1;
                end

                difference = alpha >= pVal;  
                
                % If there's a population difference, test whether it's
                % better or worse
                if difference
                    if mean(baseMethRaw) > mean(propMethRaw)
                        result = -1;
                    else
                        result = 1;
                    end
                        
                else
                    result = 0;
                end
                
                %% Record outcome
                
                % Record whether or not there was a significant difference
                sigTable.(strcat('sig_',metric))(row) = result;
                sigTable.(strcat('pval_',metric))(row) = pVal;

                
                sigTable.(strcat('median_', metric,'_base'))(row) = median(baseMethRaw);
                sigTable.(strcat('median_', metric,'_prop'))(row) = median(propMethRaw);
                
                %% Plot outcome
                if plotting_on
                    subplot(numDecVar, numTestProbs, row);
                    boxplot([baseMethRaw, propMethRaw])
                    title(strcat('D.V.=', num2str(current_dep_var), ' and ', currentTestProb));
                end

                %% Move on to next row, or go back to the beginning of next row
                if (row + 1) > numRows
                    row = 1;
                else
                    row = row + 1;
                end
                
            end


        end % End

    end % Decision var

    if plotting_on
        sgtitle(strcat(metric,' for SparseEA vs NSGA-II with SPS'))
    end
  
end % End - for every metric


if print_latex_table
    disp("*********************************************************");
    for row = 1:numRows
        % decision variables
        if include_dep_var
            if usesDecVar
                fprintf("%d & ", sigTable(row,:).numDecVars);  
            else
                fprintf("%d & ", sigTable(row,:).sparsities);  
            end
        end
        
        % test problem
        if include_test_prob
            fprintf("%s & ", sigTable(row,:).testProb{1});  
        end
        
        % HV      
        if include_hv 
            fprintf("%.2f(%.2f)%s & ", round(sigTable(row,:).median_hv_prop,  2), ...
                    round(sigTable(row,:).median_hv_base, 2), ...
                    sig_number_2_char(sigTable(row,:).sig_hv));
        end
        
        % Run times
        if include_runTime
            fprintf("%.2f(%.2f)%s & ", round(sigTable(row,:).median_runTimes_prop, 2), ...
                       round(sigTable(row,:).median_runTimes_base, 2), ...
                       sig_number_2_char_opp(sigTable(row,:).sig_runTimes));
        end

        if include_numNonDom
            fprintf("%d(%d)%s", sigTable(row,:).median_numNonDom_prop, ...
                 round(sigTable(row,:).median_numNonDom_base), ...
                 sig_number_2_char(sigTable(row,:).sig_numNonDom));
        end
        % Number of non-dominated points 
        
                        
        if include_backslash
            fprintf(" \\\\\n"); 
        else
            fprintf(" \n"); 
        end
        
    end
end

if print_pval_latex_table 
    disp("*********************************************************");
    for row = 1:numRows
        % decision variables
        if include_dep_var
            if usesDecVar
                fprintf("%d & ", sigTable(row,:).numDecVars);  
            else
                fprintf("%d & ", sigTable(row,:).sparsities);  
            end
        end
        % test problem
        if include_test_prob
            fprintf("%s & ", sigTable(row,:).testProb{1});  
        end

                
        % HV      
        if include_hv 
            if sigTable(row,:).pval_hv == 1
                fprintf("%d%s & ", sigTable(row,:).pval_hv, ...
                    sig_number_2_char_opp(sigTable(row,:).sig_hv));
            else
                fprintf("%1.3e%s & ", sigTable(row,:).pval_hv, ...
                    sig_number_2_char(sigTable(row,:).sig_hv));
            end

        end

        
        % Run times
        if include_runTime
            if sigTable(row,:).pval_runTimes == 1
                fprintf("%d%s & ", sigTable(row,:).pval_runTimes, ...
                    sig_number_2_char_opp(sigTable(row,:).sig_runTimes));
            else
                fprintf("%1.3e%s & ", sigTable(row,:).pval_runTimes, ...
                    sig_number_2_char_opp(sigTable(row,:).sig_runTimes));
            end

        end


        if include_numNonDom
            if sigTable(row,:).pval_numNonDom == 1
                fprintf("%d%s", sigTable(row,:).pval_numNonDom, ...
                    sig_number_2_char(sigTable(row,:).sig_numNonDom));                  
            else
                fprintf("%1.3e%s", sigTable(row,:).pval_numNonDom, ...
                    sig_number_2_char(sigTable(row,:).sig_numNonDom));                
            end
        end
        % Number of non-dominated points 

                        
        if include_backslash
            fprintf(" \\\\\n"); 
        else
            fprintf(" \n"); 
        end
        
    end
end

function new_character = sig_number_2_char(sig_num)
    if sig_num == -1 
        new_character = '$^-$';
    elseif sig_num == 1
        new_character = '$^+$'; 
    else
        new_character = '$^\approx$';
    end
end


function new_character = sig_number_2_char_opp(sig_num)
    if sig_num == 1 
        new_character = '$^-$';
    elseif sig_num == -1
        new_character = '$^+$'; 
    else
        new_character = '$^\approx$';
    end
end


