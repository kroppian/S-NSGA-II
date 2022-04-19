function id = genRunId(config,runNo)

    alg_name = func2str(config.algorithms{runNo});
    sampling_method = func2str(config.sampling_method{runNo}{1});
    mutation_method = func2str(config.mutation_method{runNo});
    crossover_method = func2str(config.crossover_method{runNo});

    id = [alg_name, '-', sampling_method, '-', mutation_method, '-', crossover_method];

end

