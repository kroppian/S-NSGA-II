from pymoo.optimize import minimize
from pymoo.algorithms.nsga2 import NSGA2
from SparseSampler import SparseSampler
from pymoo.visualization.scatter import Scatter
from tests.zdt_s import *
from Cropover import Cropover
import sys
from numpy import genfromtxt
from plotting.PlotAttainment import plot_attainment
import matplotlib.pyplot as plt

# Parameters
problem_type = "ZDT_S1"
s_sampling_on = [True, False]
cropover_on = [False, False]
colors = ["green", "red"]
labels = ["With Sampling", "Without sampling"]
# TODO size constraint

max_run = 20

seeds = genfromtxt('seeds.csv', delimiter=',')

seeds = seeds.astype(int)

for config in range(len(s_sampling_on)):

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

        plot_attainment(res.F, plt, color=colors[config]) 

        print("Completed run %d" % run)

        print("Problem: %s" % problem_type)
        print("Sparse sampling: %s" % s_sampling_on[config])
        print("Cropover: %s" % cropover_on[config])


#plot.add(problem.pareto_front(), plot_type="line", color="black", alpha=0.7)

plt.show()

