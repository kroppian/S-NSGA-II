function plot_generational_info(res, config, run, D, toInclude)
    
    alg_count = numel(toInclude);
    legend_entries = cell(alg_count+1 ,1);
    
    max_gen = -1; 
    
    subplot(2,1,1);
    
    % Plot each algorithm sparsity performance 
    for a = 1:alg_count

        alg = genRunId(config, a);
        if numel(find(ismember(toInclude, alg))) == 0
            continue;
        end
           
        medSparsity = res{res.run == run & res.D == D & strcmp(res.alg, alg), 'medSparsities'};
        % Convert to theta, which everyone else is so goo goo about.
        plot(1-medSparsity, 'LineWidth', 2);
        legend_entries{a} = config.labels{a}; 
    
        max_gen = max(max_gen, numel(medSparsity));
        hold on;
    end
    
    % Plot optimal sparsity 
    targetSparsity = config.defaultSparsity;
    plot(ones(max_gen,1)*(targetSparsity), 'LineWidth', 2); 
    
    % labeling 
    legend_entries{alg_count + 1} = 'Target sparsity';
    legend(legend_entries);
    
    xlabel("Generation");
    ylabel("Median population sparsity");
    title(func2str(config.prob));

    fontsize(gca,18,"pixels")
    fontname(gca, "Cambria Math")
    
    % Next, hypervolume 
    subplot(2,1,2);

    
    % Plot each algorithm HV performance 
    for a = 1:alg_count
        alg = genRunId(config, a);
        if numel(find(ismember(toInclude, alg))) == 0
            continue;
        end
           
        medHV = res{res.run == run & res.D == D & strcmp(res.alg, alg), 'HV'};
        plot(medHV,  'LineWidth', 2);
        max_gen = max(max_gen, numel(medHV));
        hold on;
    end
    
    xlabel("Generation");
    ylabel("Population HV");

    fontsize(gca,18,"pixels")
    fontname(gca, "Cambria Math")
    
end

