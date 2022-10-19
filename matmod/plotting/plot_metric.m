

function plot_metric(metric, decVarName, config, res, algs)

    %% Global controls
    LABEL_FONT_SIZE = 20; 
    LEGEND_FONT_SIZE = 12;
    TICK_SIZE = 14;
    SUBTITLE_FONT_SIZE = 20;
    TITLE_FONT_SIZE = 22;

    available_colors = [60 , 180, 75 ; 230, 25 , 75 ; ...
         0  , 130, 200; 245, 130, 48 ; 145, 30 , 180; 70 , 240, 240; ...
         240, 50 , 230; 210, 245, 60 ; 250, 190, 212; 0  , 128, 128; ...
         220, 190, 255; 170, 110, 40 ; 255, 250, 200; 128, 0  , 0  ; ...
         170, 255, 195; 128, 128, 0  ; 255, 215, 180; 0  , 0  , 128; ...
         128, 128, 128; 255, 255, 255 ];
    
    HVS = {0.586735, 0.586735, 0.586735, 0.822101, 0.822101, 0.822101, 0.350874, 0.350874};

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

    numDependentVars = numel(decVars);
    numAlgorithms = numel(algs);
    
    isSparseNN = strcmp(func2str(config.prob), 'Sparse_NN');
  
    %% Legend logic

    % Generate the number of colors needed automatically 

    algorithmColors = available_colors(1:numAlgorithms,:);

    algorithmColors = algorithmColors/255;

    %% legend logic 
    % Add perfect reference lines if needed
    if metric == "HV" && ~ isSparseNN
        legend_entries = cell(numAlgorithms*2+1,1);
        legend_entries{1} = 'Perfect HV';    
        offset = 0; 
    elseif metric == "nds"
        legend_entries = cell(numAlgorithms*2+1,1);
        legend_entries{1} = 'Perfect NDS';    
        offset = 0; 
    else
        legend_entries = cell(numAlgorithms*2,1);
        offset = 1; 

    end

    % Add the various algorithms to the legend 
    for a = 1:numAlgorithms
        % Offset 
        legend_entries{a*2 - offset} = ""; % Ignore CIs
        legend_entries{a*2+1 - offset} = cleanLegend(algs{a});
    end

    if indep_var_dec_vars
        if isSparseNN
            dependentVars = decVars';
        else
            dependentVars = config.Dz;

        end
        x_label = 'Decision Variables';

    else
        dependentVars = config.sparsities;
        x_label = 'Sparsity (%)';
    end

    %% Calculate optimal HV
    if metric == "HV" && ~ isSparseNN
        func_name = func2str(config.prob);
        optimal_hv =  HVS{str2num(func_name(end))};
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

            current_alg = algs{alg};
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
    
    y_min = 5000000;
    y_max = -5000000;

    %% Print out perfect results if applicable
    if metric == "HV" && ~ isSparseNN
        x = dependentVars;
        y = ones(1, numel(x))*optimal_hv;
        plot(x,y, ':k', 'LineWidth', 4);
        y_min = min(y_min, min(y));
        y_max = max(y_max, max(y));
        hold on

    end
    if metric == "nds"
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
        if contains(algs{alg}, 'sNSGA')
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
    l = legend(legend_entries);
    l.FontSize = LEGEND_FONT_SIZE;
    fontname(gca, "Times");
    ax = gca;
    ax.FontSize = TICK_SIZE; 

end

function cleanEntry = cleanLegend(rawEntry)
    if  contains(rawEntry, "sNSGA")
        cleanEntry = "S-NSGA-II";
    else
        cleanEntry = strrep(rawEntry, 'PMMOEA', 'PM-MOEA');
        cleanEntry = strrep(cleanEntry, 'MOEAPSL', 'MOEA/PSL');
        cleanEntry = strrep(cleanEntry, 'MPMMEA', 'MP-MMEA');

    end



end