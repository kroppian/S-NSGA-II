classdef run_config
    %RESULT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        platPath           
        sNSGAIIPath        
        repetitions        
        algorithms         
        sps_on             
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
    end
    
    methods
        function obj = run_config(platPath, sNSGAIIPath, repetitions, ...
                algorithms, sps_on, labels, run_label, max_ref, ...
                refPoints, prob, indep_var_dec_vars, defaultDecVar, ...
                defaultSparsity, Dz, sparsities, runType)
            
            %RESULT Construct an instance of this class
            %   Detailed explanation goes here
            obj.platPath           = platPath;
            obj.sNSGAIIPath        = sNSGAIIPath;
            obj.repetitions        = repetitions;
            obj.algorithms         = algorithms;
            obj.sps_on             = sps_on;
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
            
            addpath(genpath(obj.platPath));

        end
    end
end

