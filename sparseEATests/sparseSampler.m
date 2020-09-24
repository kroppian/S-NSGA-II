%% Randomly generate an initial population
function Population = sparseSampler(obj,N)
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
    fprintf("%d\n", nargin);
    if nargin < 2
        N = obj.N;
    end
    Population = INDIVIDUAL(obj.problem.Init(N));
end