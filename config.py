import numpy as np

global_config = {}

true_sparsity = 0.85
min_n = 30,
max_n = 500,
divisions = 10

global_config["increaseingDecisionVars"] = {

  # either attainmentSurface, sparsity
  "mode": "sparsityFlux",
  "problem_type" : "ZDT_S1",
  "constraint_on" : [False, False, False],
  "s_sampling_on" : [True, True, False],
  "cropover_on" : [True, False, False],
  "colors" : ["green", "red", "blue"],
  "labels" : ["Cropover", "With Sampling", "Without sampling"],
 
   
  # For sparsity mode only 
  "min_n" : min_n,
  "max_n" : max_n,
  "divisions" : divisions,
  "algorithm_sparsity_upper" : 1,
  "algorithm_sparsity_lower" : 0.51,
  "true_sparsity" : true_sparsity,
  "sparsities" : [
        (int(a), int(a*(1-true_sparsity))) for a in  np.linspace(min_n, max_n, divisions)
    ],
  "max_run" : 10
}

#    ## Parameters
#    # either attainmentSurface, sparsity
#    #mode = "attainmentSurface"
#    mode = "sparsityFlux"
#    #mode = "sparsityFlux"
#    # ZDT_S[12346]
#    problem_type = "ZDT_S1"
#    constraint_on = [False, False, False]
#    s_sampling_on = [True, True, False]
#    cropover_on =   [True, False, False]
#    colors = ["green", "red", "blue"]
#    labels = ["Cropover", "With Sampling", "Without sampling"]
#    
#    # For sparsity mode only 
#    # First value: n_var
#    # Second value: target sparsity 
#    min_n = 30
#    max_n = 500
#    divisions = 10
#    
#    algorithm_sparsity_upper = 1
#    algorithm_sparsity_lower = 0.51
#    true_sparsity = 0.85
#    sparsities = [(int(a), int(a*(1-true_sparsity))) for a in  np.linspace(min_n, max_n, divisions)]
#    
#    max_run = 10

