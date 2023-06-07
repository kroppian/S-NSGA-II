%% Randomly generate an initial population
function Population = VariedStripedSparseSampler_v1(prob, sLower, sUpper)
    

    %  Nomenclature example
    %  N = 8 
    %  D = 14
    %  
    %          Cycle length of 14 
    %          |
    %  |-------|-----------------|
    %  1 1 1 1                        -
    %          1 1 1 1                |-- One full cycle 
    %                  1 1 1          |
    %                        1 1 1    -
    %     |-------|------|-----|---------------- Cycle count of 4
    %   |---|--|-|----------------------Cycle count of 4 
    %  1 1 
    %      1 1 
    %          1 
    %            1   
    %  |----|----|
    %       | 
    %       Cyle length of 6

    pop = prob.Initialization();
    varCount = size(prob.lower,2);
    mask = false(prob.N, varCount);

    densityVector = 1 - linspace(sLower, sUpper, prob.N);
    widthVector = round(densityVector.*prob.D);
    cumulativeWidths = cumsum(widthVector);

    processedIndvs = 0;
    cycle_count = 1;
    cycles = zeros(prob.N, prob.D);
    while processedIndvs < prob.N
        % Figure out how many stripes will fit in this cycle 
        spotsThatFitMask = cumulativeWidths <= prob.D & cumulativeWidths ~= 0;
        numThatFit = sum(spotsThatFitMask);
        largestFit = max(cumulativeWidths(spotsThatFitMask));
        cumulativeWidths = cumulativeWidths - largestFit; 
        cumulativeWidths(cumulativeWidths<0) = 0; 
        processedIndvs = processedIndvs + numThatFit;
        spotsThatFit = find(spotsThatFitMask);
        cycles(cycle_count,1:numThatFit) = spotsThatFit;   
        cycle_count = cycle_count + 1;

    end

    gapPosition = 1; 
    currentIndv = 1;
    for c = 1:cycle_count
        cycle = cycles(c, cycles(c, :) ~= 0);

        widths = widthVector(cycle);
        if(gapPosition > numel(widths))
            gapPosition = 1;
        end

        gapToFill = prob.D - sum(widths);
        
        gaps = zeros(1, numel(widths) + 1);

        if gapToFill ~= 0
            gaps = gaps + floor(gapToFill/numel(gaps));
    
            % next divy out the remainder 
            leftOverGap = mod(gapToFill,numel(gaps));
            toTopOff = randperm(numel(gaps),leftOverGap);
            gaps(toTopOff) = gaps(toTopOff) + 1; 
        end


        position = 1;
        for i = 1:numel(widths)

            width = widths(i);

            position = position + gaps(i);

            mask(currentIndv, position:position+width-1) = true; 

            % Go to the next individual 
            position = position+width;
            currentIndv = currentIndv + 1;
        end

        if gapToFill ~= 0
            gapPosition = gapPosition + 1;
        end
    end

%     foo = zeros(size(mask));
%     foo(mask) = 1;
%     heatmap(foo);
%     figure; 
%     bar(sum(foo));
    sparse_pop = pop.decs;
    sparse_pop(~mask) = 0;

    Population = SOLUTION(sparse_pop);


%     shiftVector = (1:prob.N)';
% 
% 
%     foo = repmat(densityVector, prob.N);
% 
%     current_indv = 1; 
% 
%     % Go through and build each cycle 
%     while current_indv <= prob.N
% 
% 
%         cycle_count = 1; 
%         cycle_length = 0; 
% 
%         buffer = [];
% 
%         % Through through each population member of the current cycle 
%         while cycle_length < prob.D || current_indv <= prob.N
%             
%             buffer()
% 
%             cycle_count = cycle_count + 1; 
%             current_indv = current_indv + 1; 
%         end
%         
% 
%     end
%      



end



