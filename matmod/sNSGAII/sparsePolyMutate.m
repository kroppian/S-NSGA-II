function newPop = sparsePolyMutate(Pop, Problem, Parameter)

    % Pop 
    % Each row is a different population member
    % Each column is a different genome
    
    
    if nargin > 2
        [probMut,distrMut, probSMut, distrSMut] = deal(Parameter{:});
    else
        [probMut,distrMut, probSMut, distrSMut] = deal(1,20,1,20);
    end

    %% Gather some information on the problem
    [N,D] = size(Pop);
    upperBound = repmat(Problem.upper, N, 1);
    lowerBound = repmat(Problem.lower, N, 1);
    
    %% Determine where to do which mutations
    % Determine where to mutate
    % mutateMask = rand(N,D) < probMut/D;    
   
    % Determine where the zeros are
    zeroMask    = Pop == 0;
    nonZeroMask = Pop ~= 0;
   
    %% Do mutations 
%     % Figure out the zero positions to mutate
%     zeroToMutate = mutateMask & zeroMask;
%     
%     % Flip zeros to uniform random numbers  
%     numToMutate = sum(zeroToMutate, 'all');
%     range = upperBound - lowerBound;
%     Pop(zeroToMutate) = lowerBound(zeroToMutate) + rand(numToMutate, 1).*range(zeroToMutate);
%         
%     % Figure out the non-zero positions to mutate
%     nZerosToMutate = mutateMask & nonZeroMask;
%     numToMutate = sum(nZerosToMutate, 'all');

    ran = rand(size(Pop(nonZeroMask)));

    toMutateNZ = ran < (1/D);
    
    toMutate = false(size(Pop));
    
    toMutate(nonZeroMask) = toMutateNZ;
    
    [genomesToMutate, c] = find(toMutate);

    lb = Problem.lower(genomesToMutate)';
    ub = Problem.upper(genomesToMutate)';


    % mutate
    Pop(toMutate) = polyMutate(  Pop(toMutate), ...
                                    lb, ub, distrMut);
        
%     ran = rand();
% 
%     if ran < probSMut/D
%         %% Sparsity mutation
%         
%     end
%     
    
    
    newPop = Pop;

end


