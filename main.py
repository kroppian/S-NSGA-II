from pymoo.optimize import minimize
from pymoo.algorithms.nsga2 import NSGA2
from SparseSampler import SparseSampler
from pymoo.visualization.scatter import Scatter
from pymoo.factory import get_performance_indicator
from tests.zdt_s import *
from Cropover import Cropover
import sys
import numpy as np
from plotting.PlotAttainment import plot_attainment
import matplotlib.pyplot as plt
from random import *
from pymoo.util.nds.non_dominated_sorting import NonDominatedSorting    
import pathlib
import datetime

## Parameters
# either attainmentSurface, sparsity
mode = "attainmentSurface"
#mode = "sparsity"
# ZDT_S[12346]
problem_type = "ZDT_S1"
constraint_on = [True, False, False]
s_sampling_on = [False, True, False]
cropover_on =   [False, False, False]
colors = ["green", "red", "blue"]
labels = ["Constrained", "With Sampling", "Without sampling"]

# For sparsity mode only 
# First value: n_var
# Second value: target sparsity 
#sparsities = [(30, 6), (30, 12), (30, 18), (30, 24)]
sparsities = [(400, a*80) for a in range(40)]

max_run = 20

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

def save_results(history, path=""):

    print("Save results? (y/n)")

    responseInvalid = True

    while responseInvalid:

        answer = input()

        if answer == "y":
            responseInvalid = False
        else: 
            return 

        if responseInvalid:
            print("Try again? (y/n)")
        
    dateTimeObj = datetime.datetime.now()
    timestamp = "%d-%02d-%02d_%02d-%02d-%02d" % (dateTimeObj.year, dateTimeObj.month, dateTimeObj.day, dateTimeObj.hour, dateTimeObj.minute, dateTimeObj.second)
    
    for file_name in history.keys():
        data = history[file_name]

        full_file_path = "%s/%s" % (path, timestamp)
        pathlib.Path(full_file_path).mkdir(parents=True, exist_ok=True)

        print ("Writing to %s" % full_file_path)

        np.savetxt("%s/%s" % (full_file_path, file_name), data, delimiter=",")
    


def attainment_mode():

    # bounds for the chart
    maxx = -100000000000
    maxy = -100000000000
    minx =  100000000000
    miny =  100000000000

    history = {}

    for config in range(len(s_sampling_on)):

        results = []  

        for run in range(max_run):

            seed = seeds[run] 

            
            (problem, target_sparsity) = get_problem(problem_type, n_var=200, target_n=10, constrained=constraint_on[config])

            plt.plot(problem.pareto_front()[:,0], problem.pareto_front()[:,1], color="black", alpha=0.7, linewidth=1)

            cropover = Cropover(eta=15, prob=1.0)

            algorithm = get_algorithm(s_sampling_on[config], cropover_on[config], target_sparsity)
            

            res = minimize(problem,
                           algorithm,
                           ('n_gen', 200))

            file_name = "%s-run%d%s%s%s" % (
                        problem_type, 
                        run,
                        "-constrained" if constraint_on[config] else "",
                        "-ssampled" if s_sampling_on[config] else "",
                        "cropover" if cropover_on[config] else ""
                        )

            history[file_name + "-X.csv"] = res.X
            history[file_name + "-F.csv"] = res.F

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

    save_results(history, path="./results/")


def sparsity_mode():

    # Plot the global optimal pareto front 

    ref_point = np.array([2, 210])

    hvfnc = get_performance_indicator("hv", ref_point=ref_point)

    config_count = len(s_sampling_on)
    #
    #  config 1                   config 2 
    # |<--- run --->|            |<--- run --->|
    # x11 x12 x13 x14   ^        x11 x12 x13 x14   ^
    # x21 x22 x23 x24   |        x21 x22 x23 x24   |
    #       .           sparsity       .           sparsity  ....
    #       .           |              .           |
    # x21 x22 x23 x24   V        x21 x22 x23 x24   V
    #

    #results = np.ones((len(sparsities), max_run, config_count))*-1
    results = np.ones((config_count, len(sparsities), max_run))*-1

    global_opt = -1

    for (sparse_i, (n_var, target_sparsity)) in enumerate(sparsities):

        print("--------------------------------")
        print("| Sparsity: (%d/%d)          " % (target_sparsity, n_var))
        print("--------------------------------")
        for config in range(config_count):

            print("     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
            print("     %% Config: %s" % labels[config])
            print("     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")

            for run in range(max_run):

                print("         ********************************")
                print("         * Run: %d" % run)
                print("         ********************************")
           
                seed = seeds[run] 
                
                (problem, target_sparsity) = get_problem(problem_type, n_var=n_var, target_n=target_sparsity, constrained=constraint_on[config])

                if(global_opt == -1):
                    global_opt = hvfnc.calc(problem.pareto_front())
                    print("         Global opt: %d" % global_opt)

                algorithm = get_algorithm(s_sampling_on[config], cropover_on[config], target_sparsity)

                res = minimize(problem,
                               algorithm,
                               ('n_gen', 200))

                if np.sum(res.F[:,0] > ref_point[0]) != 0:
                    print("Pareto front out of bounds of ref")
                    print("%f greater than %f" % (max(res.F[:,0]), ref_point[0]))
                    sys.exit(1)

                if np.sum(res.F[:,1] > ref_point[1]) != 0:
                    print("%f greater than %f" % (max(res.F[:,1]), ref_point[1]))
                    print("Pareto front out of bounds of ref")
                    sys.exit(1)

                F = res.F
                F = [NonDominatedSorting().do(F)[0]]
    
                # Calc hypervol

                hv = hvfnc.calc(res.F)
               
                results[config, sparse_i, run ] = hv

                print("         Completed run %d" % run)
                print("         Problem: %s" % problem_type)
                print("         Constraings: %s" % constraint_on[config])
                print("         Sparse sampling: %s" % s_sampling_on[config])
                print("         Cropover: %s" % cropover_on[config])

    # plot the global optima HVS
    x = [s[1]/s[0] for s in sparsities]
    y = np.ones(np.shape(x))*global_opt

    plt.plot(x, y, linestyle='-', marker='o' ,color="black",alpha=0.7, linewidth=1)

    for config in range(3):

        x = [s[1]/s[0] for s in sparsities]
        y = np.mean(results[config,:,:], axis=1)

        plt.plot(x, y, linestyle='-', marker='o' ,color=colors[config] ,alpha=0.7, linewidth=1)

    plt.show()

## Main 

seeds = np.genfromtxt('seeds.csv', delimiter=',')

seeds = seeds.astype(int)

if mode == "attainmentSurface":
    attainment_mode()
elif mode == "sparsity":
    sparsity_mode()






