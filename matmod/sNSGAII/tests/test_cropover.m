
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

sub = 1; 
slb = 0.5; 

pop = VariedStripedSparseSampler_v2(prob, slb, sub);

original_sparsities = sum(pop.decs == 0,2)/D;

subplot(2,1,1);
histogram(original_sparsities,0.5/0.001);


title(sprintf("%0.2f to %0.2f", slb, sub));


reps = 1000;

resulting_sparsities = ones(reps,2)*-99;

for r = 1:reps

    new_pop = cropover_v2(pop.decs, prob.lower, prob.upper);

    original_sparsities = sum(new_pop == 0,2)/D;
    resulting_sparsities(r,1) = original_sparsities(1);
    resulting_sparsities(r,2) = original_sparsities(2);
    
end

resulting_sparsities = reshape(resulting_sparsities, [], 1);

subplot(2,1,2);

histogram(resulting_sparsities,0.5/0.001);

stddev = std(resulting_sparsities);

lb = mean(resulting_sparsities) - stddev*2;
ub = mean(resulting_sparsities) + stddev*2;
fprintf("Lower bound: %f\n", lb);
fprintf("Upper bound: %f\n", ub);
fprintf("Spread: %f\n", ub - lb);
fprintf("Island count: %f\n", 0.5/(ub - lb));





