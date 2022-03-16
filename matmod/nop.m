function nop(Algorithm, Problem)
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
        save([file,'.mat'],'result','metric');

    end
end

