function ids = getAlgIds(config)

    ids = cell(size(config.labels));

    for i = 1:numel(ids)
        ids{i} = genRunId(config, i);
    end

end

