
% Define problem
load("testDataSPM.mat");
addpath("..");
addpath("../..");
addpath("../../configs");

sNSGA_eff_400;

prob = SMOP1(100, 99, 2, 100);
prob.Current(prob);

% Perform mutation
newParent = sparsePolyMutate(Parent, prob.upper, prob.lower);

%% Performance measures

% Raw comparison between parents and children

genomeChanged = xor((newParent ~= 0), Parent ~= 0);

genomeNowNz = genomeChanged & ( newParent & 1);
genomeNowZ  = genomeChanged & (~newParent & 1);

blank = zeros(size(genomeNowNz));
blank(genomeNowNz) = 1;
genomeNowNz = blank;

blank = zeros(size(genomeNowZ));
blank(genomeNowZ) = 1; 
genomeNowZ = blank; 

subplot(2,1,1)

heatmap(genomeNowNz);
title("Now non-zero");

subplot(2,1,2)

heatmap(genomeNowZ);
title("Now zero");