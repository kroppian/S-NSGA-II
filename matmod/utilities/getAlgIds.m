function ids = getAlgIds(config)

    ids = cell(size(config.labels));


    for i = 1:numel(ids)
        raw_algorithm = func2str(config.algorithms{i});
        sampling_method =  func2str(config.sampling_method{i}{1});
        mutation_method = func2str(config.mutation_method{i});
        crossover_method = func2str(config.crossover_method{i});

        if raw_algorithm == "sNSGAII" || raw_algorithm == "sNSGAII_island"
            ids{i} = [raw_algorithm, '-', sampling_method, '-', mutation_method, '-', crossover_method];
        else
            ids{i} = raw_algorithm;
        end
    
    end



end

