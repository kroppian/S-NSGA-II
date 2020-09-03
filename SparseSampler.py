from pymoo.model.sampling import Sampling
import numpy as np
import random

class SparseSampler(Sampling):

    def __init__(self, n, sampled_mask=[]):
        self.n = n
        self.sampled_mask = sampled_mask

    def _do(self, problem, n_samples, **kwargs):

        X = np.zeros((n_samples, len(problem.xl)))

        for row in range(np.size(X,0)):

            # Where to put the samples 
            indices = random.sample(range(np.shape(X)[1]), self.n)

            # Include any indices that always need to be non-zero
            indices = list(set(indices).union(self.sampled_mask))
            indices = np.array(indices) 

            ranges = problem.xu - problem.xl
            
            indices_len = np.size(indices,0)

            if indices_len == 0:
                # If there's nothing to put it, make sure everything is zeros
                X[row,:] = np.zeros(np.shape(X)[1])
            else:
                # Put those samples in!
                X[row,indices]  = problem.xl[indices] + ranges[indices]*np.random.ranf(indices_len)

        return X


