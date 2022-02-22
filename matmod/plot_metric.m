
clear

%% Global controls 

%platEMOPath = 'C:\Users\Ian Kropp\Projects\PlatEMO';
platEMOPath = '/Users/iankropp/Projects/PlatEMO';

addpath(genpath(platEMOPath));

LABEL_FONT_SIZE = 16; 
LEGEND_FONT_SIZE = 12; 
SUBTITLE_FONT_SIZE = 14;
TITLE_FONT_SIZE = 22;

% CHANGE ME 1
runType = "compDecVar";
% runType = "effSparsity";
% runType = "effDecVar";

% CHANGE ME 2
% HV = 1
% run time = 2
% NNDS = 3
metric = 1;

% CHANGE ME 3
%data_home = 'Z:\Gilgamesh\kroppian\spsRuns\2021-10-04\';
data_home = '/Volumes/data/Gilgamesh/kroppian/spsRuns/2021-10-04/';

% CHANGE ME 4
save_to_file = false;

% CHANGE ME 6
grid_layout = false;

%% Configuration

if runType == "compDecVar" || runType == "effDecVar"
    indep_var_dec_vars = true;
else
    indep_var_dec_vars = false;
end

if runType == "compDecVar"
    comparative_runs = true;
else
    comparative_runs = false;
end


if runType == "compDecVar"
    runs = {strcat(data_home, 'runResults_comparative_decVar_SMOP1.mat'), ... 
            strcat(data_home, 'runResults_comparative_decVar_SMOP2.mat'), ... 
            strcat(data_home, 'runResults_comparative_decVar_SMOP3.mat'), ...
            strcat(data_home, 'runResults_comparative_decVar_SMOP4.mat'), ...
            strcat(data_home, 'runResults_comparative_decVar_SMOP5.mat'), ...
            strcat(data_home, 'runResults_comparative_decVar_SMOP6.mat'), ...
            strcat(data_home, 'runResults_comparative_decVar_SMOP7.mat'), ...
            strcat(data_home, 'runResults_comparative_decVar_SMOP8.mat')};
end

if runType == "effSparsity"
    runs = {strcat(data_home, 'runResults_effective_sparsity_SMOP1.mat'), ... 
            strcat(data_home, 'runResults_effective_sparsity_SMOP2.mat'), ... 
            strcat(data_home, 'runResults_effective_sparsity_SMOP3.mat'), ...
            strcat(data_home, 'runResults_effective_sparsity_SMOP4.mat'), ...
            strcat(data_home, 'runResults_effective_sparsity_SMOP5.mat'), ...
            strcat(data_home, 'runResults_effective_sparsity_SMOP6.mat'), ...
            strcat(data_home, 'runResults_effective_sparsity_SMOP7.mat'), ...
            strcat(data_home, 'runResults_effective_sparsity_SMOP8.mat')};
end

if runType == "effDecVar"
    runs = {strcat(data_home, 'runResults_effective_decVar_SMOP1.mat'), ... 
            strcat(data_home, 'runResults_effective_decVar_SMOP2.mat'), ... 
            strcat(data_home, 'runResults_effective_decVar_SMOP3.mat'), ...
            strcat(data_home, 'runResults_effective_decVar_SMOP4.mat'), ...
            strcat(data_home, 'runResults_effective_decVar_SMOP5.mat'), ...
            strcat(data_home, 'runResults_effective_decVar_SMOP6.mat'), ...
            strcat(data_home, 'runResults_effective_decVar_SMOP7.mat'), ...
            strcat(data_home, 'runResults_effective_decVar_SMOP8.mat')};
end


% Load one as a template for the rest of the runs
load(runs{1});



if comparative_runs
    hv_ref = 2; 
    if grid_layout
        LEGEND_FONT_SIZE = 18; 
    end
else
    hv_ref = 4; 
end


%% Comparative versus effective options
if comparative_runs

    %% Comparative runs parameters 

    % Generate the number of colors needed automatically 

    algorithmColors = [0, 0, 230; 255, 25, 25];

    algorithmColors = algorithmColors/255;

    %% legend logic 
    % Add perfect reference lines if needed
    if metric == 1
        legend_entries = {'Perfect HV', 'SparseEA 95% conf. int', 'SparseEA mean',  ...
            'NSGA-II with SPS 95% conf. int', 'NSGA-II with SPS'};    
    end
    if metric == 3
        legend_entries = {'Perfect NDS', 'SparseEA 95% conf. int', 'SparseEA mean',  ...
            'NSGA-II with SPS 95% conf. int', 'NSGA-II with SPS'};    
    end
    if metric == 2
        legend_entries = {'SparseEA 95% conf. int', 'SparseEA mean',  ...
            'NSGA-II with SPS 95% conf. int', 'NSGA-II with SPS'};
    end
    


else
    %% Effective runs parameters 
    
    % Generate the number of colors needed automatically 
    alg_count = 6;

    % https://sashamaps.net/docs/resources/20-colors/
    algorithmColors = [ 230, 25, 75; ...
                        60, 180, 75; ...
                        0, 0, 128; ...
                        0, 130, 200; ...
                        245, 130, 48; ...
                        0, 0, 0];
                    
    algorithmColors = algorithmColors / 255;

    
    
    if metric == 1
        legend_entries = {'Perfect HV', 'MOPSO 95% conf. int', 'MOPSO mean',  ...
            'MOPSO with SPS 95% conf. int', 'MOPSO with SPS mean',  ...
            'MOEADDE 95% conf. int', 'MOEADDE mean', ...
            'MOEADDE with SPS 95% conf. int', 'MOEADDE with SPS mean', ...
            'NSGA-II 95% conf. int', 'NSGA-II mean', ...
            'NSGA-II with SPS 95% conf. int', 'NSGA-II with SPS mean'};   
    end
    if metric == 3
        legend_entries = {'Perfect NDS', 'MOPSO 95% conf. int', 'MOPSO mean',  ...
            'MOPSO with SPS 95% conf. int', 'MOPSO with SPS mean',  ...
            'MOEADDE 95% conf. int', 'MOEADDE mean', ...
            'MOEADDE with SPS 95% conf. int', 'MOEADDE with SPS mean', ...
            'NSGA-II 95% conf. int', 'NSGA-II mean', ...
            'NSGA-II with SPS 95% conf. int', 'NSGA-II with SPS mean'};   
    end
    if metric == 2
    
        legend_entries = {'MOPSO 95% conf. int', 'MOPSO mean',  ...
            'MOPSO with SPS 95% conf. int', 'MOPSO with SPS mean',  ...
            'MOEADDE 95% conf. int', 'MOEADDE mean', ...
            'MOEADDE with SPS 95% conf. int', 'MOEADDE with SPS mean', ...
            'NSGA-II 95% conf. int', 'NSGA-II mean', ...
            'NSGA-II with SPS 95% conf. int', 'NSGA-II with SPS mean'};
    end
    
    
    
    

end

%% # decision vars vs % sparsity options
Dz = [100, 500, 1000, 2500, 5000, 7500];
sparsities = (1-linspace(0.05, 0.45,9))*100;

if indep_var_dec_vars
    dependentVars = Dz;
    x_label = 'Decision variables';
else
    dependentVars = sparsities;
    x_label = 'Sparsity (%)';
end


%% Remaining parameters 

metricLabels = {'HV vs # of decision variables', 'Runtime vs # of decision variables', 'Number of non-dominated solutions vs # of decision variables'};
abbrMetricLabels = {'hv', 'runtime', 'NDS'};
yLabels = {'HV', 'Runtime log(seconds)', 'NDS'};
testProbLabels = {'SMOP1', 'SMOP2', 'SMOP3', 'SMOP4', 'SMOP5', 'SMOP6', 'SMOP7', 'SMOP8'};

numRepetitions = size(HVResults, 1);
numDependentVars = size(HVResults, 2);
numAlgorithms = size(HVResults, 3);
numRuns = numel(runs);

%% Calculate optimal HV
if metric == 1
    optimal_hvs = ones(1,8);

    fncs = {@SMOP1, @SMOP2, @SMOP3, @SMOP4, @SMOP5, @SMOP6, @SMOP7, @SMOP8};
    fncs_names = {'SMOP1', 'SMOP2', 'SMOP3', 'SMOP4', 'SMOP5', 'SMOP6', 'SMOP7', 'SMOP8'};


    for f = 1:numel(fncs)
        Global = GLOBAL_SPS('-algorithm',@NSGAII,'-evaluation', 20000,'-problem',fncs{f},'-N',100,'-M',2, '-D', 100,'-outputFcn', @nop);

        ref_front = Global.problem.PF(100);

        hv = CalHV(ref_front, [hv_ref, hv_ref]);
        optimal_hvs(f) = hv;
    end
end

%% Plotting

plotno = 1;

for r = 1:numRuns
            
    input_file = runs{r};
    load(input_file);
    results = {HVResults, timeResults, noNonDoms};
    
    % results
    % dim. two: the number of decision variables
    % dim. one: algorithm
    template = ones(numDependentVars, numAlgorithms);

    globalMeans = {template, template};
    globalUpperInts = {template, template};
    globalLowerInts = {template, template};

    %% Calc result summaries (mean, confidence intervals)
    label = metricLabels{metric};
    metricResults = results{metric};

    % For every algorithm
    for alg = 1:numAlgorithms

        algResults = metricResults(:,:,alg);

        % For every number of decision variables

        for decVar = 1:numDependentVars
            %% metric processing

            decResults = algResults(:,decVar); % r == 3 && alg == 2

            if metric == 1
                % Pull the appropriate HV from the record
                decResults = arrayfun(@(x)(x{1}(hv_ref)), decResults, 'UniformOutput', false);
                decResults = arrayfun(@(x)(x{1}), decResults);
            end

            
            % Calculate mean
            decMean = mean(decResults);

            globalMeans{metric}(decVar, alg) = decMean;
    
            % Calculate confidence intervals
            CI = bootci(30, @mean, decResults);

            globalUpperInts{metric}(decVar, alg) = max(CI);
            globalLowerInts{metric}(decVar, alg) = min(CI);

        end

        
    end

    %% Plot  results
    if grid_layout
        subplot(3,3,plotno);
    else
        figure
    end

    y_min = 5000000;
    y_max = -5000000;
    
    
    %% Print out perfect results if applicable
    if metric == 1 % HV 
        x = dependentVars;
        y = ones(1, numel(x))*optimal_hvs(r);
        plot(x,y, ':k', 'LineWidth', 4);
        y_min = min(y_min, min(y));
        y_max = max(y_max, max(y));
        hold on

    end
    if metric == 3 % NNDS
        x = dependentVars;
        y = ones(1, numel(x))*100;
        plot(x,y, ':k', 'LineWidth', 4);
        y_min = min(y_min, min(y));
        y_max = max(y_max, max(y));
        ylim([y_min - (y_min*0.05), y_max*1.05])
        hold on

    end
    
    %% Print results
    for alg = 1:numAlgorithms
            
        color = algorithmColors(alg,:);

        lowerInterval = globalLowerInts{metric}(:,alg);
        upperInterval = globalUpperInts{metric}(:,alg);

        x = [dependentVars, fliplr(dependentVars)];
        y = [lowerInterval; flipud(upperInterval)]';
        
        if metric == 2 % Run time
            y = log(y);
            %x = log(x);
        end
        
        fill(x,y, 1,....
            'facecolor',color, ...
            'edgecolor','none', ...
            'facealpha', 0.3);

        y_min = min(y_min, min(y));
        y_max = max(y_max, max(y));
        
        
        hold on

        y = globalMeans{metric}(:,alg);
        if metric == 2 % Run time
            y = log(y);
        end
        
        % Make song distinguishing difference between with/without SPS in
        % effective runs
        if mod(alg, 2) == 0 
           plot(dependentVars, y, 'Color', color, 'LineWidth', 2);
        else
           plot(dependentVars, y, 'Color', color, 'LineStyle', ':', 'LineWidth', 2);
        end

        xlabel(x_label, 'FontSize', LABEL_FONT_SIZE);
        ylabel(yLabels{metric}, 'FontSize', LABEL_FONT_SIZE);
        
        y_min = min(y_min, min(y));
        y_max = max(y_max, max(y));
        
        x_min = min(dependentVars);
        x_max = max(dependentVars);
        
        y_range = y_max - y_min;
        
        if y_range == 0
            margin = y_max*0.1;
        else
            margin = y_range*0.1;
        end
        
        

        axis([x_min x_max (y_min-margin) (y_max + margin)])

        
    end

    if grid_layout
        plot_title = strcat([char(96+r), '.) Runs with ', testProbLabels{r}]);
        title(plot_title, "FontSize", SUBTITLE_FONT_SIZE);
    end




    % Legend logic
    if (plotno == numAlgorithms || ~grid_layout)
        
%         % See if you've already added the perfect line legend 
%         if numel(legend_entries) < ((numAlgorithms*2)+1)
%              % Then only add it for HV and NNDS
%             if metric == 1
%                legend_entries{numel(legend_entries)+1} = 'Perfect HV';
%             end
%             if metric == 3
%                {numel()+1} = 'Perfect NDS';
%             end
%         end

        l = legend(legend_entries);
        l.FontSize = LEGEND_FONT_SIZE;
        
        
    end
    
    
    plotno = plotno + 1;
    
    if save_to_file
        png_file = replace(input_file, '.mat', strcat('_', abbrMetricLabels{metric},'.png'));
        set(gcf,'PaperUnits','inches','PaperSize',[5,5],'PaperPosition',[0 0 6 6]);
        print('-dpng','-r400',png_file);
    end


    
end % End for every run 

if grid_layout 
    % comparative_runs indep_var_dec_vars
    if ~comparative_runs
        if indep_var_dec_vars     
            sgtitle(strcat("Effects of SPS on ", yLabels{metric}, " at varying decision space sizes"), 'FontSize', TITLE_FONT_SIZE);
        else
            sgtitle(strcat("Effects of SPS on ", yLabels{metric}, " at varying sparsities"), 'FontSize', TITLE_FONT_SIZE);
        end
    else
        sgtitle(strcat(yLabels{metric}, " performance of SparseEA and NSGA-II/SPS at varying decision space sizes"), 'FontSize', TITLE_FONT_SIZE);
    end
end



%% Functions 
if grid_layout
    png_file = replace(strrep(input_file, '_SMOP8', ''), '.mat', strcat('_', abbrMetricLabels{metric},'.png'));
else
    png_file = replace(input_file, '.mat', strcat('_', abbrMetricLabels{metric},'.png'));

end
disp(png_file);
