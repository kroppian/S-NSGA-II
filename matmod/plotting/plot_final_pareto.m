function plot_final_pareto(res, config, run, D)
    
    alg_count = numel(unique(res.alg));
    legend_entries = cell(alg_count ,1);
    
        
    % Plot each algorithm sparsity performance 
    for a = 1:alg_count
        alg = genRunId(config, a);
        final_pop = res{res.run == run & res.D == D & strcmp(res.alg, alg), 'population'};

        y = final_pop{1}.best.objs;

        scatter(y(:,1), y(:,2));

        legend_entries{a} = config.labels{a}; 
    
        hold on;
    end
    
    % labeling 
    legend(legend_entries);
    
    xlabel("Objective 1");
    ylabel("Objective 2");
    title(func2str(config.prob));

end

