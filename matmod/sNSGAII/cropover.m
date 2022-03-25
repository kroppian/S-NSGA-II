function newPop = cropover(Parent, Problem, Parameter)
    %% Fetch paramters/setup
    [proC,disC] = deal(Parameter{:});

    Parent1 = Parent(1:floor(end/2),:);
    Parent2 = Parent(floor(end/2)+1:floor(end/2)*2,:);
    [N,D]   = size(Parent1);

    % Check the sparsities of the parents
    Parent1Sparsities = sum(Parent1 == 0, 2) / D;
    Parent2Sparsities = sum(Parent2 == 0, 2) / D;

    % Double them up, to match the format of the Offspring
    Parent1Sparsities = [Parent1Sparsities 
                            Parent1Sparsities ];

    Parent2Sparsities = [Parent2Sparsities 
                            Parent2Sparsities ];

    %% Do normal SBX
    
    Offspring = sbx(Parent, Problem, proC, disC);

    
    %% Mutate genome to get results back into the parents' sparsity 

    % check the sparsities of the children
    OffspringSparsities = sum(Offspring == 0, 2) / D;
    
    % Create upper and lower sparsity bounds based on the child sparsity
    sparsityBounds = sort([Parent1Sparsities, Parent2Sparsities],2);

    sparsityLb = sparsityBounds(:,1);
    sparsityUb = sparsityBounds(:,2);

    % put them back into bounds according to the parent sparsities
    % TODO probably better to handle this with SBX 
    correctedSparsities = min(max(OffspringSparsities,sparsityLb),sparsityUb);

    Offspring = sm2target(Offspring, Problem, correctedSparsities);

    newPop = Offspring;
end

