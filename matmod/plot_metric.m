

function plot_metric(metric, decVarName, config, res)

    %% Global controls
    LABEL_FONT_SIZE = 16; 
    LEGEND_FONT_SIZE = 12; 
    SUBTITLE_FONT_SIZE = 14;
    TITLE_FONT_SIZE = 22;

    available_colors = [230, 25 , 75 ; 60 , 180, 75 ; 255, 225, 25 ; ...
         0  , 130, 200; 245, 130, 48 ; 145, 30 , 180; 70 , 240, 240; ...
         240, 50 , 230; 210, 245, 60 ; 250, 190, 212; 0  , 128, 128; ...
         220, 190, 255; 170, 110, 40 ; 255, 250, 200; 128, 0  , 0  ; ...
         170, 255, 195; 128, 128, 0  ; 255, 215, 180; 0  , 0  , 128; ...
         128, 128, 128; 255, 255, 255 ];
    
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

    repetition = 1:max(res.run);
    decVars = unique(res{:,decVarName});
    algs = config.algorithms;

    numRepetitions = numel(repetition);
    numDependentVars = numel(decVars);
    numAlgorithms = numel(algs);
    
    
    %% Legend logic

    % Generate the number of colors needed automatically 

    algorithmColors = available_colors(1:numAlgorithms,:);

    algorithmColors = algorithmColors/255;

    %% legend logic 
    % Add perfect reference lines if needed
    if metric == "HV"
        legend_entries = {'Perfect HV'};    
    elseif metric == "NDS"
        legend_entries = {'Perfect NDS'};
    else
        legend_entries = {};
    end

    % Add the various algorithms to the legend 
    for a = 1:numAlgorithms
        legend_entries{a*2} = config.labels{a};
        legend_entries{a*2+1} = config.labels(a) + " CI";

    end

    if indep_var_dec_vars
        dependentVars = config.Dz;
        x_label = 'Decision variables';
    else
        dependentVars = config.sparsities;
        x_label = 'Sparsity (%)';
    end




    %% Calculate optimal HV
    if metric == "HV"
        ref_front = config.prob('M',2).GetPF();
        optimal_hv = CalHV(ref_front, [1, 1]);
    end

    %% Plotting
    globalMeans     = ones(numDependentVars, numAlgorithms);
    globalUpperInts = ones(numDependentVars, numAlgorithms);
    globalLowerInts = ones(numDependentVars, numAlgorithms);

    %% Calc result summaries (mean, confidence intervals)

    % For every algorithm
    for alg = 1:numAlgorithms

        % For every number of decision variables

        for decVar = 1:numDependentVars
            %% metric processing

            current_alg = func2str(algs{alg});
            current_dec_var_value = decVars(decVar);
            decResults = res{res{:,decVarName} == current_dec_var_value & strcmp(res.alg, current_alg), metric};

            % Calculate mean
            decMean = mean(decResults);

            globalMeans(decVar, alg) = decMean;

            % Calculate confidence intervals
            CI = bootci(30, @mean, decResults);

            globalUpperInts(decVar, alg) = max(CI);
            globalLowerInts(decVar, alg) = min(CI);

        end
    end

    %% Plot  results

    figure
    
    y_min = 5000000;
    y_max = -5000000;

    %% Print out perfect results if applicable
    if metric == "HV"
        x = dependentVars;
        y = ones(1, numel(x))*optimal_hv;
        plot(x,y, ':k', 'LineWidth', 4);
        y_min = min(y_min, min(y));
        y_max = max(y_max, max(y));
        hold on

    end
    if metric == "NDS"
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

        lowerInterval = globalLowerInts(:,alg);
        upperInterval = globalUpperInts(:,alg);

        x = [dependentVars, fliplr(dependentVars)];
        y = [lowerInterval; flipud(upperInterval)]';

        if metric == "time" % Run time
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

        y = globalMeans(:,alg);
        if metric == "time" % Run time
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
        ylabel(metric, 'FontSize', LABEL_FONT_SIZE);

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
    title(func2str(config.prob));
    legend(legend_entries);
    
end


