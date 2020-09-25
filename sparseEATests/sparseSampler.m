%% Randomly generate an initial population
function Population = sparseSampler(obj, N,sLower,sUpper)
%Initialization - Randomly generate an initial population.
%
%   P = obj.Initialization() returns an initial population, i.e.,
%   an array of obj.N INDIVIDUAL objects.
%
%   P = obj.Initialization(N) returns an initial population with N
%   individuals.
%
%   Example:
%       P = obj.Initialization()

    genome = obj.problem.Init(N);
    varCount = size(obj.lower,2);

    mask = false(N, varCount);
    fprintf("There should be between %d and %d zeros\n", sLower*varCount, sUpper*varCount);
    for indv = 1:N
        % generate the number of zeros 
        zeroCount = randi(round([sLower*varCount, sUpper*varCount]));
        fprintf("Zero count: %d\n", zeroCount)
        zeroIndices = randperm(varCount, zeroCount);
        fprintf("Number of indices generated: %d\n", size(zeroIndices,2))
        mask(indv, zeroIndices) = true;
        fprintf("Number of zeros in this row: %d\n", sum(mask(indv,:)))
    end
    genome(mask) = 0;

    fprintf("Lower %f, upper \n", min(sum(genome == 0,2)/varCount),max(sum(genome == 0,2)/varCount))
    
    Population = INDIVIDUAL(genome);
end