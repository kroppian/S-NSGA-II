
clear

load('runResults.mat')

numRepetitions = size(HVResults, 1);
numDecisionVars = size(HVResults, 2);
numAlgorithms = size(HVResults, 3);

algorithmColors = {'black', 'red', 'blue'};



% results
% dim. two: the number of decision variables
% dim. one: algorithm
HVMeans = ones(numDecisionVars, numAlgorithms);
HVupperInts = ones(numDecisionVars, numAlgorithms);
HVlowerInts = ones(numDecisionVars, numAlgorithms);

timeMeans = ones(numDecisionVars, numAlgorithms);
timeUpperInts = ones(numDecisionVars, numAlgorithms);
timelowerInts = ones(numDecisionVars, numAlgorithms);


% For every algorithm
for alg = 1:numAlgorithms
    
    algHV = HVResults(:,:,alg);
    
    algTimes = timeResults(:,:,alg);
    
    % For every number of decision variables

    for decVar = 1:numDecisionVars
        %% HV processing

        hyperVols = algHV(:,decVar);
        
        % Calculate mean
        meanHV = mean(hyperVols);
        
        HVMeans(decVar, alg) = meanHV;
        
        % CIs
        stdErr = std(hyperVols)/sqrt(length(hyperVols));
        ts = tinv([0.025  0.975],length(hyperVols)-1);
        CI  = meanHV + ts*stdErr;
        
        HVupperInts(decVar, alg) = max(CI);
        HVlowerInts(decVar, alg) = min(CI);
         
        %% time processing
        times = algTimes(:,decVar);

        % Calculate mean
        meanTime = mean(times);
        
        timeMeans(decVar, alg) = meanTime;
        
        % CIs
        stdErr = std(times)/sqrt(length(times));
        ts = tinv([0.025  0.975],length(times)-1);
        CI  = meanTime + ts*stdErr;
        
        timeUpperInts(decVar, alg) = max(CI);
        timelowerInts(decVar, alg) = min(CI);
        
    end

end

%% Plot HV results
for alg = 1:numAlgorithms
    
    color = algorithmColors{alg};
    
    lowerInterval = HVlowerInts(:,alg);
    upperInterval = HVupperInts(:,alg);
    
    x = [1:numDecisionVars, fliplr(1:numDecisionVars)];
    y = [lowerInterval; flipud(upperInterval)]';
    fill(x,y, 1,....
        'facecolor',color, ...
        'edgecolor','none', ...
        'facealpha', 0.3);
   
    hold on

    
    plot(HVMeans(:,alg), color);
    
end

legend("SparseEA 95% conf. int", "SparseEA mean",  "NSGA-II with SPS 95% conf. int", "NSGA-II with SPS",  "NSGA-II 95% conf. int", "NSGA-II")

figure

%% Plot time results

%timeMeans = ones(numDecisionVars, numAlgorithms);
%timeUpperInts = ones(numDecisionVars, numAlgorithms);
%timelowerInts = ones(numDecisionVars, numAlgorithms);


for alg = 1:numAlgorithms
    
    color = algorithmColors{alg};
    
    lowerInterval = timeUpperInts(:,alg);
    upperInterval = timelowerInts(:,alg);
    
    x = [1:numDecisionVars, fliplr(1:numDecisionVars)];
    y = [lowerInterval; flipud(upperInterval)]';
    fill(x,y, 1,....
        'facecolor',color, ...
        'edgecolor','none', ...
        'facealpha', 0.3);
   
    hold on

    
    plot(timeMeans(:,alg), color);
    
end

legend("SparseEA 95% conf. int", "SparseEA mean",  "NSGA-II with SPS 95% conf. int", "NSGA-II with SPS",  "NSGA-II 95% conf. int", "NSGA-II")


