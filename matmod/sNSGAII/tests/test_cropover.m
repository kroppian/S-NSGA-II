
clear;

addpath("..");
addpath("../..");
addpath("../../configs");
addpath("../../utilities");

%sNSGA_eff_decVar;
sNSGA_eff_400

D = 100;
prob = SMOP1('N', 100, 'D', D, 'FE', 200,'maxFE', 20000, 'parameter', {0.15});
% No clue why this is needed, but taken from ALGORITHM.Solve
prob.Current(prob);

pop = sparseSampler(prob, 0.75, 0.75);

sparsities = sum(pop.decs == 0,2)/D;
sparsity1 = sparsities(1);
sparsity2 = sparsities(2);

reps = 1000;

resulting_sparsities = ones(reps,2)*-99;

for r = 1:reps

    new_pop = cropover_v2(pop.decs, prob.lower, prob.upper);

    sparsities = sum(new_pop == 0,2)/D;
    resulting_sparsities(r,1) = sparsities(1);
    resulting_sparsities(r,2) = sparsities(2);
    
    if mod(r,100) == 0
        fprintf("%d\n", r);
    end
    
end

histogram(resulting_sparsities,20);
