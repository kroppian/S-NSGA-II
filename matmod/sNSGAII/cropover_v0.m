function newPop = cropover_v0(Parent, lb, ub, Parameter)
    %% Fetch paramters/setup
    [proC,disC] = deal(Parameter{:});

    Parent1 = Parent(1:floor(end/2),:);
    Parent2 = Parent(floor(end/2)+1:floor(end/2)*2,:);
    [~,D]   = size(Parent1);

    % Check the sparsities of the parents
    Parent1Sparsities = sum(Parent1 == 0, 2) / D;
    Parent2Sparsities = sum(Parent2 == 0, 2) / D;

    %% Do normal SBX
    
    Offspring = sbx(Parent, lb, ub, proC, disC);

    
    %% Mutate genome to get results back into the parents' sparsity 

    % check the sparsities of the children
    OffspringSparsities = sum(Offspring == 0, 2) / D;
    
    correctedSparsities = sbx([Parent1Sparsities'; Parent2Sparsities'], 0, 1, proC, disC);

    correctedSparsities = [correctedSparsities(1,:)';correctedSparsities(2,:)'];

    Offspring = sm2target(Offspring, ...
                            zeros(size(correctedSparsities))', ...
                            ones(size(correctedSparsities))', ...
                            correctedSparsities);

    newPop = Offspring;
end

