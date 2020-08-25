from pymoo.optimize import minimize
from pymoo.algorithms.nsga2 import NSGA2
from SparseSampler import SparseSampler
from pymoo.visualization.scatter import Scatter
from tests.zdt1mod import ZDT_S1

problem = ZDT_S1(n_var=30, target_n=12)

s_sampler = SparseSampler(12)

algorithm = NSGA2(pop_size=100, sampling=s_sampler)
#algorithm = NSGA2(pop_size=100)


res = minimize(problem,
               algorithm,
               ('n_gen', 200),
               verbose=True)

plot = Scatter()
plot.add(problem.pareto_front(), plot_type="line", color="black", alpha=0.7)
plot.add(res.F, color="red")
plot.show()


