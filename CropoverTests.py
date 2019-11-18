import autograd.numpy as anp
import numpy as np
from pymoo.util.misc import stack
from pymoo.model.problem import Problem

class CropoverTests(Problem):

    def __init__(self):
        self.fit_min = 1
        self.fit_max = 100

        self.height_min = 1
        self.height_max = 300

        self.days = 120
        self.appCount = 16
    
        # All optima will be zeros, except...
        self.optima = np.zeros((1,self.days))

        # Find the day indices that will be non-zero
        self.appDays = np.random.randint(0,self.days-1,self.appCount)

        # Fill in those days
        self.optima[0,list(self.appDays)] = np.random.randint(  
                    self.fit_min, 
                    self.fit_max,
                    len(self.appDays))

        # Give those peaks to optimize heights
        self.heights = np.copy(self.optima)
        self.heights[0,list(self.appDays)] = np.random.randint(
                    self.height_min, 
                    self.height_max,     
                    len(self.appDays))

        # Limits
        self.fit_l = np.zeros(self.days)
        self.fit_u = np.ones(self.days)*self.fit_max

        super().__init__(n_var=self.days,
                         n_obj=2,
                         n_constr=0,
                         xl=self.fit_l,
                         xu=self.fit_u)


    def _evaluate(self, x, out, *args, **kwargs):
  
        f1 = np.sum(x, axis=1)
        
        f_ind = -np.power(x - self.optima, 2) + self.heights

        f2 = np.sum(f_ind, axis=1)

        out["F"] = anp.column_stack([f1, f2])

    def get_optimal(self):
        return np.sum(self.heights)


crossovertests = CropoverTests()


