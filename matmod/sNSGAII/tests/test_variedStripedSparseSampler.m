
clear;

addpath("..");
addpath("../..");
addpath("../../configs");
addpath("../../utilities");

sNSGA_eff_400;


D = 1000;
ub = 1 - (1/D);
lb = 1 - (1/4);


prob = SMOP1('N', 100, 'D', D, 'FE', 200, 'maxFE', 20000, 'parameter', {0.15});
% No clue why this is needed, but taken from ALGORITHM.Solve
prob.Current(prob);

pop = VariedStripedSparseSampler_v3(prob, lb, ub);

pop_genes = pop.decs;

nz_mask = pop_genes ~= 0;

nz_map = zeros(size(nz_mask));
nz_map(nz_mask) = 1; 

heatmap(nz_map);

figure;
bar(sum(nz_map));
xlabel("Genome position");
ylabel("Frequency");


fontsize(gca,18,"pixels")
fontname(gca, "Cambria Math")

sparsities = sum(pop_genes == 0,2)/D;
% figure;
% histogram(sparsities, 100);

figure;
scatter(linspace(1-lb, 1-ub,numel(sparsities)), 1-sparsities);
hold on
plot(linspace(1-lb, 1-ub,numel(sparsities)),linspace(1-lb, 1-ub,numel(sparsities)));

xlabel('Target sparsity (θ)');
ylabel('Actual sparsity (θ)');

fontsize(gca,18,"pixels")
fontname(gca, "Cambria Math")

