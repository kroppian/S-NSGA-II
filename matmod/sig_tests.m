%% Setup 
clear

addpath("configs");
addpath("utilities");
addpath("plotting");
%sNSGA_comparative
%sNSGA_comparative_decVar_sparseNN
%sNSGA_comparative_decVar_sparsePO
sNSGA_comparative_decVar_sparseSR


%% Run setup 
plotting_on = false;
print_latex_table = true;
print_pval_latex_table = false;

% Analysis metrics
metrics = {'HV', 'time'};



%% Uncomment for comparative decision variable runs
% output_files = { ...
%     'C:\Users\i-kropp\Projects\cropover\matmod\data\comparative_SMOP1.mat', ...
%     'C:\Users\i-kropp\Projects\cropover\matmod\data\comparative_SMOP2.mat', ...
%     'C:\Users\i-kropp\Projects\cropover\matmod\data\comparative_SMOP3.mat', ...
%     'C:\Users\i-kropp\Projects\cropover\matmod\data\comparative_SMOP4.mat', ...
%     'C:\Users\i-kropp\Projects\cropover\matmod\data\comparative_SMOP5.mat', ...
%     'C:\Users\i-kropp\Projects\cropover\matmod\data\comparative_SMOP6.mat', ...
%     'C:\Users\i-kropp\Projects\cropover\matmod\data\comparative_SMOP7.mat', ...
%     'C:\Users\i-kropp\Projects\cropover\matmod\data\comparative_SMOP8.mat'  ...
%     };
% 
% testProblemsUsed = { ...
%     'SMOP1', ...
%     'SMOP2', ...
%     'SMOP3', ...
%     'SMOP4', ...
%     'SMOP5', ...
%     'SMOP6', ...
%     'SMOP7', ...
%     'SMOP8'  ... 
%     };

%% uncomment for time trial runs
% output_files = { ...
%     'C:\Users\i-kropp\Projects\cropover\matmod\data\time_trial_SMOP1.mat', ...
%     'C:\Users\i-kropp\Projects\cropover\matmod\data\time_trial_SMOP2.mat', ...
%     'C:\Users\i-kropp\Projects\cropover\matmod\data\time_trial_SMOP3.mat', ...
%     'C:\Users\i-kropp\Projects\cropover\matmod\data\time_trial_SMOP4.mat', ...
%     'C:\Users\i-kropp\Projects\cropover\matmod\data\time_trial_SMOP5.mat', ...
%     'C:\Users\i-kropp\Projects\cropover\matmod\data\time_trial_SMOP6.mat', ...
%     'C:\Users\i-kropp\Projects\cropover\matmod\data\time_trial_SMOP7.mat', ...
%     'C:\Users\i-kropp\Projects\cropover\matmod\data\time_trial_SMOP8.mat'  ...
%     };
% 
% testProblemsUsed = { ...
%     'SMOP1', ...
%     'SMOP2', ...
%     'SMOP3', ...
%     'SMOP4', ...
%     'SMOP5', ...
%     'SMOP6', ...
%     'SMOP7', ...
%     'SMOP8'  ... 
%     };

%% Uncomment for ablation study 
% 
% testProblemsUsed = { ...
%     'SMOP1', ...
%     'SMOP2', ...
%     'SMOP3', ...
%     'SMOP4', ...
%     'SMOP5', ...
%     'SMOP6', ...
%     'SMOP7', ...
%     'SMOP8'  ... 
%     };
% 
% output_files = { ...
%   'C:\Users\i-kropp\Projects\cropover\matmod\data\sNSGAIIAblation_compDecVar_SMOP1_new.mat', ...
%   'C:\Users\i-kropp\Projects\cropover\matmod\data\sNSGAIIAblation_compDecVar_SMOP2_new.mat', ...
%   'C:\Users\i-kropp\Projects\cropover\matmod\data\sNSGAIIAblation_compDecVar_SMOP3_new.mat', ...
%   'C:\Users\i-kropp\Projects\cropover\matmod\data\sNSGAIIAblation_compDecVar_SMOP4_new.mat', ...
%   'C:\Users\i-kropp\Projects\cropover\matmod\data\sNSGAIIAblation_compDecVar_SMOP5_new.mat', ...
%   'C:\Users\i-kropp\Projects\cropover\matmod\data\sNSGAIIAblation_compDecVar_SMOP6_new.mat', ...
%   'C:\Users\i-kropp\Projects\cropover\matmod\data\sNSGAIIAblation_compDecVar_SMOP7_new.mat', ...
%   'C:\Users\i-kropp\Projects\cropover\matmod\data\sNSGAIIAblation_compDecVar_SMOP8_new.mat'  ...
% 
%     };
% 
% baseMethods = {'sNSGAII-VariedStripedSparseSampler_v3-polyMutate-cropover_v2', ... 
%                'sNSGAII-VariedStripedSparseSampler_v3-sparsePolyMutate-sbx', ...
%                'sNSGAII-nop-sparsePolyMutate-cropover_v2'};
% 
% proposedMethod = 'sNSGAII-VariedStripedSparseSampler_v3-sparsePolyMutate-cropover_v2';

%% Uncomment for any of the real-world problems

% output_files = {'C:\Users\i-kropp\Projects\cropover\matmod\data\realworld_NN_1.mat'};
% testProblemsUsed = { 'Sparse_NN_1' };

% output_files = {'C:\Users\i-kropp\Projects\cropover\matmod\data\realworld_NN_2.mat'};
% testProblemsUsed = { 'Sparse_NN_2' };

% output_files = {'C:\Users\i-kropp\Projects\cropover\matmod\data\realworld_NN_3.mat'};
% testProblemsUsed = { 'Sparse_NN_3' };
 
% output_files = {'C:\Users\i-kropp\Projects\cropover\matmod\data\realworld_PO_1.mat'};
% testProblemsUsed = { 'Sparse_PO_1' };

% output_files = {'C:\Users\i-kropp\Projects\cropover\matmod\data\realworld_PO_2.mat'};
% testProblemsUsed = { 'Sparse_PO_2' };

% output_files = {'C:\Users\i-kropp\Projects\cropover\matmod\data\realworld_SR_1.mat'};
% testProblemsUsed = {'Sparse_SR_simple'};
 
output_files = {'C:\Users\i-kropp\Projects\cropover\matmod\data\realworld_SR_2.mat'};
testProblemsUsed = {'Sparse_SR_simple'};

output_files = {'C:\Users\i-kropp\Projects\cropover\matmod\data\realworld_SR_3.mat'};
testProblemsUsed = {'Sparse_SR_simple'};

baseMethods = {'SparseEA', 'SparseEA2', 'MOEAPSL', 'PMMOEA'};
proposedMethod = 'sNSGAII-VariedStripedSparseSampler_v3-sparsePolyMutate-cropover_v2';
%proposedMethod = 'NSGAII';


%% Set up

include_dep_var = true;
include_test_prob = true;


metrics = ["HV", "time"];
%metrics = ["igd"];
%metrics = ["time"];

include_metric = {true, true, true};


include_backslash = true;
usesDecVar = true;

% compile into a single table

% load first table to start things off
disp('Loading tables... ');

fprintf("1...");
load(output_files{1});
resultsTable = res_final;

test_prob = cell(size(res_final,1), 1);
[test_prob{:}] = deal(testProblemsUsed{1});
resultsTable.testProbs = test_prob;

if numel(output_files) >= 2
    % concatenate the rest of the files
    for t = 2:numel(output_files)
        fprintf("%d...", t);

        load(output_files{t});
    
        % add test problem
        test_prob = cell(size(res_final,1), 1);
        [test_prob{:}] = deal(testProblemsUsed{t});
        res_final.testProbs = test_prob;
        
        % concatenate on master list
        resultsTable = [resultsTable; res_final];
    
    end
end

disp('Done.');

% end -- comparative decision variable runs


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
mean_HV_base = ones(numRows, 1)*-1;
mean_HV_prop = ones(numRows, 1)*-1;
sig_HV = ones(numRows, 1)*-1;
pval_HV = ones(numRows, 1)*-1;
median_time_base = ones(numRows, 1)*-1;
median_time_prop = ones(numRows, 1)*-1;
mean_time_base = ones(numRows, 1)*-1;
mean_time_prop = ones(numRows, 1)*-1;
sig_time = ones(numRows, 1)*-1;
pval_time = ones(numRows, 1)*-1;
median_nds_base = ones(numRows, 1)*-1;
median_nds_prop = ones(numRows, 1)*-1;
mean_nds_base = ones(numRows, 1)*-1;
mean_nds_prop = ones(numRows, 1)*-1;
sig_nds = ones(numRows, 1);
pval_time = ones(numRows, 1);

if usesDecVar
    sigTable = table(numDecVars, baseMethod, testProb,  ... 
        median_HV_prop, median_HV_base, sig_HV, pval_HV, ...
        mean_HV_prop, mean_HV_base, ...
        median_time_prop, median_time_base, sig_time, pval_time, ...
        mean_time_prop, mean_time_base,  ...
        median_nds_prop, median_nds_base, ...
        mean_nds_prop, mean_nds_base, sig_nds, pval_time);
else
    sigTable = table(sparsities, baseMethod, testProb,  ... 
        median_HV_prop, median_HV_base, sig_HV, pval_HV, ...
        mean_HV_prop, mean_HV_base, ...
        median_time_prop, median_time_base, sig_time, pval_time, ...
        mean_time_prop, mean_time_base,  ...
        median_nds_prop, median_nds_base, ...
        mean_nds_prop, mean_nds_base, sig_nds, pval_time);    
end
    
    
plot_no = 1;

row = 1;
%% Make comparative histograms


if plotting_on
    metric = "time";
    problem = {'SMOP1'};
    D = 6400;
    
    bins = 10;
    totalMethods = numel(baseMethods) + 1;
    
    % Get plot lower and upper bounds
    all_data = resultsTable{:, metric};
    lowerBounds = min(all_data);
    upperBounds = max(all_data);
    
    binWidth = 1;
    
    lowerBounds = double(idivide(int64(lowerBounds), int64(binWidth)) - 1)*binWidth
    upperBounds = double(idivide(int64(upperBounds), int64(binWidth)) + 1)*binWidth
    
    edges = linspace(lowerBounds, upperBounds, ((upperBounds - lowerBounds)/binWidth)+1);
    
    
    % Do the plotting 
    figure;
    subplot(totalMethods, 1, 1);
    
    for m = 1:numel(baseMethods)
        subplot(totalMethods, 1, m)
        baseMethod = baseMethods(m);
    
        rowMask = strcmp(resultsTable.alg, baseMethod) & ...
                  strcmp(resultsTable.testProbs, problem) & ...
                  resultsTable.D == D;
    
    
        simulations = resultsTable{rowMask, metric};
        histogram(simulations, edges);
        title(baseMethod);
    
        xlim([lowerBounds, upperBounds]);
    end
    
    subplot(totalMethods, 1, totalMethods)
    
    rowMask = strcmp(resultsTable.alg, proposedMethod) & ...
              strcmp(resultsTable.testProbs, problem) & ...
              resultsTable.D == D;
    
    
    simulations = resultsTable{rowMask, metric};
    histogram(simulations, edges);
    title(proposedMethod);
    
    xlim([lowerBounds, upperBounds]);
end



%% Iterate through every decision variable, test prob, and performance metric

isSparseNN = strcmp(func2str(config.prob), 'Sparse_NN');
isSparsePO = strcmp(func2str(config.prob), 'Sparse_PO');
isSparseSR = strcmp(func2str(config.prob), 'Sparse_SR_simple');


if isSparseNN || isSparsePO || isSparseSR
    decVars = unique(resultsTable.D)';
else                        
    decVars = config.Dz;
end

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
                    current_dep_var = decVars(d);
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
                    pVal = ranksum(propMethRaw, baseMethRaw);
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

                % Median 
                if numel(baseMethRaw) == 0
                    sigTable.(strcat('median_', metric,'_base'))(row) = -99;
                else
                    sigTable.(strcat('median_', metric,'_base'))(row) = median(baseMethRaw);
                end
    
                sigTable.(strcat('median_', metric,'_prop'))(row) = median(propMethRaw);
              
                % Mean 
                if numel(baseMethRaw) == 0
                    sigTable.(strcat('mean_', metric,'_base'))(row) = -99;
                else
                    sigTable.(strcat('mean_', metric,'_base'))(row) = mean(baseMethRaw);
                end
    
                sigTable.(strcat('mean_', metric,'_prop'))(row) = mean(propMethRaw);

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

%sigTable = summarizeByTest(sigTable);


if print_latex_table
    disp("*********************************************************");

    % To help determine where to put \hline 
    row_counter = 1; 

    %                      ROW
    % Each row is a DECISION VARIABLE and a TEST PROBLEM
    for d = 1:numDependentVar

        numDecVars = decVars(d);

        for test_prob_i = 1:numTestProbs

            currentTestProb = testProblemsUsed{test_prob_i};

            data_set = str2num(currentTestProb(numel(currentTestProb)));

            if isSparseNN
                fprintf("NN & %d & %d & %d & ", data_set, config.Dz(d), numDecVars);
            elseif isSparsePO
                fprintf("PO & %d & --- & %d & ", data_set, numDecVars);
            else
                fprintf("%d & %s & ", numDecVars, currentTestProb);
            end


            %                      COL
            % Each column is a BASE METHOD and a METRIC
    
            row_str = '';

            % For every base method
            for m_baseMethods = 1:numel(baseMethods)

                currentBaseMethod = baseMethods{m_baseMethods};
    
                row_mask = sigTable.numDecVars == numDecVars & ...
                           strcmp(sigTable.testProb, currentTestProb) & ...
                           strcmp(sigTable.baseMethod, currentBaseMethod);
                
                for m_metric = 1:numel(metrics)
                    
                    if include_metric{m_metric}

                        metric = metrics(m_metric);
    
                        proposed = round(sigTable{row_mask,'mean_' + metric + '_prop'},  3);
                        base = round(sigTable{row_mask,'mean_' + metric + '_base'}, 3);
    
                        sig = sigTable{row_mask,"sig_" + metric};
    
                        if base == -99
                            new_str = sprintf("\\cellcolor{better}%.3f(---)$^+$ & ",  proposed);
   
                        else
                            new_str = sprintf("%s%.3f(%.3f)%s & ", sig_number_2_color(sig, metric), proposed, base, ...
                                sig_number_2_char(sig, metric));
                        end
                        row_str = row_str + new_str;
                    end
                end

            end

            row_str = convertStringsToChars(row_str);
            row_str = row_str(1:numel(row_str)-3);
            fprintf("%s", row_str);

            row_counter = row_counter + 1; 
             
            if include_backslash
                fprintf(" \\\\\n"); 
            else
                fprintf(" \n"); 
            end

            if mod(row_counter-1, numel(testProblemsUsed)) == 0 && ~(isSparseNN || isSparsePO)
                fprintf("\\hline\n");
            end

        end
   

    end

end

% Figure out overall performance 

fprintf("\\multicolumn{2}{c}{($+/-/\\approx$)} & " )

row_str = '';

for m_baseMethods = 1:numel(baseMethods)
    
    for m_metric = 1:numel(metrics)
    
        currentBaseMethod = baseMethods{m_baseMethods};
        metric = metrics{m_metric};
        baseMethodMask = strcmp(sigTable.baseMethod, currentBaseMethod);

        sig_vals = sigTable{baseMethodMask, ['sig_', metric]};

        if metric == "time" || metric == "igd"
            better = sum(sig_vals == -1);
            same = sum(sig_vals == 0);
            worse = sum(sig_vals == 1);
        else
            better = sum(sig_vals == 1);
            same = sum(sig_vals == 0);
            worse = sum(sig_vals == -1);
        end

        row_str = row_str + sprintf("$%d/%d/%d$ & ", better, worse, same);
    

    end
end

row_str = convertStringsToChars(row_str);
row_str = row_str(1:numel(row_str)-3);
fprintf("%s \\\\\n", row_str);


fprintf("\\hline\n");


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

function new_character = sig_number_2_char(sig_num, metric)

    if strcmp(metric, "time") || strcmp(metric, "igd")
        new_character = sig_number_2_char_opp(sig_num);
    else
        if sig_num == -1 
            new_character = '$^-$';
        elseif sig_num == 1
            new_character = '$^+$'; 
        else
            new_character = '$^\approx$';
        end
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

function new_character = sig_number_2_color(sig_num, metric)

    if strcmp(metric, "time") || strcmp(metric, "igd")
        new_character = sig_number_2_color_opp(sig_num);
    else
        if sig_num == -1 
            new_character = '\cellcolor{worse}';
        elseif sig_num == 1 
            new_character = '\cellcolor{better}'; 
        else
            new_character = '\cellcolor{same}';
        end
    end

end


function new_character = sig_number_2_color_opp(sig_num)
    if sig_num == -1 
        new_character = '\cellcolor{better}';
    elseif sig_num == 1
        new_character = '\cellcolor{worse}'; 
    else
        new_character = '\cellcolor{same}';
    end
end

