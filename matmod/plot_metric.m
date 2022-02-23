
% CHANGE ME 2
% HV = 1
% run time = 2
% NNDS = 3

function plot_metric(metric, config, res)

    %% Global controls
    LABEL_FONT_SIZE = 16; 
    LEGEND_FONT_SIZE = 12; 
    SUBTITLE_FONT_SIZE = 14;
    TITLE_FONT_SIZE = 22;

    %% Configuration
    if config.runType == "compDecVar" || config.runType == "effDecVar"
        indep_var_dec_vars = true;
    else
        indep_var_dec_vars = false;
    end

    if config.runType == "compDecVar"
        comparative_runs = true;
    else
        comparative_runs = false;
    end

    if comparative_runs
        hv_ref = 2; 
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



    if indep_var_dec_vars
        dependentVars = config.Dz;
        x_label = 'Decision variables';
    else
        dependentVars = config.sparsities;
        x_label = 'Sparsity (%)';
    end


    %% Remaining parameters 

    metricLabels = {'HV vs # of decision variables', 'Runtime vs # of decision variables', 'Number of non-dominated solutions vs # of decision variables'};
    abbrMetricLabels = {'hv', 'runtime', 'NDS'};
    yLabels = {'HV', 'Runtime log(seconds)', 'NDS'};
    testProbLabels = {'SMOP1', 'SMOP2', 'SMOP3', 'SMOP4', 'SMOP5', 'SMOP6', 'SMOP7', 'SMOP8'};

    numRepetitions = size(res.HVResults, 1);
    numDependentVars = size(res.HVResults, 2);
    numAlgorithms = size(res.HVResults, 3);

    %% Calculate optimal HV
    if metric == 1

        ref_front = config.prob('M',2).GetPF();

        optimal_hv = CalHV(ref_front, [hv_ref, hv_ref]);

    end

    %% Plotting
    results = {res.HVResults, res.timeResults, res.noNonDoms};

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

    figure
    
    y_min = 5000000;
    y_max = -5000000;


    %% Print out perfect results if applicable
    if metric == 1 % HV 
        x = dependentVars;
        y = ones(1, numel(x))*optimal_hv;
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
    
end


