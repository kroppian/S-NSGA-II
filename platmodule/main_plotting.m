
clear

%% Comparative runs parameters (uncomment/comment to use/not use)
% Pull just one of these result files to get a bit of metadata on the run
% load('data/runResultsSMOP8.mat');
% 
% % Generate the number of colors needed automatically 
% alg_count = 3;
% colors = turbo;
% color_count = size(colors, 1);
% color_step_size = floor(color_count/alg_count);
% color_indices = (1:alg_count)*color_step_size;
% algorithmColors = colors(color_indices,:);
% 
% legend_entries = {'SparseEA 95% conf. int', 'SparseEA mean',  ...
%     'NSGA-II with SPS 95% conf. int', 'NSGA-II with SPS',  ...
%     'NSGA-II 95% conf. int', 'NSGA-II'};

%% Effective runs parameters (uncomment/comment to use/not use)
% Pull just one of these result files to get a bit of metadata on the run
load('data/runResults_comparative_SMOP1.mat');

% Generate the number of colors needed automatically 
alg_count = 6;
colors = turbo;
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


%% Remaining parameters 

metricLabels = {'HV vs # of decision variables', 'Runtime vs # of decision variables', 'Number of non-dominated solutions vs # of decision variables'};
yLabels = {'HV', 'Runtime (seconds)', 'Number of non-dominated solutions'};
results = {HVResults, timeResults, noNonDoms};

numRepetitions = size(HVResults, 1);
numDecisionVars = size(HVResults, 2);
numAlgorithms = size(HVResults, 3);


Dz = [100, 500, 1000, 2500, 5000, 7500];


% results
% dim. two: the number of decision variables
% dim. one: algorithm
template = ones(numDecisionVars, numAlgorithms);

globalMeans = {template, template};
globalUpperInts = {template, template};
globalLowerInts = {template, template};


% For every metric
for m = 1:numel(results)
    
    label = metricLabels{m};
    metricResults = results{m};
    
    % For every algorithm
    for alg = 1:numAlgorithms


        algResults = metricResults(:,:,alg);

        % For every number of decision variables

        for decVar = 1:numDecisionVars
            
            %% HV processing

            decResults = algResults(:,decVar);

            % Calculate mean
            decMean = mean(decResults);

            globalMeans{m}(decVar, alg) = decMean;

            % CIs
            stdErr = std(decResults)/sqrt(length(decResults));
            ts = tinv([0.025  0.975],length(decResults)-1);
            CI  = decMean + ts*stdErr;

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

        x = [Dz, fliplr(Dz)];
        y = [lowerInterval; flipud(upperInterval)]';
        fill(x,y, 1,....
            'facecolor',color, ...
            'edgecolor','none', ...
            'facealpha', 0.3);

        hold on
        
        plot(Dz,globalMeans{m}(:,alg), 'Color', color);
        
        title(metricLabels{m});

        xlabel('Decision variables');
        ylabel(yLabels{m});
        
    end
    
    
    legend(legend_entries);

    
end


