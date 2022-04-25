function plot_generational_info(res, config, run, D)
    
    alg_count = numel(unique(res.alg));
    legend_entries = cell(alg_count+1 ,1);
    
    max_gen = -1; 
    
    subplot(2,1,1);
    
    % Plot each algorithm sparsity performance 
    for a = 1:alg_count
        alg = genRunId(config, a);
        medSparsity = res{res.run == run & res.D == D & strcmp(res.alg, alg), 'medSparsities'};
        plot(medSparsity);
        legend_entries{a} = config.labels{a}; 
    
        max_gen = max(max_gen, numel(medSparsity));
        hold on;
    end
    
    % Plot optimal sparsity 
    targetSparsity = config.defaultSparsity;
    plot(ones(max_gen,1)*(1 -targetSparsity)); 
    
    % labeling 
    legend_entries{alg_count + 1} = "Target sparsity";
    legend(legend_entries);
    
    xlabel("Generation");
    ylabel("Median population sparsity");
    title(func2str(config.prob));
    
    % Next, hypervolume 
    subplot(2,1,2);

    
    % Plot each algorithm HV performance 
    for a = 1:alg_count
        alg = genRunId(config, a);
        medSparsity = res{res.run == run & res.D == D & strcmp(res.alg, alg), 'HV'};
        plot(medSparsity);
        max_gen = max(max_gen, numel(medSparsity));
        hold on;
    end
    
    xlabel("Generation");
    ylabel("Population HV");

end

