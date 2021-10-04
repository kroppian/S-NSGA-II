
clear

%% Global controls 

% CHANGE ME 1
% true to make the dependent variable # of decision variables
% false to make the dependent variable sparsity % 
indep_var_dec_vars = true;

% CHANGE ME 2
% true to plot for comparative runs
% false to plot effective runs
comparative_runs = true;

% CHANGE ME 3
input_file = 'Z:\Gilgamesh\kroppian\spsRuns\2021-10-04\runResults_comparative_decVar_SMOP1.mat';
load(input_file);

% CHANGE ME 4
save_to_file = false;

% CHANGE ME 5
hv_ref = 1;

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
abbrMetricLabels = {'hv', 'runtime', 'NNDS'};
yLabels = {'HV', 'Runtime (seconds)', 'Number of non-dominated solutions'};
results = {HVResults, timeResults, noNonDoms};

numRepetitions = size(HVResults, 1);
numDependentVars = size(HVResults, 2);
numAlgorithms = size(HVResults, 3);

hv_ind = 1;

% results
% dim. two: the number of decision variables
% dim. one: algorithm
template = ones(numDependentVars, numAlgorithms);

globalMeans = {template, template};
globalUpperInts = {template, template};
globalLowerInts = {template, template};

%% Calc results

% For every metric
for m = 1:numel(results)
    
    label = metricLabels{m};
    metricResults = results{m};
    
    % For every algorithm
    for alg = 1:numAlgorithms

        algResults = metricResults(:,:,alg);

        % For every number of decision variables

        for decVar = 1:numDependentVars
            
            %% metric processing

            decResults = algResults(:,decVar);

            if m == hv_ind
                % Pull the appropriate HV from the record
                decResults = arrayfun(@(x)(x{1}(hv_ref)), decResults, 'UniformOutput', false);
                decResults = arrayfun(@(x)(x{1}), decResults);
            end

            
            % Calculate mean
            decMean = mean(decResults);

            globalMeans{m}(decVar, alg) = decMean;

            % CIs
%             stdErr = std(decResults)/sqrt(length(decResults));
%             ts = tinv([0.025  0.975],length(decResults)-1);
%             CI  = decMean + ts*stdErr;
            CI = bootci(30, @mean, decResults);

            globalUpperInts{m}(decVar, alg) = max(CI);
            globalLowerInts{m}(decVar, alg) = min(CI);

        end

    end
end

%% Plot  results

% For every metric
for m = 1:numel(results)
    
    figure
        
    for alg = 1:numAlgorithms

        color = algorithmColors(alg,:);

        lowerInterval = globalLowerInts{m}(:,alg);
        upperInterval = globalUpperInts{m}(:,alg);

        x = [dependentVars, fliplr(dependentVars)];
        y = [lowerInterval; flipud(upperInterval)]';
        fill(x,y, 1,....
            'facecolor',color, ...
            'edgecolor','none', ...
            'facealpha', 0.3);

        hold on
        
        plot(dependentVars,globalMeans{m}(:,alg), 'Color', color);
        
        %title(metricLabels{m});

        xlabel(x_label);
        ylabel(yLabels{m});
        

        
    end
    
    
    legend(legend_entries);
    if save_to_file
        png_file = replace(input_file, '.mat', strcat('_', abbrMetricLabels{m},'.png'));
        set(gcf,'PaperUnits','inches','PaperSize',[5,5],'PaperPosition',[0 0 6 6]);
        print('-dpng','-r400',png_file);
    end
    
end



%% Functions 
