import autograd.numpy as anp
import numpy as np
from pymoo.util.misc import stack
from pymoo.model.problem import Problem

class CropoverTests(Problem):


    
    def __init__(self):
        self.days = 120
        self.appsCount = 16
        # Generate the days that won't be zero
        self.appDays = np.random.randint(0,self.days,self.appsCount)
        # Generate the optima for each days
        self.optima = np.random.randint(0,99,self.days)

        self.optima = map(lambda x : 0:q
                )

        super().__init__(n_var=self.days,
                         n_obj=2,
                         n_constr=0,
                         xl=anp.array([-2,-2]),
                         xu=anp.array([2,2]))
        
         
            



    def _evaluate(self, x, out, *args, **kwargs):
        f1 = x[:,0]**2 + x[:,1]**2
        f2 = (x[:,0]-1)**2 + x[:,1]**2

    
        


        out["F"] = anp.column_stack([f1, f2])
        out["G"] = anp.column_stack([g1, g2])


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

problem = MyProblem()


