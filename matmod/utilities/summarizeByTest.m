function summarizedSigTable = summarizeByTest(sigTable)
    summarizedSigTable = sigTable;

    % gather necessary information on table
    colNames = sigTable.Properties.VariableNames;
    colsToSummarize = colNames(1,contains(colNames, "mean_") & contains(colNames, "time_"));
    testProbs = unique(sigTable.testProb);
    D = unique(sigTable.numDecVars);
    algorithms = unique(sigTable.baseMethod);

    % Clear out results table
    summarizedSigTable(:,:) = [];
    
    %% Iterate through columns to summarize

    row = 1; 

    % ... and for every possible number of decision variables ...
    for d = 1:numel(D)

        currentD = D(d);


        % ... and every base method ... 
        for a = 1:numel(algorithms)
       

            % Create a new row
            summarizedSigTable = [summarizedSigTable; array2table(nan(1,size(summarizedSigTable,2)),'variablenames',summarizedSigTable.Properties.VariableNames)];      

            baseMethod = algorithms(a);

            summarizedSigTable{row, 'baseMethod'} = baseMethod;            
            summarizedSigTable{row, "numDecVars"} = currentD; 
            %summarizedSigTable{row, "testProb"} = {testProb}; 


            % ... and every column to summarize
            for c = 1:numel(colsToSummarize)
            
                currentCol = colsToSummarize{c};
               
                % Calculate the summary
                dMask = sigTable.numDecVars == currentD;
                methodMask = strcmp(sigTable.baseMethod,  baseMethod); 
                dataOfCol = sigTable{dMask & methodMask, currentCol};
                
                meanOfCol = mean(dataOfCol(dataOfCol >= 0));
                summarizedSigTable{row, currentCol} = meanOfCol;
    

    
            end

            row = row + 1;
    
        end

    end

end

