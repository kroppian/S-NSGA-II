function ids = getAlgIds(config)

    ids = cell(size(config.labels));

    for i = 1:numel(ids)
        ids{i} = getAlgId(config, i);
    end

end

