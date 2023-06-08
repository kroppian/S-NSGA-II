function newPop = polyMutate(Pop, lb, ub, Parameter)


    if nargin > 3
        [probMut,distrMut] = deal(Parameter{:});
    else
        [probMut,distrMut] = deal(1,20,1,20);
    end

    [~,D] = size(Pop);

    nonZeroMask = Pop ~= 0;
    
    ran = rand(size(Pop(nonZeroMask)));

    toMutateNZ = ran < (probMut/D);
    
    toMutate = false(size(Pop));
    
    toMutate(nonZeroMask) = toMutateNZ;
    
    [~, genomesToMutate] = find(toMutate);

    lb_pm = lb(genomesToMutate)';
    ub_pm = ub(genomesToMutate)';


    % mutate values
    Pop(toMutate) = polyMutateCore(  Pop(toMutate), ...
                                    lb_pm, ub_pm, distrMut);

    newPop = Pop;

end

