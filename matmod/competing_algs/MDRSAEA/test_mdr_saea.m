
clear;

addpath("..");
addpath("../..");
addpath("../../configs");
addpath("../../utilities");

sNSGA_eff_400;

D = 1000;
theta = 0.01; 
N = 100;   % Doesn't matter
M = 2; 

prob = SMOP2('N', N, 'D', D, 'FE', 200, 'maxFE', 20000, 'parameter', {theta});
% No clue why this is needed, but taken from ALGORITHM.Solve
prob.Current(prob);


runMDRSAEA(prob, theta);

