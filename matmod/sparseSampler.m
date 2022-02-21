%% Randomly generate an initial population
function Population = sparseSampler(prob, sLower, sUpper)
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

    
    pop = prob.Initialization();
    varCount = size(prob.lower,2);

    mask = false(prob.N, varCount);
    for indv = 1:prob.N
        % generate the number of zeros 
        zeroCount = randi(round([sLower*varCount, sUpper*varCount]));
        zeroIndices = randperm(varCount, zeroCount);
        mask(indv, zeroIndices) = true;
    end
    sparse_pop = pop.decs;
    
    sparse_pop(mask) = 0;
    
    Population = SOLUTION(sparse_pop);
end