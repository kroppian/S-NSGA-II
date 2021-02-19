%% Setup 
clear



%% Run setup 

plotting_on = false;
print_latex_table = true;

% Analysis metrics
metrics = {'hv', 'numNonDom', 'runTimes'};

% Uncomment for comparative decision variable runs
% load('comparative_resultsTable.mat')
% baseMethods = {'SparseEA'};
% proposedMethod = 'NSGAII-SPS';
% include_hv = true;
% include_runTime = true;
% include_numNonDom = true;
% end -- comparative decision variable runs

% Uncomment for effective decision variable runs
load('effective_resultsTable.mat')
baseMethods = {'MOEADDE'};
proposedMethod = 'MOEADDE-SPS';
include_dec_vars = false;
include_test_prob = false;
include_hv = true;
include_runTime = false;
include_numNonDom = true;
include_backslash = true;
% end -- effective decision variable runs



% Result set up

numDecVar    = numel(decVarsUsed);
numbaseMeths = numel(baseMethods);
numTestProbs = numel(testProblemsUsed);
numRows = numDecVar*numbaseMeths*numTestProbs;

% Allocate space for the data
numDecVars = ones(numRows, 1)*-1;
testProb = cell(numRows, 1);
baseMethod = cell(numRows, 1);
median_hv_base = ones(numRows, 1)*-1;
median_hv_prop = ones(numRows, 1)*-1;
sig_hv = ones(numRows, 1)*-1;
median_runTimes_base = ones(numRows, 1)*-1;
median_runTimes_prop = ones(numRows, 1)*-1;
sig_runTimes = ones(numRows, 1)*-1;
median_numNonDom_base = ones(numRows, 1)*-1;
median_numNonDom_prop = ones(numRows, 1)*-1;
sig_numNonDom = ones(numRows, 1);


sigTable = table(numDecVars, baseMethod, testProb,  ... 
    median_hv_prop, median_hv_base, sig_hv, ...
    median_runTimes_prop, median_runTimes_base, sig_runTimes, ...
    median_numNonDom_prop, median_numNonDom_base, sig_numNonDom);

plot_no = 1;

row = 1;
%% Iterate through every decision variable, test prob, and performance metric


% For every metric
for m_metric = 1:numel(metrics)

    if plotting_on 
        figure 
    end
    
    metric = metrics{m_metric};
    
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

                alpha = 0.025;
                pVal = ranksum(propMethRaw, baseMethRaw);
                
                
                if isnan(pVal)
                    difference = false;
                else
                    difference = alpha >= pVal;                
                end
                % If there's a population difference, test whether it's
                % better or worse
                if difference
                    if median(baseMethRaw) > median(propMethRaw)
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
                
                sigTable.(strcat('median_', metric,'_base'))(row) = median(baseMethRaw);
                sigTable.(strcat('median_', metric,'_prop'))(row) = median(propMethRaw);
                
                %% Plot outcome
                if plotting_on
                    subplot(numDecVar, numTestProbs, row);
                    boxplot([baseMethRaw, propMethRaw])
                    title(strcat('D.V.=', num2str(currentDecVars), ' and ', currentTestProb));
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
    for row = 1:numRows
        % decision variables
        if include_dec_vars
            fprintf("%d & ", sigTable(row,:).numDecVars);  
        end
        % test problem
        if include_test_prob
            fprintf("%s & ", sigTable(row,:).testProb{1});  
        end


        % HV      
        if include_hv 
            fprintf("%.4f(%.4f)%s & ", sigTable(row,:).median_hv_prop, ...
                    sigTable(row,:).median_hv_base, ...
                    sig_number_2_char(sigTable(row,:).sig_hv));
        end

        
        % Run times
        if include_runTime
            fprintf("%.4f(%.4f)%s & ", sigTable(row,:).median_runTimes_prop, ...
                       sigTable(row,:).median_runTimes_base, ...
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


