from pymoo.model.sampling import Sampling
import numpy as np

class SparseSampler(Sampling):

    def __init__(self, n):
        self.n = n

    def _do(self, problem, n_samples, **kwargs):

        X = np.zeros((n_samples, len(problem.xl)))

        for row in range(np.size(X,0)):

            # Where to put the samples 
            indices = np.random.randint(0, len(X), self.n)

            ranges = problem.xu - problem.xl

            # Put those samples in!
            X[row,indices]  = problem.xl[indices] + ranges[indices]*np.random.ranf(self.n)

        return X

