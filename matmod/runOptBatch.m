 function results = run_single_optimization(platEMOPath, ...
                                            reps, ...
                                            algorithms, ...
                                            sps_on, ... 
                                            labels, ...
                                            max_ref, ...
                                            prob, ...
                                            indep_var_dec_vars, ...
                                            defaultDecVar, ...
                                            defaultSparsity, ...
                                            Dz, ...
                                            sparsities)

    %% Setup
    globalTimeStart = cputime;

    % Path to the install path of plat EMO 
    [workingDir, name, ext]= fileparts(mfilename('fullpath'));
    addpath(genpath(platEMOPath));
    addpath(workingDir);
    

    if indep_var_dec_vars
        sparsities = [defaultSparsity];
    else
        Dz = {defaultDecVar};
    end

    % Dimension one:   repetition
    % Dimension two:   # of decision variables
    % Dimension three: algorithm
    timeResults = ones(reps, numel(Dz), numel(algorithms))*-1;
    noNonDoms   = ones(reps, numel(Dz), numel(algorithms))*-1;
    final_pops = cell(reps, numel(Dz), numel(algorithms));

    HVResults = cell(reps, numel(Dz), numel(algorithms));




    %% Main 

    for s = 1:numel(sparsities)

        % for each # of decision variables
        for i = 1:size(Dz,2)

            % for each possible algorithm 
            for a = 1:size(algorithms,2)

                if indep_var_dec_vars
                    fprintf("Running algorithm %s with %d decision variables\n", labels{a}, Dz{i});
                else
                    fprintf("Running algorithm %s with sparsity of %d\n", labels{a}, sparsities(s));
                end

                % for each repetition

                if indep_var_dec_vars
                    index = i;
                else
                    index = s;
                end

                for rep = 1:reps

                    tStart = cputime;
                    final_pop = runOpt(algorithms{a}, Dz{i}, sparsities(s), prob, sps_on{a});
                    tEnd = cputime - tStart;

                    hvs = ones(max_ref, 1)*-1;
                    for hvr = 1:max_ref
                        hvs(hvr, 1) = CalHV(final_pop, [hvr, hvr]);
                    end
                    HVResults{rep, index, a} = hvs;

                    timeResults(rep, index, a) = tEnd;
                    noNonDoms(rep, index, a) = size(final_pop,1);

                end

            end

        end
    end


    if indep_var_dec_vars 
        run_type = "decVar";
    else
        run_type = "sparsity";
    end

    %file_name = strcat('runResults_', run_label, '_', run_type, '_', strrep(char(prob),'@(x)',''), '.mat');

    % Save results so we don't have to 
    save(file_name, 'HVResults', 'timeResults', 'noNonDoms', 'final_pops');

    globalTimeEnd = cputime - globalTimeStart;

    fprintf("Took %f seconds\n", globalTimeEnd);

    HVResults, timeResults, noNonDoms, final_pops, globalTimeEnd = HVResults, timeResults, noNonDoms, final_pops, globalTimeEnd
    
end

