# Cropover/SPS

Originally a project to develop the cropover algorithm, this project has
morphed into a project to measure the performance of Sparse Population Sampling.

## Files for Cropover

* `main.py`: the main class where the simulations are started
* `Cropover.py`: the class for the crossover function
* `CropoverTest.py`: the class that holds the objective function and the problem generator
* `plotRuns.r`: script for plotting results
* `SparseSampler.py`: Population initialization sampler. Not used in final project


## Files for sparse population sampling

* `calcOptimalHVs.m`: Calculates the optimal hyper volumes for different 
    reference points for SMOP[1-8] eawef
* `CalHV.m`: not my code. Forked from PlatEMO, but modified slight for this 
    project
* `GLOBAL_SPS.m`: Extened version of the Global class in PlatEMO that includes 
    information on the final population of the optimization
* `main.m`: Main optimization routine for a certain run type (effective or 
    comparative), independent variable (# decision variable or sparsity) and test problem (SMOP[1-8])
* `main_plotting.m`: for a given run, plots the different performance metrics 
    over the independent varible of the runs (# number of decision variables or sparsities)
* `main_tables.m`: compiles related runs into a single table. Runs are either
    comparative + decision variables, comparative + sparsity, effective +
    sparsity, effective + decision variables. Its result will be referred to as
    a results table
* `main_print_dists.m`: Takes a results table and prints distribution of the
    metrics for those runs
* `main_repetition_summary.m`
* `main_significance_tests.m`: Takes a results table and runs significant 
*   testing between SparseEA and NSGA-II/SPS, or with vs without SPS
* `main_testProb_summary.m`: Makes statistical summary table of the runs
* `nop.m`: Needed for the global object for some reason.
* `quickDemo_2020_10_01.m`: quick script comparing NSGA-II/SPS and SparseEA
* `runOpt.m`: Wrapper for optimization routine.
* `sparseSampler.m`: Sparse sampler source
