
clear;

addpath("..");
addpath("../..");
addpath("../../configs");
addpath("../../utilities");

sNSGA_eff_400;

D = 100;
prob = SMOP1('N', 100, 'D', D, 'FE', 200, 'maxFE', 20000, 'parameter', {0.15});
% No clue why this is needed, but taken from ALGORITHM.Solve
prob.Current(prob);

pop = VariedStripedSparseSampler_v2(prob, 0.75, 1);

pop_genes = pop.decs;

nz_mask = pop_genes ~= 0;

nz_map = zeros(size(nz_mask));
nz_map(nz_mask) = 1; 

heatmap(nz_map);
figure;
bar(sum(nz_map));


sparsities = sum(pop_genes == 0,2)/D;
% figure;
% histogram(sparsities, 100);

figure;
scatter(linspace(0.75,1,numel(sparsities)), sparsities);
hold on
plot(linspace(0.75,1,numel(sparsities)),linspace(0.75,1,numel(sparsities)));
