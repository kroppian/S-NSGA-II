%% Randomly generate an initial population
function Population = stripedSparseSampler(prob, sLower, sUpper)
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

    %% Build stripes
    avgSparsity = mean([sLower, sUpper]);
    
    stripeWidths = calcStripeWidths(avgSparsity, prob.D);

    stripeCount = numel(stripeWidths);

    stripePos = 1; 
    for sw = 1:stripeCount*20
        mask(sw, :) = true;
        currentStripeWidth = mod((sw-1), stripeCount) + 1;

        mask(sw, stripePos:(stripePos + stripeWidths(currentStripeWidth) - 1)) = false;
        
        stripePos = (stripePos + stripeWidths(currentStripeWidth));
    
        if stripePos > prob.D
            stripePos = 1;
        end
    
    end
   


    %% Sparse sample for the rest of the population 
    for indv = (stripeCount*20+1):prob.N
        % generate the number of zeros 
        zeroCount = randi(round([sLower*varCount, sUpper*varCount]));
        zeroIndices = randperm(varCount, zeroCount);
        mask(indv, zeroIndices) = true;
    end
    sparse_pop = pop.decs;
    
    sparse_pop(mask) = 0;
    
    Population = SOLUTION(sparse_pop);

    function stripeWidths = calcStripeWidths(s, D)
        stripeWidth = floor((1-s)*D);
    
        stripeCount = floor(D/stripeWidth);
    
        stripeRemainder = D - stripeWidth*stripeCount;
    
        stripeWidths = ones(stripeCount,1)*stripeWidth;
    
        stripeWidths = stripeWidths + floor(stripeRemainder/stripeCount);
    
        finalRemainder =  D - sum(stripeWidths);
    
        stripeWidths(end) = stripeWidths(end) + finalRemainder;
   
    end

end



