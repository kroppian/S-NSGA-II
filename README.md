# Large-scale Sparse Multi-Objective Optimization Research 


## Python module (mostly Cropover algorithms)

* `pymod/main.py`: the main class where the simulations are started
* `pymod/Cropover.py`: the class for the crossover function
* `pymod/CropoverTest.py`: the class that holds the objective function and the problem generator
* `pymod/plotRuns.r`: script for plotting results
* `pymod/SparseSampler.py`: Population initialization sampler. 


## Matlab module (mostly sparse population algorithms)

* `matmod/calcOptimalHVs.m`: Calculates the optimal hyper volumes for different 
    reference points for SMOP[1-8] eawef
* `matmod/CalHV.m`: not my code. Forked from PlatEMO, but modified slight for this 
    project
* `matmod/GLOBAL_SPS.m`: Extened version of the Global class in PlatEMO that includes 
    information on the final population of the optimization
* `matmod/main.m`: Main optimization routine for a certain run type (effective or 
    comparative), independent variable (# decision variable or sparsity) and test problem (SMOP[1-8])
* `matmod/main_plotting.m`: for a given run, plots the different performance metrics 
    over the independent varible of the runs (# number of decision variables or sparsities)
* `matmod/main_tables.m`: compiles related runs into a single table. Runs are either
    comparative + decision variables, comparative + sparsity, effective +
    sparsity, effective + decision variables. Its result will be referred to as
    a results table
* `matmod/main_print_dists.m`: Takes a results table and prints distribution of the
    metrics for those runs
* `matmod/main_repetition_summary.m`
* `matmod/main_significance_tests.m`: Takes a results table and runs significant 
*   testing between SparseEA and NSGA-II/SPS, or with vs without SPS
* `matmod/main_testProb_summary.m`: Makes statistical summary table of the runs
* `matmod/nop.m`: Needed for the global object for some reason.
* `matmod/quickDemo_2020_10_01.m`: quick script comparing NSGA-II/SPS and SparseEA
* `matmod/runOpt.m`: Wrapper for optimization routine.
* `matmod/sparseSampler.m`: Sparse sampler source

## Data 

The data is available from two locations:

* `data/Gilgamesh/kroppian/spsRuns` on NAS
* `/mnt/nas/kroppian/spsRuns` on Gilgamesh
