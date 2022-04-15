function results = runOptBatch(config)

    %% Setup

    % Path to the install path of plat EMO 
    [workingDir, ~, ~]= fileparts(mfilename('fullpath'));
    addpath(genpath(config.platPath));
    addpath(workingDir);
    addpath(config.sNSGAIIPath)
    

    if config.indep_var_dec_vars
        config.sparsities = [config.defaultSparsity];
    else
        config.Dz = {config.defaultDecVar};
    end


    num_sparsities = numel(config.sparsities);
    num_decVars = size(config.Dz,2);
    num_algs = size(config.algorithms,2);
    num_reps = config.repetitions;
 
    population_collection = cell(num_sparsities*num_decVars*num_algs*num_reps,1);
    evaluation_collection = cell(num_sparsities*num_decVars*num_algs*num_reps,1);
    run_collections       = cell(num_sparsities*num_decVars*num_algs*num_reps,1);
    D_collections         = cell(num_sparsities*num_decVars*num_algs*num_reps,1);
    s_collections         = cell(num_sparsities*num_decVars*num_algs*num_reps,1);
    HV_collections        = cell(num_sparsities*num_decVars*num_algs*num_reps,1);
    gen_collections       = cell(num_sparsities*num_decVars*num_algs*num_reps,1);
    max_gen_collections   = cell(num_sparsities*num_decVars*num_algs*num_reps,1);
    sps_on_collections    = cell(num_sparsities*num_decVars*num_algs*num_reps,1);
    s_mut_on_collections  = cell(num_sparsities*num_decVars*num_algs*num_reps,1);
    s_x_on_collections    = cell(num_sparsities*num_decVars*num_algs*num_reps,1);
    stripe_s_collections  = cell(num_sparsities*num_decVars*num_algs*num_reps,1);
    alg_collection        = cell(num_sparsities*num_decVars*num_algs*num_reps,1);
    time_collection       = cell(num_sparsities*num_decVars*num_algs*num_reps,1);


    scenarios = cartesian(config.sparsities, config.Dz, 1:num_algs, 1:num_reps);
    %% Main 

    % Iterate over all scenarios
    parfor s = 1:size(scenarios,1)
    
        sparsity = scenarios(s, 1);
        decision_vars = scenarios(s, 2);

        algorithm           = config.algorithms{scenarios(s, 3)};
        sampling_method_raw = config.sampling_method{scenarios(s, 3)};
        mutation_method     = config.mutation_method{scenarios(s, 3)};
        crossover_method    = config.crossover_method{scenarios(s, 3)};

        if class(sampling_method_raw) == "cell"
            sampling_method = sampling_method_raw{1};
            sampling_lb = sampling_method_raw{2};
            sampling_ub = sampling_method_raw{3};
        else
            sampling_method = sampling_method_raw;
            sampling_lb = 0.5;
            sampling_ub = 1;
        end
        

        rep = scenarios(s, 4);

        raw_algorithm = func2str(algorithm);
        if raw_algorithm == "sNSGAII" || raw_algorithm == "sNSGAII_island"
            annotated_alg = [raw_algorithm, '-', func2str(sampling_method), '-', func2str(mutation_method), '-', func2str(crossover_method)];
        else
            annotated_alg = raw_algorithm;
        end

        if rep == 1 && func2str(algorithm) == "sNSGAII" || raw_algorithm == "sNSGAII_island"
            fprintf("Running algorithm %s with %d decision variables and sparsity %f\n", ...
                     annotated_alg, decision_vars, sparsity);
        elseif rep == 1
            fprintf("Running algorithm %s with %d decision variables and sparsity %f\n", ...
                     annotated_alg, decision_vars, sparsity);
        end

    
                            
        [workingDir, ~, ~]= fileparts(mfilename('fullpath'));
        addpath(workingDir);
        

        if func2str(algorithm) == "sNSGAII" || raw_algorithm == "sNSGAII_island"
            platemo(                                             ...
                      'algorithm',  {algorithm, {sampling_method, sampling_lb, sampling_ub}, mutation_method, crossover_method} , ...
                      'problem'  ,  {config.prob , sparsity}             , ...
                      'maxFE'    ,  20000                                , ...
                      'N'        ,  100                                  , ...
                      'M'        ,  2                                    , ...
                      'D'        ,  decision_vars                        , ...
                      'outputFcn',  @output                              , ...
                      'save'     ,  20000);
        else
            platemo(                                                       ...
                      'algorithm',  algorithm                            , ...
                      'problem'  ,  {config.prob , sparsity}             , ...
                      'maxFE'    ,  20000                                , ...
                      'N'        ,  100                                  , ...
                      'M'        ,  2                                    , ...
                      'D'        ,  decision_vars                        , ...
                      'outputFcn',  @output                              , ...
                      'save'     ,  20000);
        end
        

        % Read output      
        output_dir = fullfile(config.platPath, ...
                              'Data', ...
                              func2str(algorithm));
                          
        t = getCurrentTask();
        if isempty(t)
            proc_id = 1;
        else
            proc_id = t.ID;
        end
                          
        output_path = fullfile(output_dir,sprintf('%s_%s_M%d_D%d_t%d.mat', ...
                        func2str(algorithm), ...
                        func2str(config.prob), ...
                        2, decision_vars, proc_id));
    
    
        raw_run_history = load(output_path, 'result');
        metrics = load(output_path, 'metric');
        metrics = metrics.metric;

        evaluation_collection{s} = cell2mat(raw_run_history.result(:,1));
        population_collection{s} = raw_run_history.result(:,2);

        generations = size(raw_run_history.result,1);


        % configuration
        run_collections{s}      = ones(generations, 1) * rep;
        D_collections{s}        = ones(generations, 1) * decision_vars;
        s_collections{s}        = ones(generations, 1) * sparsity;
        HV_collections{s}       = metrics.HV;
        nds_collections{s}      = metrics.nds;
        gen_collections{s}      = (1:generations)';
        max_gen_collections{s}  = ones(generations,1) * generations;
        sps_on_collections{s}   = ones(generations, 1) * (func2str(sampling_method) == "sparseSampler");
        s_mut_on_collections{s} = ones(generations, 1) * (func2str(mutation_method) ~= "nop");
        s_x_on_collections{s}   = ones(generations, 1) * (func2str(crossover_method) ~= "nop");
        stripe_s_collections{s} = ones(generations, 1) * (func2str(sampling_method)  == "stripedSparseSampler");

        alg_name = cell(generations, 1);
        [alg_name{:}] = deal(annotated_alg);
        alg_collection{s} = alg_name;

        % metrics
        time_collection{s} = ones(generations, 1) * metrics.runtime;
        
        cd(workingDir);

    end
    
    evaluation_col = vertcat(evaluation_collection{:});
    population_col = vertcat(population_collection{:});
    run_col        = vertcat(run_collections{:});
    D_col          = vertcat(D_collections{:});
    s_col          = vertcat(s_collections{:});
    HV_col         = vertcat(HV_collections{:});
    nds_col        = vertcat(nds_collections{:});
    gen_col        = vertcat(gen_collections{:});
    max_gen_col    = vertcat(max_gen_collections{:});
    sps_on_col     = vertcat(sps_on_collections{:});
    s_mut_on_col   = vertcat(s_mut_on_collections{:});
    s_x_on_col     = vertcat(s_x_on_collections{:});
    stripe_s_col   = vertcat(stripe_s_collections{:});
    alg_col        = vertcat(alg_collection{:});
    time_col       = vertcat(time_collection{:});

    result_table = table(evaluation_col, population_col, run_col, ...
          D_col, s_col, HV_col, nds_col, gen_col, max_gen_col, sps_on_col, ...
          s_mut_on_col, s_x_on_col, stripe_s_col, alg_col, time_col, ...
          'VariableNames',{'evaluations', 'population', 'run', 'D', ...
          's', 'HV', 'nds', 'gen', 'max_gen', 'sps_on', 's_mut_on', 's_x_on', ...
          'stripe_s', 'alg', 'time'});

    results = result_table;
    
end

% Taken from https://stackoverflow.com/questions/9834254/cartesian-product-in-matlab
function C = cartesian(varargin)
    args = varargin;
    n = nargin;

    [F{1:n}] = ndgrid(args{:});

    for i=n:-1:1
        G(:,i) = F{i}(:);
    end

    C = unique(G , 'rows');
end
