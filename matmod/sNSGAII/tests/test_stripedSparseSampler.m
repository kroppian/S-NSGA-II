
clear;

addpath("..");
addpath("../..");
addpath("../../configs");
addpath("../../utilities");


cropoverTest_comp;

prob = SMOP1(100, 99, 2, 100);


pop = stripedSparseSampler(prob, 0.50, 1);

pop_genes = pop.decs;

