from pymoo.optimize import minimize
from pymoo.algorithms.nsga2 import NSGA2
from SparseSampler import SparseSampler
from pymoo.visualization.scatter import Scatter
from tests.zdt_s import *
from Cropover import Cropover
import sys
import numpy as np
from plotting.PlotAttainment import plot_attainment
import matplotlib.pyplot as plt

# Parameters
problem_type = "ZDT_S1"
s_sampling_on = [True, False]
cropover_on = [False, False]
colors = ["green", "red"]
labels = ["With Sampling", "Without sampling"]
# TODO size constraint

max_run = 200

seeds = np.genfromtxt('seeds.csv', delimiter=',')

seeds = seeds.astype(int)

maxx = -100000000000
maxy = -100000000000
minx =  100000000000
miny =  100000000000

for config in range(len(s_sampling_on)):

    results = []  

    for run in range(max_run):

        seed = seeds[run] 

        if problem_type == "ZDT_S1":
            target_sparsity=12
            problem = ZDT_S1(n_var=30, target_n=target_sparsity)
        elif problem_type == "ZDT_S2":
            target_sparsity=12
            problem = ZDT_S2(n_var=30, target_n=target_sparsity)
        elif problem_type == "ZDT_S3":
            target_sparsity=12
            problem = ZDT_S3(n_var=30, target_n=target_sparsity)
        elif problem_type == "ZDT_S4":
            target_sparsity=3
            problem = ZDT_S4(n_var=10, target_n=target_sparsity)
        elif problem_type == "ZDT_S6":
            target_sparsity=2
            problem = ZDT_S6(n_var=10, target_n=target_sparsity)
        else: 
            print("Invalid option")
            sys.exit(1)

        plt.plot(problem.pareto_front()[:,0], problem.pareto_front()[:,1], color="black", alpha=0.7, linewidth=1)

        cropover = Cropover(eta=15, prob=1.0)

        if s_sampling_on[config] and cropover_on[config]:
            # Both cropover and s samping
            s_sampler = SparseSampler(target_sparsity)
            algorithm = NSGA2(
                    seed=seed,
                    pop_size=100, 
                    crossover=cropover,
                    sampling=s_sampler)
        elif s_sampling_on[config] and not cropover_on[config]: 
            # Just s samping
            s_sampler = SparseSampler(target_sparsity)
            algorithm = NSGA2(
                    pop_size=100, 
                    sampling=s_sampler)
        elif not s_sampling_on[config] and cropover_on[config]: 
            # Just cropover 
            algorithm = NSGA2(
                    pop_size=100, 
                    crossover=cropover)
        else:
            # Neither
            algorithm = NSGA2(pop_size=100)

        res = minimize(problem,
                       algorithm,
                       ('n_gen', 200))

        if np.size(results) == 0:
            results = res.F
        else:
            results = np.concatenate((results, res.F))

        print("Completed run %d" % run)

        print("Problem: %s" % problem_type)
        print("Sparse sampling: %s" % s_sampling_on[config])
        print("Cropover: %s" % cropover_on[config])

    (new_maxx, new_maxy, new_minx, new_miny) = plot_attainment(results, plt, color=colors[config])
    maxx = max((maxx, new_maxx))   
    maxy = max((maxy, new_maxy))   
    minx = min((minx, new_minx))   
    miny = min((miny, new_miny))   


plt.title(problem_type)

print((minx, maxx))
print((miny, maxy))

plt.xlim((minx, maxx))
plt.ylim((miny, maxy))

plt.show()

