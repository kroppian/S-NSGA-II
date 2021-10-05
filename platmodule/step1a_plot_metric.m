
clear

%% Global controls 

[workingDir, name, ext]= fileparts(mfilename('fullpath'));

addpath(genpath(strcat(workingDir, '/utilities')));


% CHANGE ME 1

% true to make the dependent variable # of decision variables
% false to make the dependent variable sparsity % 
indep_var_dec_vars = true;

% CHANGE ME 2
% true to plot for comparative runs
% false to plot effective runs
comparative_runs = true;

% CHANGE ME 3
runs = {
   '/Volumes/data/Gilgamesh/kroppian/spsRuns/2021-10-04/runResults_comparative_decVar_SMOP1.mat', ...  
   '/Volumes/data/Gilgamesh/kroppian/spsRuns/2021-10-04/runResults_comparative_decVar_SMOP2.mat', ...
   '/Volumes/data/Gilgamesh/kroppian/spsRuns/2021-10-04/runResults_comparative_decVar_SMOP3.mat', ...
   '/Volumes/data/Gilgamesh/kroppian/spsRuns/2021-10-04/runResults_comparative_decVar_SMOP4.mat', ...
   '/Volumes/data/Gilgamesh/kroppian/spsRuns/2021-10-04/runResults_comparative_decVar_SMOP5.mat', ...
   '/Volumes/data/Gilgamesh/kroppian/spsRuns/2021-10-04/runResults_comparative_decVar_SMOP6.mat', ...
   '/Volumes/data/Gilgamesh/kroppian/spsRuns/2021-10-04/runResults_comparative_decVar_SMOP7.mat', ...
   '/Volumes/data/Gilgamesh/kroppian/spsRuns/2021-10-04/runResults_comparative_decVar_SMOP8.mat'

   };

% runs = {
%    'data/runResults_effective_sparsity_SMOP1.mat', ...  
%    'data/runResults_effective_sparsity_SMOP2.mat', ...
%    'data/runResults_effective_sparsity_SMOP3.mat', ...
%    'data/runResults_effective_sparsity_SMOP4.mat', ...
%    'data/runResults_effective_sparsity_SMOP5.mat', ...
%    'data/runResults_effective_sparsity_SMOP6.mat', ...
%    'data/runResults_effective_sparsity_SMOP7.mat', ...
%    'data/runResults_effective_sparsity_SMOP8.mat'};
% runs = {
%    'data/runResults_effective_decVar_SMOP1.mat', ...  
%    'data/runResults_effective_decVar_SMOP2.mat', ...
%    'data/runResults_effective_decVar_SMOP3.mat', ...
%    'data/runResults_effective_decVar_SMOP4.mat', ...
%    'data/runResults_effective_decVar_SMOP5.mat', ...
%    'data/runResults_effective_decVar_SMOP6.mat', ...
%    'data/runResults_effective_decVar_SMOP7.mat', ...
%    'data/runResults_effective_decVar_SMOP8.mat'};



% Load one as a template for the rest of the runs
load(runs{1});

% CHANGE ME 4
save_to_file = false;

% CHANGE ME 5
% HV = 1
% run time = 2
% NNDS = 3
metric = 1;

% CHANGE ME 6
grid_layout = false;

% CHANGE ME 7
hv_ref = 2; 

%% Comparative versus effective options
if comparative_runs

    %% Comparative runs parameters 

    % Generate the number of colors needed automatically 

    algorithmColors = [255, 25, 25; 0, 0, 230];

    algorithmColors = algorithmColors/255;

    legend_entries = {'SparseEA 95% conf. int', 'SparseEA mean',  ...
        'NSGA-II with SPS 95% conf. int', 'NSGA-II with SPS'};

else
    %% Effective runs parameters 
    
    % Generate the number of colors needed automatically 
    alg_count = 6;
    colors = hsv;
    color_count = size(colors, 1);
    color_step_size = floor(color_count/alg_count);
    color_indices = (1:alg_count)*color_step_size;
    algorithmColors = colors(color_indices,:);
    
    legend_entries = {'MOPSO 95% conf. int', 'MOPSO mean',  ...
        'MOPSO with SPS 95% conf. int', 'MOPSO with SPS mean',  ...
        'MOEADDE 95% conf. int', 'MOEADDE mean', ...
        'MOEADDE with SPS 95% conf. int', 'MOEADDE with SPS mean', ...
        'NSGA-II 95% conf. int', 'NSGA-II mean', ...
        'NSGA-II with SPS 95% conf. int', 'NSGA-II with SPS mean'};

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
yLabels = {'HV', 'Runtime log(seconds)', 'Number of non-dominated solutions'};
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

        hold on

        y = globalMeans{metric}(:,alg);
        if metric == 2 % Run time
            y = log(y);
            %dependentVars = log10(dependentVars);
        end
        
        plot(dependentVars, y, 'Color', color);


        xlabel(x_label);
        ylabel(yLabels{metric});
        
        y_min = min(y_min, min(y));
        y_max = max(y_max, max(y));
        
    end

          
    plot_title = strcat([char(96+r), '.) ', testProbLabels{r}]);
    title(plot_title);

    
    if metric == 1 % HV 
        x = dependentVars;
        y = ones(1, numel(x))*optimal_hvs(r);
        plot(x,y, '--k', 'LineWidth', 1);
        y_min = min(y_min, min(y));
        y_max = max(y_max, max(y));
        
    end
    if metric == 3 % NNDS
        x = dependentVars;
        y = ones(1, numel(x))*100;
        plot(x,y, '--k', 'LineWidth', 1.5);
        y_min = min(y_min, min(y));
        y_max = max(y_max, max(y));
        ylim([y_min - (y_min*0.05), y_max*1.05])

    end

    % Legend logic
    if (plotno == numAlgorithms || ~grid_layout)
        
        % See if you've already added the perfect line legend 
        if numel(legend_entries) < ((numAlgorithms*2)+1)
             % Then only add it for HV and NNDS
            if metric == 1
               legend_entries{numel(legend_entries)+1} = 'Perfect HV';
            end
            if metric == 3
               legend_entries{numel(legend_entries)+1} = 'Perfect NDS';
            end
        end

        legend(legend_entries);
        
    end
    
    
    plotno = plotno + 1;
    
    if save_to_file
        png_file = replace(input_file, '.mat', strcat('_', abbrMetricLabels{metric},'.png'));
        set(gcf,'PaperUnits','inches','PaperSize',[5,5],'PaperPosition',[0 0 6 6]);
        print('-dpng','-r400',png_file);
    end


    
end % End for every run 



%% Functions 
png_file = replace(input_file, '.mat', strcat('_', abbrMetricLabels{metric},'.png'));
disp(png_file);
