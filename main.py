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

from config import global_config


## Functions
def get_algorithm(s_sampling_on, cropover_on, target_sparsity):
    if s_sampling_on and cropover_on:
        # Both cropover and s samping
        cropover = Cropover(eta=15, prob=1.0)
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
        cropover = Cropover(eta=15, prob=1.0)
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

        np.save("%s/%s" % (full_file_path, file_name), data)
    


def attainment_mode(config):

    # bounds for the chart
    maxx = -100000000000
    maxy = -100000000000
    minx =  100000000000
    miny =  100000000000


    s_sampling_on = config["s_sampling_on"]
    max_run = config["max_run"]
    problem_type = config["problem_type"]
    attainment_mode = config["constraint_on"]
    cropover_on = config["cropover_on"]
    sparsities = config["sparsities"]
    algorithm_sparsity_lower = config["algorithm_sparsity_lower"]
    algorithm_sparsity_upper = config["algorithm_sparsity_upper"]
    colors = config["colors"]


    history = {}

    for config_no in range(len(s_sampling_on)):

        results = []  

        for run in range(max_run):

            seed = seeds[run] 

            
            (problem, target_sparsity) = get_problem(problem_type, n_var=200, target_n=10, constrained=constraint_on[config_no])

            plt.plot(problem.pareto_front()[:,0], problem.pareto_front()[:,1], color="black", alpha=0.7, linewidth=1)

            cropover = Cropover(eta=15, prob=1.0)

            algorithm = get_algorithm(
                    s_sampling_on[config_no], 
                    cropover_on[config_no], 
                    (n_var*(algorithm_sparsity_lower), 
                    n_var*(algorithm_sparsity_upper)))
            

            res = minimize(problem,
                           algorithm,
                           ('n_gen', 200))

            file_name = "%s-run%d%s%s%s" % (
                        problem_type, 
                        run,
                        "-constrained" if constraint_on[config_no] else "",
                        "-ssampled" if s_sampling_on[config_no] else "",
                        "cropover" if cropover_on[config_no] else ""
                        )

            history[file_name + "-X.npy"] = res.X
            history[file_name + "-F.npy"] = res.F

            if np.size(results) == 0:
                results = res.F
            else:
                results = np.concatenate((results, res.F))

            print("Completed run %d" % run)
            print("Problem: %s" % problem_type)
            print("Constraings: %s" % constraint_on[config_no])
            print("Sparse sampling: %s" % s_sampling_on[config_no])
            print("Cropover: %s" % cropover_on[config_no])

        (new_maxx, new_maxy, new_minx, new_miny) = plot_attainment(results, plt, color=colors[config_no])

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


def sparsity_mode(config):

    # Plot the global optimal pareto front 

    s_sampling_on = config["s_sampling_on"]
    max_run = config["max_run"]
    problem_type = config["problem_type"]
    constraint_on = config["constraint_on"]
    cropover_on = config["cropover_on"]
    sparsities = config["sparsities"]
    labels = config["labels"]
    cropover_on = config["cropover_on"]
    algorithm_sparsity_lower = config["algorithm_sparsity_lower"]
    algorithm_sparsity_upper = config["algorithm_sparsity_upper"]
    colors = config["colors"]
    true_sparsity = config["true_sparsity"]

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

    results = np.ones((config_count, len(sparsities), max_run))*-1

    global_opt = -1

    history = {} 
   

    for (sparse_i, (n_var, target_sparsity)) in enumerate(sparsities):

        print("--------------------------------")
        print("| Sparsity: (%d/%d)          " % (target_sparsity, n_var))
        print("--------------------------------")
        for config_no in range(config_count):

            print("     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
            print("     %% Config: %s" % labels[config_no])
            print("     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")

            for run in range(max_run):

                

                print("         ********************************")
                print("         * Run: %d" % run)
                print("         ********************************")
           
                seed = seeds[run] 
                
                (problem, target_sparsity) = get_problem(problem_type, n_var=n_var, target_n=target_sparsity, constrained=constraint_on[config_no])

                if(global_opt == -1):
                    global_opt = hvfnc.calc(problem.pareto_front())
                    print("         Global opt: %d" % global_opt)

                algorithm = get_algorithm(
                        s_sampling_on[config_no], 
                        cropover_on[config_no], 
                        (int(n_var*(algorithm_sparsity_lower)), 
                        int(n_var*(algorithm_sparsity_upper))))

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

                file_name = "%s-n%d-t%d-run%d%s%s%s" % (
                    problem_type, 
                    n_var, 
                    target_sparsity,
                    run,
                    "-constrained" if constraint_on[config_no] else "",
                    "-ssampled" if s_sampling_on[config_no] else "",
                    "cropover" if cropover_on[config_no] else ""
                    )

                
                history[file_name + "-X.npy"] = res.X
                history[file_name + "-F.npy"] = res.F

                F = res.F
                F = [NonDominatedSorting().do(F)[0]]
    
                # Calc hypervol

                hv = hvfnc.calc(res.F)
               
                results[config_no, sparse_i, run ] = hv

                print("         Completed run %d" % run)
                print("         Problem: %s" % problem_type)
                print("         Constraings: %s" % constraint_on[config_no])
                print("         Sparse sampling: %s" % s_sampling_on[config_no])
                print("         Cropover: %s" % cropover_on[config_no])

    # plot the global optima HVS
    x = [s[0] for s in sparsities]
    y = np.ones(np.shape(x))*global_opt

    plt.plot(x, y, linestyle='-', marker=',' ,color="black",alpha=0.7, linewidth=1)

    for config_no in range(3):

        x = [s[0] for s in sparsities]
        y = np.mean(results[config_no,:,:], axis=1)

        plt.plot(x, y, linestyle='-', marker='o' ,color=colors[config_no] ,alpha=0.7, linewidth=1)

    plt.title("True sparsity %f" % true_sparsity)

    plt.show()
    
    save_results(history, path="./results/")


## Main 

seeds = np.genfromtxt('seeds.csv', delimiter=',')

seeds = seeds.astype(int)

if len(sys.argv) != 2:
    print("Usage %s CONFIG_NAME" % sys.argv[0])
    sys.exit(1) 


config_name = sys.argv[1]

config = global_config[config_name]

if config["mode"] == "attainmentSurface":
    attainment_mode(config)
elif config["mode"] == "sparsityFlux":
    sparsity_mode(config)
    





