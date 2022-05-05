
clear;

addpath("..");
addpath("../..");
addpath("../../configs");
addpath("../../utilities");

sNSGA_eff_400;

D = 50;
prob = SMOP1('N', 100, 'D', D, 'FE', 200, 'maxFE', 20000, 'parameter', {0.15});
% No clue why this is needed, but taken from ALGORITHM.Solve
prob.Current(prob);

pop = VariedStripedSparseSampler(prob, 0.50, 1);

pop_genes = pop.decs;

