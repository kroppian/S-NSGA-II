classdef run_config
    %RESULT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        platPath           
        sNSGAIIPath        
        repetitions        
        algorithms         
        sampling_method    
        mutation_method
        crossover_method       
        labels             
        run_label          
        max_ref            
        refPoints          
        prob               
        indep_var_dec_vars 
        defaultDecVar      
        defaultSparsity    
        Dz                 
        sparsities         
        runType            
        saveData
        savePath
    end
    
    methods
        function obj = run_config(platPath, sNSGAIIPath, repetitions, ...
                algorithms, sampling_method, mutation_method, crossover_method, labels, run_label, max_ref, ...
                refPoints, prob, indep_var_dec_vars, defaultDecVar, ...
                defaultSparsity, Dz, sparsities, runType, saveData, savePath)
            
            %RESULT Construct an instance of this class
            %   Detailed explanation goes here
            obj.platPath           = platPath;
            obj.sNSGAIIPath        = sNSGAIIPath;
            obj.repetitions        = repetitions;
            obj.algorithms         = algorithms;
            obj.sampling_method    = sampling_method;
            obj.mutation_method    = mutation_method;
            obj.crossover_method   = crossover_method;
            obj.labels             = labels;
            obj.run_label          = run_label;
            obj.max_ref            = max_ref;
            obj.refPoints          = refPoints;
            obj.prob               = prob;
            obj.indep_var_dec_vars = indep_var_dec_vars;
            obj.defaultDecVar      = defaultDecVar;
            obj.defaultSparsity    = defaultSparsity;
            obj.Dz                 = Dz;
            obj.sparsities         = sparsities;
            obj.runType            = runType;
            obj.saveData           = saveData;
            obj.savePath           = savePath;
            
            addpath(genpath(obj.platPath));

        end
    end
end

