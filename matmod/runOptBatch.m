function results = runOptBatch(config)

    %% Setup
    globalTimeStart = cputime;

    % Path to the install path of plat EMO 
    [workingDir, name, ext]= fileparts(mfilename('fullpath'));
    addpath(genpath(config.platPath));
    addpath(workingDir);
    addpath(config.sNSGAIIPath)
    

    if config.indep_var_dec_vars
        config.sparsities = [config.defaultSparsity];
    else
        config.Dz = {config.defaultDecVar};
    end

    % Dimension one:   repetition
    % Dimension two:   # of decision variables
    % Dimension three: algorithm
    timeResults = ones(config.repetitions, numel(config.Dz), numel(config.algorithms))*-1;
    noNonDoms   = ones(config.repetitions, numel(config.Dz), numel(config.algorithms))*-1;
    final_pops = cell(config.repetitions, numel(config.Dz), numel(config.algorithms));

    HVResults = cell(config.repetitions, numel(config.Dz), numel(config.algorithms));

    num_sparsities = numel(config.sparsities);
    num_decVars = size(config.Dz,2);
    num_algs = size(config.algorithms,2);
    num_reps = config.repetitions;
 
    table_collection = cell(num_sparsities*num_decVars*num_algs*num_reps);

    scenarios = cartesian(config.sparsities, config.Dz, 1:num_algs, 1:num_reps);
    %% Main 

    % Iterate over all scenarios
    parfor s = 1:size(scenarios,1)
    
        sparsity = scenarios(s, 1);
        decision_vars = scenarios(s, 2);

        algorithm = config.algorithms{scenarios(s, 3)};
        sps_on    = config.sps_on{scenarios(s, 3)};
        s_mut_on  = config.s_mutation_on{scenarios(s, 3)};
        s_x_on    = config.s_x_on{scenarios(s, 3)};

        rep = scenarios(s, 4);

        if rep == 1 && func2str(algorithm) == "sNSGAII"
            fprintf("Running algorithm %s(SPS:%s/s_mut:%s/s_x:%s) with %d decision variables and sparsity %f\n", ...
                     func2str(algorithm), num2str(sps_on), ...
                     num2str(s_mut_on), num2str(s_x_on), decision_vars, sparsity);
        elseif rep == 1
            fprintf("Running algorithm %s with %d decision variables and sparsity %f\n", ...
                     func2str(algorithm), decision_vars, sparsity);
        end

    
                            
        [workingDir, ~, ~]= fileparts(mfilename('fullpath'));
        addpath(workingDir);
        

        if func2str(algorithm) == "sNSGAII"
            platemo(                                             ...
                      'algorithm',  {algorithm, 0.5, 1, sps_on, s_mut_on, s_x_on} , ...
                      'problem'  ,  {config.prob , sparsity}               , ...
                      'N'        ,  50                                   , ...
                      'maxFE'    ,  20000                                , ...
                      'N'        ,  100                                  , ...
                      'M'        ,  2                                    , ...
                      'D'        ,  decision_vars                        , ...
                      'outputFcn',  @nop                                 , ...
                      'save'     ,  20000);
        else
            platemo(                                                       ...
                      'algorithm',  algorithm                            , ...
                      'problem'  ,  {config.prob , sparsity}             , ...
                      'N'        ,  50                                   , ...
                      'maxFE'    ,  20000                                , ...
                      'N'        ,  100                                  , ...
                      'M'        ,  2                                    , ...
                      'D'        ,  decision_vars                        , ...
                      'outputFcn',  @nop                                 , ...
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
        
        % massage the data into a nice table
        run_history = cell2table(raw_run_history.result, ...
            'VariableNames',{'evaluations', 'population'});
        
        generations = size(run_history,1);

        % configuration
        run_history.run      = ones(generations, 1) * rep;
        run_history.D        = ones(generations, 1) * decision_vars;
        run_history.s        = ones(generations, 1) * sparsity;
        run_history.HV       = metrics.HV;
        run_history.gen      = (1:generations)';
        run_history.sps_on   = ones(generations, 1) * sps_on;
        run_history.s_mut_on = ones(generations, 1) * s_mut_on;
        run_history.s_x_on   = ones(generations, 1) * s_x_on;

        alg_name = cell(generations, 1);
        [alg_name{:}] = deal(func2str(algorithm));
        run_history.alg = alg_name;

        % metrics
        run_history.time = ones(generations, 1) * metrics.runtime;

        % Save it for compilation later
        table_collection{s} = run_history;
        
        
        cd(workingDir);

    end
    
    result_table = table_collection{1};
    fprintf("Compiling tables: [")
    for idx = 2:size(scenarios,1)
        fprintf(".");
        result_table = [result_table; table_collection{idx}];
    end
    fprintf("] done.\n");


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
