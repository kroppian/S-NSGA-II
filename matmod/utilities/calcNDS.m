function resWithNDS = calcNDS(res)

    nds = ones(size(res,1),1)*-99;

    for p = 1:size(res, 1)
        pop = res{p, 'population'};
        pop = pop{1};
        nds(p) =     size(pop.best,2);

    end

    res.nds = nds;

    resWithNDS = res;
        
end

