function medianSparsity = calcMedianSparsities(tab)

    medianSparsity = zeros(size(tab,1),1);
    for p = 1:size(tab,1)
        x = tab{p, 'population'}{1}.decs;
        D = size(x, 2);
        sparsities = sum(x == 0,2)/D;

        medianSparsity(p) = median(sparsities);
    end
 
end

