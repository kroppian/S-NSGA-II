
clear

load('runResults.mat')

numRepetitions = size(HVResults, 1);
numDecisionVars = size(HVResults, 2);
numAlgorithms = size(HVResults, 3);

algorithmColors = {'black', 'red', 'blue'};


% results
% dim. two: the number of decision variables
% dim. one: algorithm
means = ones(numDecisionVars, numAlgorithms);
upperInts = ones(numDecisionVars, numAlgorithms);
lowerInts = ones(numDecisionVars, numAlgorithms);


% For every algorithm
for alg = 1:numAlgorithms
    
    
    algHV = HVResults(:,:,alg);
    % For every number of decision variables
    
    for decVar = 1:numDecisionVars
        
        hyperVols = algHV(:,decVar);
        
        % Calculate mean
        meanHV = mean(hyperVols);
        
        % Calculate standard deviation
        stdDevHV = std(hyperVols);
        
        means(decVar, alg) = meanHV;
        
        % Lazy CIs
        stdErr = std(hyperVols)/sqrt(length(hyperVols));
        ts = tinv([0.025  0.975],length(hyperVols)-1);
        CI  = meanHV + ts*stdErr;
         
        
        upperInts(decVar, alg) = max(CI);
        lowerInts(decVar, alg) = min(CI);
         
    end

end

% Plot means

for alg = 1:numAlgorithms
    
    color = algorithmColors{alg};
    
    lowerInterval = lowerInts(:,alg);
    upperInterval = upperInts(:,alg);
    
    x = [1:numDecisionVars, fliplr(1:numDecisionVars)];
    y = [lowerInterval; flipud(upperInterval)]';
    fill(x,y, 1,....
        'facecolor',color, ...
        'edgecolor','none', ...
        'facealpha', 0.3);
   
    hold on

    
    plot(means(:,alg), color);
    
end



