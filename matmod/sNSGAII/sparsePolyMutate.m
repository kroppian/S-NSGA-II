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

    sparsities2mut = sparsities(mutateMask);

    newSparsities = polyMutate(sparsities2mut, lb, ub, distrSMut);

    newSparsities = min(max(newSparsities,0),1);

    indv2mut = find(mutateMask);


    % determine the non-zero increase/decrease for each indiv
    nz2add = round(D * (sparsities2mut - newSparsities));
    
    % find where the non-zeros are
    [zIndvs,   zGenes] = find(Pop(indv2mut,:) == 0);
    % find where the zeros are 
    [nzIndvs, nzGenes] = find(Pop(indv2mut,:) ~= 0);
    
    newNzs = false(size(Pop));
    newZs = false(size(Pop));

    
    for i = 1:size(indv2mut,1)
        % gather relevant info
        indv_i = indv2mut(i);
        
        % Case where more non-zeros are needed
        if nz2add(i) > 0
            % find where there are zeros to flip
            zeroLocs = zGenes(zIndvs == i);
            
            % determine how many of them to flip
            numToFlip = nz2add(i);
            
            % Determine which of these posible zero positions to flip
            toFlip = zeroLocs(randperm(length(zeroLocs), numToFlip));

            % Record these positions 
            newNzs(indv_i, toFlip) = true;
            
        % Case where more zeros are needed
        else
            
            % find where there are non-zeros to flip
            nZeroLocs = nzGenes(nzIndvs == i);
            
            % determine how many of them to flip
            numToFlip = -nz2add(i);

            % Determine which of these posible non-zero positions to flip
            toFlip = nZeroLocs(randperm(length(nZeroLocs), numToFlip));

            % Record these positions 
            newZs(indv_i, toFlip) = true;

        end


    end

    %% Make the mutations
    
    % Find the min/max of the genome positions to mutate 
    [newNzsRows, ~] = find(newNzs);

    newNzsLb = Problem.lower(newNzsRows);
    newNzsUb = Problem.upper(newNzsRows);

    Pop(newNzs) = newNzsLb + rand(1,sum(newNzs, 'all')) .* (newNzsUb - newNzsLb);
    Pop(newZs) = zeros(sum(newZs, 'all'), 1);

    newPop = Pop;

end


