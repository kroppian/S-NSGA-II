
load("testData.mat");
addpath("..");

prob = SMOP1(100, 99, 2, 100);

newParent = sparsePolyMutate(Parent, prob);

parentDelta = newParent - Parent;

heatmap(parentDelta);

