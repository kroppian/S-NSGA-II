%% Setup 
clear

load('resultsTable.mat')


%% Run setup 

% Analysis metrics
metrics = {'hv', 'numNonDom', 'runTimes'};
algorithmsUsed = {'SparseEA', 'NSGAII-SPS'};
% metrics = {'hv'};
% algorithmsUsed = {'SparseEA'};
testProblems = {'SMOP1', 'SMOP2', 'SMOP3', 'SMOP4', 'SMOP5', 'SMOP6', 'SMOP7', 'SMOP8'};


% Result set up
numDecVar    = numel(decVarsUsed);
numAlgorithmsUsed = numel(algorithmsUsed);
numMetrics = numel(metrics);
numTestProbs = numel(testProblems);

%% Iterate through every decision variable and performance metric


% Every metric and algorithm will have its own figure 
for m = 1:numMetrics

    for a = 1:numAlgorithmsUsed
            
        %% Make the figure 
        figure
        row = 1;
        plotNo = 1;
        
        % 
        algorithm = algorithmsUsed{a};
        metric = metrics{m};
        sgtitle(strcat(metric, ' for ', algorithm));

        
        % And for every test case used
        for t = 1:numTestProbs
        
            col = 1;

            % For every decision variable used
            for d = 1:numDecVar

                % Retrieve configuration
                decVar = decVarsUsed(d);
                testProb = testProblems{t};
                
                % Mask off the data we need
                algMask = strcmp(algorithm, resultsTable.algorithm); 
                decVarMask = (resultsTable.numDecVars == decVar);
                testProbMask = strcmp(testProb,resultsTable.testProbs);
                
                % Grab data
                rawData = resultsTable.(metric)(algMask & decVarMask & testProbMask);
                
                % Plot
                ax = subplot(numDecVar, numTestProbs, plotNo);
                
                histogram(rawData);
                
                col = col + 1;
                plotNo = plotNo + 1;
                
                
                
            end % Decision var

            row = row + 1;
            
        end

        % Column headers
        test_prob_labels = 1:numTestProbs;
        leftMargin = 0.02; 
        rightMargin = 0.178;
        
        horStepSize = (1-rightMargin-leftMargin)/numTestProbs;
        
        for l = 1:numTestProbs 
            hor_pos = horStepSize*l+leftMargin;
            test_prob_labels(l) = annotation('textbox',[hor_pos 0.90 0.2 0.05],...
                'string',testProblems{l});
        end
        
        set(test_prob_labels, 'fitboxtotext','on',...
            'edgecolor','none')
        
        % Row headers
        decVarlabels = 1:numDecVar;
        topMargin = 0;
        bottomMargin = 0;
        
        vertStepSize = (1.35-rightMargin-leftMargin)/numTestProbs;
        
        for l = 1:numDecVar
            vert_pos = vertStepSize*l+topMargin;
            text = strcat(num2str(decVarsUsed(l)), ' vars');
            decVarlabels(l) =  annotation('textbox',[0.0 (1-vert_pos) 0 0.05],...
                'string', text );
        end
 
        set(decVarlabels, 'fitboxtotext','on',...
            'edgecolor','none')

        
    end


end

