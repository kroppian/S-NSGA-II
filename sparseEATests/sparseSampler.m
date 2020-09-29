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
    for indv = 1:N
        % generate the number of zeros 
        zeroCount = randi(round([sLower*varCount, sUpper*varCount]));
        zeroIndices = randperm(varCount, zeroCount);
        mask(indv, zeroIndices) = true;
    end
    genome(mask) = 0;

    Population = INDIVIDUAL(genome);
end