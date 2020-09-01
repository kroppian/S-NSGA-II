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
from random import *

## Parameters
# either attainmentSurface, sparsity
mode = "attainmentSurface"
# ZDT_S[12346]
problem_type = "ZDT_S1"
constraint_on = [True, False, False]
s_sampling_on = [False, True, False]
cropover_on = [False, False, False]
colors = ["green", "red", "blue"]
labels = ["Constrained", "With Sampling", "Without sampling"]

# For sparsity mode only 
sparsities = [()]

max_run = 5

## Functions


def get_algorithm(s_sampling_on, cropover_on, target_sparsity):

    if s_sampling_on and cropover_on:
        # Both cropover and s samping
        s_sampler = SparseSampler(target_sparsity)
        algorithm = NSGA2(
                seed=seed,
                pop_size=100, 
                crossover=cropover,
                sampling=s_sampler)
    elif s_sampling_on and not cropover_on: 
        # Just s samping
        s_sampler = SparseSampler(target_sparsity)
        algorithm = NSGA2(
                pop_size=100, 
                sampling=s_sampler)
    elif not s_sampling_on and cropover_on: 
        # Just cropover 
        algorithm = NSGA2(
                pop_size=100, 
                crossover=cropover)
    else:
        # Neither
        algorithm = NSGA2(pop_size=100)

    return algorithm

def attainment_mode():

    # bounds for the chart
    maxx = -100000000000
    maxy = -100000000000
    minx =  100000000000
    miny =  100000000000

    for config in range(len(s_sampling_on)):

        results = []  

        for run in range(max_run):

            seed = seeds[run] 

            (problem, target_sparsity) = get_problem(problem_type)

            plt.plot(problem.pareto_front()[:,0], problem.pareto_front()[:,1], color="black", alpha=0.7, linewidth=1)

            cropover = Cropover(eta=15, prob=1.0)

            algorithm = get_algorithm(s_sampling_on[config], cropover_on[config], target_sparsity)
            

            res = minimize(problem,
                           algorithm,
                           ('n_gen', 200))

            if np.size(results) == 0:
                results = res.F
            else:
                results = np.concatenate((results, res.F))

            print("Completed run %d" % run)

            print("Problem: %s" % problem_type)
            print("Constraings: %s" % constraint_on[config])
            print("Sparse sampling: %s" % s_sampling_on[config])
            print("Cropover: %s" % cropover_on[config])

        (new_maxx, new_maxy, new_minx, new_miny) = plot_attainment(results, plt, color=colors[config])

        maxx = max((maxx, new_maxx))   
        maxy = max((maxy, new_maxy))   
        minx = min((minx, new_minx))   
        miny = min((miny, new_miny))   


    plt.title(problem_type)

    plt.xlim((minx, maxx))
    plt.ylim((miny, maxy))
    plt.xlabel("f1")
    plt.ylabel("f2")

    plt.show()

def sparsity_mode():
    return 42      


## Main 

seeds = np.genfromtxt('seeds.csv', delimiter=',')

seeds = seeds.astype(int)

if mode == "attainmentSurface":
    attainment_mode()
elif mode == "sparsity":
    sparsity_mode()


