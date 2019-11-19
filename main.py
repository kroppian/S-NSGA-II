from pymoo.algorithms.nsga2 import NSGA2
from pymoo.optimize import minimize
from pymoo.visualization.scatter import Scatter
import numpy as np
from pymoo.configuration import Configuration
from datetime import datetime
import os

Configuration.show_compile_hint = False

# Custom stuff 
from CropoverTests import CropoverTests
from SparseSampler import SparseSampler
from Cropover import Cropover

max_run = 100

dateTimeObj = datetime.now()
timestamp = "%d-%02d-%02d_%02d-%02d-%02d" % (dateTimeObj.year, dateTimeObj.month, dateTimeObj.day, dateTimeObj.hour, dateTimeObj.minute, dateTimeObj.second)


for run in range(max_run):

    prob = CropoverTests()
    s_sampler = SparseSampler(16)
    cropover = Cropover(eta=30, prob=1.0)

    algorithm = NSGA2(pop_size=100, 
            eliminate_duplicates=True,
            sampling=s_sampler)#,
            #crossover=cropover)

    res = minimize(prob,
                   algorithm,
                   ('n_gen', 200),
                   seed=1,
                   verbose=True)

    print("Optima with regards to yield: %d" % prob.get_optimal())

    paretoFront = res.F
    paretoFront[:,1] = paretoFront[:,1]*-1
    
    dir_name = "results/%s" % timestamp
    if not os.path.exists(dir_name):
        os.mkdir(dir_name)

    np.savetxt("%s/without_run%04d.csv" % (dir_name,run), paretoFront, delimiter=",")


for run in range(max_run):

    prob = CropoverTests()
    s_sampler = SparseSampler(16)
    cropover = Cropover(eta=30, prob=1.0)

    algorithm = NSGA2(pop_size=100, 
            eliminate_duplicates=True,
            sampling=s_sampler,
            crossover=cropover)

    res = minimize(prob,
                   algorithm,
                   ('n_gen', 200),
                   seed=1,
                   verbose=True)

    print("Optima with regards to yield: %d" % prob.get_optimal())

    paretoFront = res.F
    paretoFront[:,1] = paretoFront[:,1]*-1
    
    dir_name = "results/%s" % timestamp

    if not os.path.exists(dir_name):
        os.mkdir(dir_name)

    np.savetxt("%s/with_run%04d.csv" % (dir_name,run), paretoFront, delimiter=",")









