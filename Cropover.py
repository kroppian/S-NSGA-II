from pymoo.model.crossover import Crossover
from pymoo.operators.crossover.simulated_binary_crossover import SimulatedBinaryCrossover

import numpy as np

class Cropover(Crossover):
    def __init__(self, eta, prob_per_variable=0.5, **kwargs):
        # define the crossover: number of parents and number of offsprings
        super().__init__(2, 2)
        self.eta = float(eta)
        self.prob_per_variable = prob_per_variable
        self.sbx = SimulatedBinaryCrossover(eta, prob_per_variable, **kwargs)

    def _do(self, problem, X, **kwargs):

        # 
        # zero & non-zero       -> non-zero
        # zero & zero           -> zero
        # non-zero & non-zero   -> SBX
        # 

        # The input of has the following shape (n_parents, n_matings, n_var)
        _, n_matings, n_var = X.shape

        # The output owith the shape (n_offsprings, n_matings, n_var)
        # Because there the number of parents and offsprings are equal it keeps the shape of X
        Y = np.full_like(X, None, dtype=np.object)

        # for each mating provided
        for k in range(n_matings):

            # get the first and the second parent
            p1, p2 = X[0, k, :], X[1, k, :]

            # Use xor to find all the zero & non-zero
            mis_matches = np.logical_xor(p1, p2)           
    
            # Then set both parents to the sum of the two parents
            p1 = np.copy(p1)
            p2 = np.copy(p2)

            if np.random.random() < 0.5:
                p1[mis_matches], p2[mis_matches] = [p1[mis_matches] + p2[mis_matches]] * 2
            else:
                p1[mis_matches], p2[mis_matches] = [p1[mis_matches] * p2[mis_matches]] * 2
                


            # No need for anything for zero and zero 


            # join the character list and set the output
            Y[0, k, :], Y[1, k, :] = p1, p2

        # Run SBX on the two newly modified set of parents
        return self.sbx._do(problem, Y)



