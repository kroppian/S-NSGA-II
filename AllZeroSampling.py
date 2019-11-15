from pymoo.model.sampling import Sampling
import numpy as np

class AllZeroSampling(Sampling):

    def _do(self, problem, n_samples, **kwargs):

        X = np.zeros((n_samples, len(problem.xl)))

        return X

