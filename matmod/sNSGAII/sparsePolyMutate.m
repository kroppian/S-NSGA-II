function newPop = sparsePolyMutate(Pop, Problem, Parameter)

    % Pop 
    % Each row is a different population member
    % Each column is a different genome
    
    
    if nargin > 2
        [probMut,distrMut, probSMut, distrSMut] = deal(Parameter{:});
    else
        [probMut,distrMut, probSMut, distrSMut] = deal(1,20,1,20);
    end

    [N,D] = size(Pop);
    
    %% Determine where to do which mutations
    % Determine where to mutate
    % mutateMask = rand(N,D) < probMut/D;    
   
    % Determine where the zeros are
    nonZeroMask = Pop ~= 0;
   
    %% Value mutations 
    ran = rand(size(Pop(nonZeroMask)));

    toMutateNZ = ran < (probMut/D);
    
    toMutate = false(size(Pop));
    
    toMutate(nonZeroMask) = toMutateNZ;
    
    [genomesToMutate, ~] = find(toMutate);

    lb = Problem.lower(genomesToMutate)';
    ub = Problem.upper(genomesToMutate)';


    % mutate values
    Pop(toMutate) = polyMutate(  Pop(toMutate), ...
                                    lb, ub, distrMut);
        
    %% Sparsity mutations 

    % Determine which population members to mutate sparsity 
    ran = rand(N, 1);

    mutateMask = ran < probSMut/D;

    % Figure out the individual sparsities of each individual 
    sparsities = sum(Pop == 0, 2) / D;
    
    lb = zeros(sum(mutateMask), 1);
    ub = ones(sum(mutateMask), 1);

    newSparsities = sparsities;

    newSparsities(mutateMask) = polyMutate(sparsities(mutateMask), lb, ub, distrSMut);

    newSparsities = min(max(newSparsities,0),1);

    % check if there's anything to do
    if newSparsities == sparsities
        newPop = Pop;
    else
        newPop = sm2target(Pop, Problem, newSparsities);
    end

end


