%% Randomly generate an initial population
function Population = VariedStripedSparseSampler_v0(prob, sLower, sUpper)
    
    pop = prob.Initialization();
    varCount = size(prob.lower,2);
    mask = false(prob.N, varCount);

    densityVector = 1 - linspace(sLower, sUpper, prob.N);

    
    stripePosition = 1; 
    leftToRight = true;

    for i = 1:prob.N
        stripeWidth = round(densityVector(i)*prob.D);

        if leftToRight
            mask(i, stripePosition:(stripePosition+stripeWidth-1)) = true; 
        else            
            mask(i, (stripePosition-stripeWidth):stripePosition) = true; 
        end

        % Move to the next position (either leftward or rightward)
        if leftToRight
            stripePosition = stripePosition + stripeWidth;
        else
            stripePosition = stripePosition - stripeWidth - 1;
        end

        if i ~= prob.N 

            nextStripeWidth = round(densityVector(i+1)*prob.D);

            % check if the next stripe will fit
            if leftToRight && stripePosition + nextStripeWidth - 1 > prob.D
                stripePosition = prob.D;
                leftToRight = false;
            elseif (~leftToRight) && stripePosition - nextStripeWidth < 1
                stripePosition = 1;
                leftToRight = true;
            end

        end

    end

    sparse_pop = pop.decs;
    sparse_pop(~mask) = 0;

    Population = SOLUTION(sparse_pop);

%     %% Build stripes
%     avgSparsity = mean([sLower, sUpper]);
%     
%     stripeWidths = calcStripeWidths(avgSparsity, prob.D);
% 
%     stripeCount = numel(stripeWidths);
% 
%     cycles = prob.N/stripeCount;
% 
%     stripePos = 1; 
%     for sw = 1:stripeCount*cycles
%         mask(sw, :) = true;
%         currentStripeWidth = mod((sw-1), stripeCount) + 1;
% 
%         mask(sw, stripePos:(stripePos + stripeWidths(currentStripeWidth) - 1)) = false;
%         
%         stripePos = (stripePos + stripeWidths(currentStripeWidth));
%     
%         if stripePos > prob.D
%             stripePos = 1;
%         end
%     
%     end
%    
% 
% 
%     %% Sparse sample for the rest of the population 
%     for indv = (stripeCount*cycles+1):prob.N
%         % generate the number of zeros 
%         zeroCount = randi(round([sLower*varCount, sUpper*varCount]));
%         zeroIndices = randperm(varCount, zeroCount);
%         mask(indv, zeroIndices) = true;
%     end
%     sparse_pop = pop.decs;
%     
%     sparse_pop(mask) = 0;
%     
%     Population = SOLUTION(sparse_pop);
% 
%     function stripeWidths = calcStripeWidths(s, D)
%         stripeWidth = floor(round((1-s)*D, 5));
%     
%         stripeCount = floor(D/stripeWidth);
%     
%         stripeRemainder = D - stripeWidth*stripeCount;
%     
%         stripeWidths = ones(stripeCount,1)*stripeWidth;
%     
%         stripeWidths = stripeWidths + floor(stripeRemainder/stripeCount);
%     
%         finalRemainder =  D - sum(stripeWidths);
%     
%         stripeWidths(end) = stripeWidths(end) + finalRemainder;
%    
%     end

end



