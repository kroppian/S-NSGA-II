from pymoo.model.sampling import Sampling
import numpy as np
import random

class SparseSampler(Sampling):

    def __init__(self, sparse_span, sampled_mask=[]):
        if type(sparse_span) != int and type(sparse_span) != tuple:
            raise TypeError("Sparse Sampler takes a single integer or a tuple of two values")

        if type(sparse_span) == tuple and len(sparse_span) != 2:
            raise ValueError("Span should be a tuple of two values")

        self.sparse_span = sparse_span
        self.sampled_mask = sampled_mask

    def _do(self, problem, n_samples, **kwargs):

        n_var = len(problem.xl)

        X = np.zeros((n_samples, n_var))

        for row in range(np.size(X,0)):

            if type(self.sparse_span) == int:
                number_of_samples = calc_density(self.sparse_span, n_var)
            else: 
                # We flip the sparsities because upper limit to density is lower limit to sparsity and vise-versa
                number_of_samples = random.randint(
                        self.calc_density(self.sparse_span[1], n_var), 
                        self.calc_density(self.sparse_span[0], n_var))

            # Where to put the samples 
            indices = random.sample(range(np.shape(X)[1]), number_of_samples)

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

    @staticmethod
    def calc_density(val, n_var):
        return n_var - val

