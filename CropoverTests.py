import autograd.numpy as anp
import numpy as np
from pymoo.util.misc import stack
from pymoo.model.problem import Problem

class CropoverTests(Problem):

    def __init__(self):
        self.fit_min = 1
        self.fit_max = 100

        self.days = 120
        self.appCount = 16
    
        # All optima will be zeros, except...
        self.optima = np.zeros(self.days)

        # The few days that will non-zero
        self.appDays = np.random.randint(0,self.days-1,self.appCount)

        # Fill in those days
        self.optima[self.appDays] = np.random.randint(self.fit_min, self.fit_max ,len(self.appDays))

        # Limits
        self.fit_l = np.zeros(self.days)
        self.fit_u = np.ones(self.days)*self.fit_max

        super().__init__(n_var=self.days,
                         n_obj=2,
                         n_constr=0,
                         xl=self.fit_l,
                         xu=self.fit_u)

    def foo(bar):
        return bar

    def _evaluate(self, x, out, *args, **kwargs):
  
        f1 = np.sum(x, axis=1)
        
        f_ind = np.power(x + self.optima, 2)

        f2 = np.sum(f_ind, axis=1)

        out["F"] = anp.column_stack([f1, f2])

    def get_optimal(self):
        return sum(self.optima)


    # --------------------------------------------------
    # Pareto-front - not necessary but used for plotting
    # --------------------------------------------------
#   def _calc_pareto_front(self, flatten=True, **kwargs):
#       f1_a = np.linspace(0.1**2, 0.4**2, 100)
#       f2_a = (np.sqrt(f1_a) - 1)**2
#
#       f1_b = np.linspace(0.6**2, 0.9**2, 100)
#       f2_b = (np.sqrt(f1_b) - 1)**2
#
#       a, b = np.column_stack([f1_a, f2_a]), np.column_stack([f1_b, f2_b])
#       return stack(a, b, flatten=flatten)

    # --------------------------------------------------
    # Pareto-set - not necessary but used for plotting
    # --------------------------------------------------
#    def _calc_pareto_set(self, flatten=True, **kwargs):
#        x1_a = np.linspace(0.1, 0.4, 50)
#        x1_b = np.linspace(0.6, 0.9, 50)
#        x2 = np.zeros(50)
#
#        a, b = np.column_stack([x1_a, x2]), np.column_stack([x1_b, x2])
#        return stack(a,b, flatten=flatten)

crossovertests = CropoverTests()


