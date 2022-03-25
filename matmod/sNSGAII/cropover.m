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

    beta = zeros(N,D);
    mu   = rand(N,D);
    beta(mu<=0.5) = (2*mu(mu<=0.5)).^(1/(disC+1));
    beta(mu>0.5)  = (2-2*mu(mu>0.5)).^(-1/(disC+1));
    beta = beta.*(-1).^randi([0,1],N,D);
    beta(rand(N,D)<0.5) = 1;
    beta(repmat(rand(N,1)>proC,1,D)) = 1;
    Offspring = [(Parent1+Parent2)/2+beta.*(Parent1-Parent2)/2
                 (Parent1+Parent2)/2-beta.*(Parent1-Parent2)/2];

    Lower = repmat(Problem.lower,2*N,1);
    Upper = repmat(Problem.upper,2*N,1);
    
    % Put everything back in bounds
    Offspring       = min(max(Offspring,Lower),Upper);

    
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

