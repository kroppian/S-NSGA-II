function newPop = sparsePolyMutate(Pop, Problem, Parameter)

    % Pop 
    % Each row is a different population member
    % Each column is a different genome
    
    
    if nargin > 2
        [probMut,distrMut] = deal(Parameter{:});
    else
        [probMut,distrMut] = deal(1,20);
    end

    %% Gather some information on the problem
    [N,D] = size(Pop);
    upperBound = repmat(Problem.upper, N, 1);
    lowerBound = repmat(Problem.lower, N, 1);
    
    %% Determine where to do which mutations
    % Determine where to mutate
    mutateMask = rand(N,D) < probMut/D;    
   
    % Determine where the zeros are
    zeroMask    = Pop == 0;
    nonZeroMask = Pop ~= 0;
   
    %% Do mutations 
    % Mutation on zero positions
    zeroToMutate = mutateMask & zeroMask;
    
    % Flip zeros to uniform random numbers  
    numToMutate = sum(zeroToMutate, 'all')
    
    
    range = upperBound - lowerBound;
    Pop(zeroToMutate) = lowerBound(zeroToMutate) + rand(numToMutate, 1).*range(zeroToMutate);

    
    newPop = Pop;

end

