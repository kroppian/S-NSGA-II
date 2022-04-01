function newPop = cropover_v1(Parent, lb, ub, Parameter)
    %% Fetch paramters/setup
    [proC,disC] = deal(Parameter{:});

    Parent1 = Parent(1:floor(end/2),:);
    Parent2 = Parent(floor(end/2)+1:floor(end/2)*2,:);
    [~,D]   = size(Parent1);

    % Check the sparsities of the parents
    Parent1Sparsities = sum(Parent1 == 0, 2) / D;
    Parent2Sparsities = sum(Parent2 == 0, 2) / D;

    % figure out where are zeros/non-zeros
    zMaskP1 = Parent1 == 0;
    zMaskP2 = Parent2 == 0;
    
    nzMaskP1 = ~zMaskP1;
    nzMaskP2 = ~zMaskP2;

    % figure out which positions are both zero or both non-zero
    matching = (zMaskP1 & zMaskP2) | (nzMaskP1 & nzMaskP2);
    not_matching = ~matching;

    % empty template for results 
    Offspring1 = ones(size(Parent1))*-99;
    Offspring2 = ones(size(Parent2))*-99;


    %% Step 1: crossover on positions are both non-zero or both zero
    
    [~,genes2sbx] = find(matching);

    sbx_resuls = sbx([Parent1(matching)';Parent2(matching)'], lb(genes2sbx), ub(genes2sbx), proC, disC);

    Offspring1(matching) = sbx_resuls(1,:)';
    Offspring2(matching) = sbx_resuls(2,:)';

    %% Step 2: swap values that are mismatches between zero and non-zero
    
    % empty mask of which positions to swap
    swap_mask = ones(sum(not_matching, 'all'), 1);
    
    % generate random number to determine how many zeros/non-zeros will go
    % to each child 
    z2nzRatio = unifrnd(0,1);
    
    swap_mask = sm2target(swap_mask', 0, 1, z2nzRatio);

    swap_mask = swap_mask == 1;

    % swap
    not_matching_p1 = Parent1(not_matching);
    not_matching_p2 = Parent2(not_matching);

    not_matching_p1(swap_mask) = not_matching_p2(swap_mask);
    not_matching_p2(~swap_mask) = not_matching_p1(~swap_mask);

    Offspring1(not_matching) = not_matching_p1;
    Offspring2(not_matching) = not_matching_p2;

    % return result
    newPop = [Offspring1; Offspring2];


end

