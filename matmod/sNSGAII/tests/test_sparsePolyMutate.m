


load("testData.mat");
addpath("..");

%fakeDelta = rand(100,100);

newParent = sparsePolyMutate(Parent);

parentDelta = newParent - Parent;

heatmap(parentDelta);