function id = getAlgId(config, runNo)

    raw_algorithm = func2str(config.algorithms{runNo});

    if raw_algorithm == "sNSGAII" || raw_algorithm == "sNSGAII_island_v1" || raw_algorithm == "sNSGAII_island_v2"
        
        if class(config.sampling_method{runNo}) == "function_handle" && func2str(config.sampling_method{runNo}) == "nop"
            sampling_method = 'uniform';
        else
            sampling_method = func2str(config.sampling_method{runNo}{1});
        end
        mutation_method = func2str(config.mutation_method{runNo});
        crossover_method = func2str(config.crossover_method{runNo});

        id = [raw_algorithm, '-', sampling_method, '-', mutation_method, '-', crossover_method];
    else
        id = raw_algorithm;
    end

end

