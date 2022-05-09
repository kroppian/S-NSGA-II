%% Randomly generate an initial population
function Population = VariedStripedSparseSampler_v2(prob, sLower, sUpper)
    

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

    %% Result set up
    pop = prob.Initialization();
    varCount = size(prob.lower,2);
    mask = false(prob.N, varCount);

    %% Determine the positioning of each stripe per individual
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

    %% Create density mask 
    currentIndv = 1;
    for c = 1:cycle_count
        cycle = cycles(c, cycles(c, :) ~= 0);

        widths = widthVector(cycle);

        gapToFill = prob.D - sum(widths);
        
        position = 1;
        for i = 1:numel(widths)

            width = widths(i);

            gapWidth = 0;
            if gapToFill > 0
                gapWidth = 1;
                gapToFill = gapToFill - 1;
            end

            mask(currentIndv, position:position+width+gapWidth-1) = true; 

            % Go to the next individual 
            position = position+width+gapWidth;
            currentIndv = currentIndv + 1;


        end

    end

    %% Mask off population according to stripe position 
    sparse_pop = pop.decs;
    sparse_pop(~mask) = 0;

    Population = SOLUTION(sparse_pop);


end



