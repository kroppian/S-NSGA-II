function output(Algorithm, Problem)
    if Problem.FE >= Problem.maxFE
        
        folder = fullfile('Data',class(Algorithm));
        [~,~]  = mkdir(folder);
        
        t = getCurrentTask();
        if isempty(t)
            id = 1;
        else
            id = t.ID;
        end
            
        file   = fullfile(folder,sprintf('%s_%s_M%d_D%d_t%d', ...
                    class(Algorithm), ...
                    class(Problem),   ...
                    Problem.M,        ...
                    Problem.D,        ...
                    id));
                    
        result = Algorithm.result;
        metric = Algorithm.metric;

        gens_recorded = size(result,1);

        metric.HV = ones(gens_recorded,1)*-99;
        metric.nds = ones(gens_recorded,1)*-99;

        for p = 1:gens_recorded
            metric.HV(p) = HV(result{p,2}, Problem.optimum);
        end

        for p = 1:gens_recorded
            pop = result{p,2};
            metric.nds(p) = size(pop.best,  2);
        end

        save([file,'.mat'],'result','metric');

    end
end

