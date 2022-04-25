function plot_strip_scatter(res, config, D)
    
    alg_count = numel(unique(res.alg));
    legend_entries = cell(alg_count ,1);
    
        
    % Plot each algorithm sparsity performance 
    for a = 1:alg_count
        alg = genRunId(config, a);
        hvs = res{res.D == D & strcmp(res.alg, alg), 'HV'};

        jitters = ones(size(hvs))*a + unifrnd(-0.1,0.1,size(hvs));

        scatter(jitters, hvs);

        legend_entries{a} = config.labels{a}; 
    
        hold on;
    end
    
    % labeling 
    legend(legend_entries);
    
    xlabel("Objective 1");
    ylabel("Objective 2");
    title(func2str(config.prob));

end

