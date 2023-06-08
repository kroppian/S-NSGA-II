clear

addpath("configs");
addpath("utilities");
addpath("plotting");

%sNSGA_eff_400;
%sNSGA_eff_sparsity;
sNSGA_eff_400;
%sNSGA_comparative;


problems = {@SMOP1, @SMOP2, @SMOP3, @SMOP4, @SMOP5, @SMOP6, @SMOP7, @SMOP8};

for p = 1:numel(problems)

    config.prob = problems{p};

    if config.saveData
        file_name = strcat(config.run_label, '_', config.runType, '_', strrep(char(config.prob),'@(x)',''), '_new.mat');
        fullSavePath = strcat(config.savePath, file_name);
        if ~exist(config.savePath, 'dir')
            error("Output path does not exist.");
        end
    end
    
    
    %% Run optimization
    res = runOptBatch(config);
    
    
    %% Post processing
    medSparsities = calcMedianSparsities(res);
    res.medSparsities = medSparsities;
    
    % Get a last generation cross section of the results 
    res_final = res(res.gen == res.max_gen,:);
    
    if config.saveData
        if config.saveAllGens
            save(fullSavePath, 'res_final', 'res', 'config', '-v7.3');
        else        
            save(fullSavePath, 'res_final', 'config', '-v7.3');
        end
    end

end




