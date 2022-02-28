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




    %% Main 

    for s = 1:numel(config.sparsities)

        % for each # of decision variables
        for i = 1:size(config.Dz,2)

            % for each possible algorithm 
            for a = 1:size(config.algorithms,2)

                if config.indep_var_dec_vars
                    fprintf("Running algorithm %s with %d decision variables\n", config.labels{a}, config.Dz(i));
                else
                    fprintf("Running algorithm %s with sparsity of %d\n", config.labels{a}, config.sparsities(s));
                end

                % for each repetition

                if config.indep_var_dec_vars
                    index = i;
                else
                    index = s;
                end

                for rep = 1:config.repetitions

                                        
                    [workingDir, name, ext]= fileparts(mfilename('fullpath'));
                    addpath(workingDir);
                    
                    tStart = cputime;

                    [Dec, final_pop, Con] = platemo(                 ...
                              'algorithm',  config.algorithms{a}          , ...
                              'problem'  ,  {config.prob , config.sparsities(s)} , ...
                              'N'        ,  50                     , ...
                              'maxFE'    ,  20000                  , ...
                              'N'        ,  100                    , ...
                              'M'        ,  2                      , ...
                              'D'        ,  config.Dz(i)                  , ...
                              'outputFcn',  @nop); % Surpresses the normaloutput

                          
                   
                    tEnd = cputime - tStart;
                    
                    cd(workingDir);


                    hvs = ones(config.max_ref, 1)*-1;
                    for hvr = 1:config.max_ref
                        hvs(hvr, 1) = CalHV(final_pop, [hvr, hvr]);
                    end
                    HVResults{rep, index, a} = hvs;

                    timeResults(rep, index, a) = tEnd;
                    noNonDoms(rep, index, a) = size(final_pop,1);

                end

            end

        end
    end


    if config.indep_var_dec_vars 
        run_type = "decVar";
    else
        run_type = "sparsity";
    end

    %file_name = strcat('runResults_', run_label, '_', run_type, '_', strrep(char(config.prob),'@(x)',''), '.mat');

    % Save results so we don't have to 
    %save(file_name, 'HVResults', 'timeResults', 'noNonDoms', 'final_pops');

    globalTimeEnd = cputime - globalTimeStart;

    fprintf("Took %f seconds\n", globalTimeEnd);
    
    results = run_result(HVResults, timeResults, noNonDoms, final_pops, globalTimeEnd);
    
end

