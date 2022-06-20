%% Setup 
clear

addpath("configs");
addpath("utilities");
addpath("plotting");

%% Run setup 
plotting_on = false;
print_latex_table = true;
print_pval_latex_table = false;

% Analysis metrics
metrics = {'HV', 'time', 'nds'};



%% Uncomment for comparative decision variable runs
output_files = { ...
    'Z:\Gilgamesh\kroppian\sNSGAIIRuns\finalVersions\sNSGAIIComparative_compDecVar_SMOP1.mat', ...
    'Z:\Gilgamesh\kroppian\sNSGAIIRuns\finalVersions\sNSGAIIComparative_compDecVar_SMOP2.mat', ...
    'Z:\Gilgamesh\kroppian\sNSGAIIRuns\finalVersions\sNSGAIIComparative_compDecVar_SMOP3.mat', ...
    'Z:\Gilgamesh\kroppian\sNSGAIIRuns\finalVersions\sNSGAIIComparative_compDecVar_SMOP4.mat', ...
    'Z:\Gilgamesh\kroppian\sNSGAIIRuns\finalVersions\sNSGAIIComparative_compDecVar_SMOP5.mat', ...
    'Z:\Gilgamesh\kroppian\sNSGAIIRuns\finalVersions\sNSGAIIComparative_compDecVar_SMOP6.mat', ...
    'Z:\Gilgamesh\kroppian\sNSGAIIRuns\finalVersions\sNSGAIIComparative_compDecVar_SMOP7.mat', ...
    'Z:\Gilgamesh\kroppian\sNSGAIIRuns\finalVersions\sNSGAIIComparative_compDecVar_SMOP8.mat'  ...
    };

testProblemsUsed = { ...
    'SMOP1', ...
    'SMOP2', ...
    'SMOP3', ...
    'SMOP4', ...
    'SMOP5', ...
    'SMOP6', ...
    'SMOP7', ...
    'SMOP8'  ... 
    };


baseMethods = {'SparseEA', 'SparseEA2', 'MOEAPSL', 'MPMMEA', 'PMMOEA'};
proposedMethod = 'sNSGAII-VariedStripedSparseSampler_v3-sparsePolyMutate-cropover_v2';
include_dep_var = true;
include_test_prob = true;
include_hv = true;
include_runTime = true;
include_nds = true;
include_backslash = true;
usesDecVar = true;
sNSGA_comparative_decVar_realworld;

% compile into a single table

% load first table to start things off
disp('Loading tables...');

load(output_files{1});
resultsTable = res_final;

test_prob = cell(size(res_final,1), 1);
[test_prob{:}] = deal(testProblemsUsed{1});
resultsTable.testProbs = test_prob;

% concatenate the rest of the files
for t = 2:numel(output_files)
    load(output_files{t});

    % add test problem
    test_prob = cell(size(res_final,1), 1);
    [test_prob{:}] = deal(testProblemsUsed{t});
    res_final.testProbs = test_prob;

    % concatenate on master list
    resultsTable = [resultsTable; res_final];

end
disp('Done.');

% end -- comparative decision variable runs

%% Uncomment for effective decision variable runs
% load('effective_decVar_resultsTable.mat')
% baseMethods = {'MOEADDE'};      % Toggle between the different algorithms
% proposedMethod = 'MOEADDE-SPS'; % on this line 
% include_dep_var = false;
% include_test_prob = false;
% include_hv = true;
% include_runTime = false;
% include_nds = true;
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
% include_nds = true;
% include_backslash = true;
% usesDecVar = false;
% end -- effective sparsity runs


%% Result set up
% Choose the HV you want to use for the analysis

numbaseMeths = numel(baseMethods);
numTestProbs = numel(testProblemsUsed);
if usesDecVar
    numDependentVar  = numel(config.Dz);
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
median_HV_base = ones(numRows, 1)*-1;
median_HV_prop = ones(numRows, 1)*-1;
sig_HV = ones(numRows, 1)*-1;
pval_HV = ones(numRows, 1)*-1;
median_time_base = ones(numRows, 1)*-1;
median_time_prop = ones(numRows, 1)*-1;
sig_time = ones(numRows, 1)*-1;
pval_time = ones(numRows, 1)*-1;
median_nds_base = ones(numRows, 1)*-1;
median_nds_prop = ones(numRows, 1)*-1;
sig_nds = ones(numRows, 1);
pval_time = ones(numRows, 1);

if usesDecVar
    sigTable = table(numDecVars, baseMethod, testProb,  ... 
        median_HV_prop, median_HV_base, sig_HV, pval_HV, ...
        median_time_prop, median_time_base, sig_time, pval_time, ...
        median_nds_prop, median_nds_base, sig_nds, pval_time);
else
    sigTable = table(sparsities, baseMethod, testProb,  ... 
        median_HV_prop, median_HV_base, sig_HV, pval_HV, ...
        median_time_prop, median_time_base, sig_time, pval_time, ...
        median_nds_prop, median_nds_base, sig_nds, pval_time);    
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
                    current_dep_var = config.Dz(d);
                    sigTable.numDecVars(row) = current_dep_var;
                    dep_var_mask = resultsTable.D == current_dep_var;
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
                method_mask = strcmp(resultsTable.alg, proposedMethod);
                mask = method_mask & test_prob_mask & dep_var_mask;
                propMethRaw = resultsTable.(metric);
                propMethRaw = propMethRaw(mask,:);

                % Retrieve the data for the base method 
                method_mask = strcmp(resultsTable.alg, currentBaseMethod);
                mask = method_mask & test_prob_mask & dep_var_mask;
                baseMethRaw = resultsTable.(metric);
                baseMethRaw = baseMethRaw(mask,:);

                alpha = 0.025; 
                if numel(baseMethRaw) == 0
                    pVal = -99; 
                else
                    pVal = ranksum(propMethRaw, baseMethRaw); % test_prob_i == 3 && m_metric == 3
                end
                
                % Value is sometimes nan if the population is identical 
                % I think this is a bug
                if isnan(pVal)
                    pVal = 1;
                end

                difference = alpha >= pVal;  
                
                % If there's a population difference, test whether it's
                % better or worse
                if difference
                    if numel(propMethRaw) == 0 || mean(baseMethRaw) > mean(propMethRaw)
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

                if numel(baseMethRaw) == 0
                    sigTable.(strcat('median_', metric,'_base'))(row) = -99;
                else
                    sigTable.(strcat('median_', metric,'_base'))(row) = median(baseMethRaw);
                end
    
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

%% Print median results in LaTeX
if print_latex_table
    disp("*********************************************************");


    %                      ROW
    % Each row is a DECISION VARIABLE and a TEST PROBLEM
    for d = 1:numDependentVar

        numDecVars = config.Dz(d);


        for test_prob_i = 1:numTestProbs

            currentTestProb = testProblemsUsed{test_prob_i};

            fprintf("%d & %s & ", numDecVars, currentTestProb);

            %                      COL
            % Each column is a BASE METHOD and a METRIC
    
            % For every base method
            for m_baseMethods = 1:numel(baseMethods)

                currentBaseMethod = baseMethods{m_baseMethods};
    
                row_mask = sigTable.numDecVars == numDecVars & ...
                           strcmp(sigTable.testProb, currentTestProb) & ...
                           strcmp(sigTable.baseMethod, currentBaseMethod);
                    
                % HV      
                if include_hv 
                    fprintf("%.2f(%.2f)%s & ", round(sigTable(row_mask,:).median_HV_prop,  2), ...
                            round(sigTable(row_mask,:).median_HV_base, 2), ...
                            sig_number_2_char(sigTable(row_mask,:).sig_HV));
                end


                % Run times
                if include_runTime 
                    fprintf("%.2f(%.2f)%s & ", round(sigTable(row_mask,:).median_time_prop, 2), ...
                               round(sigTable(row_mask,:).median_time_base, 2), ...
                               sig_number_2_char_opp(sigTable(row_mask,:).sig_time));
                end
        
                % NDS
                if include_nds
                    fprintf("%d(%d)%s & ", sigTable(row_mask,:).median_nds_prop, ...
                         round(sigTable(row_mask,:).median_nds_base), ...
                         sig_number_2_char(sigTable(row_mask,:).sig_nds));
                end



            end

            if include_backslash
                fprintf(" \\\\\n"); 
            else
                fprintf(" \n"); 
            end

        end
   

    end

end

%% Print out pvals in LaTeX
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
            if sigTable(row,:).pval_HV == 1
                fprintf("%d%s & ", sigTable(row,:).pval_HV, ...
                    sig_number_2_char_opp(sigTable(row,:).sig_HV));
            else
                fprintf("%1.3e%s & ", sigTable(row,:).pval_HV, ...
                    sig_number_2_char(sigTable(row,:).sig_HV));
            end

        end

        
        % Run times
        if include_runTime
            if sigTable(row,:).pval_time == 1
                fprintf("%d%s & ", sigTable(row,:).pval_time, ...
                    sig_number_2_char_opp(sigTable(row,:).sig_time));
            else
                fprintf("%1.3e%s & ", sigTable(row,:).pval_time, ...
                    sig_number_2_char_opp(sigTable(row,:).sig_time));
            end

        end


        if include_nds
            if sigTable(row,:).pval_nds == 1
                fprintf("%d%s", sigTable(row,:).pval_nds, ...
                    sig_number_2_char(sigTable(row,:).sig_nds));                  
            else
                fprintf("%1.3e%s", sigTable(row,:).pval_nds, ...
                    sig_number_2_char(sigTable(row,:).sig_nds));                
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


