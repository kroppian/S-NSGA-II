
% Define problem
load("testDataSPM.mat");
addpath("..");
addpath("../..");
config_mutationTest;

prob = SMOP1(100, 99, 2, 100);

% Perform mutation
newParent = sparsePolyMutate(Parent, prob);

%% Performance measures

% Raw comparison between parents and children
parentDelta = newParent - Parent;
heatmap(parentDelta);

% Display the deviation between locations that remain non-zero
% nonZeroMask = newParent & Parent;
% histogram(newParent(nonZeroMask));





