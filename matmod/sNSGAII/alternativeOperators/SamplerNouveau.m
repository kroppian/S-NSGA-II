%% Randomly generate an initial population
function Population = SamplerNouveau(prob, sLower, sUpper)
    
    %% Result set up
    pop = prob.Initialization();
    varCount = size(prob.lower,2);
    mask = false(prob.N, varCount);
    N = prob.N;
    D = prob.D;

    %% Determine the positioning of each stripe per individual
    densityVector = 1 - linspace(sLower, sUpper, prob.N);
    densityVector = round(densityVector.*prob.D);
    
    % targetGenomeDensityThreshold
    tgdt = round((sum(densityVector)/prob.D));

    %% Integer linear programming set up
    % Objective function 
    f = -1*ones(N*D, 1);
    
    % Inequality constraints (making sure we keep balanced genomes)
    A = zeros(D, N*D);

    genome_pos = 1; 
    for n = 1:D
        A(n, genome_pos:genome_pos+N-1) = 1; 
        genome_pos = genome_pos + N;
    end
    b = ones(D, 1)*tgdt;

    % Equality constraints (making sure target sparsity is maintained)
    A_eq = zeros(N,N*D);

    offset = 0; 
    for n = 1:N
        q = ((0:(D-1)).*N)+1;
        q = q + offset;
        A_eq(n,q) = 1;
        offset = offset + 1; 
    end

    b_eq = densityVector';
    
    % further parameters
    intcon = (1:N*D)';
    
    lb = zeros(N*D,1);
    ub = ones(N*D,1);
    
    x_opt = intlinprog(f, intcon, A, b, A_eq, b_eq, lb, ub);

    sum(x_opt)

    mask = reshape(x_opt, N, D);

    %% Mask off population according to stripe position 
    sparse_pop = pop.decs;
    sparse_pop(~mask) = 0;

    Population = SOLUTION(sparse_pop);


end



