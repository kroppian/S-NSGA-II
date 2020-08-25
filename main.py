from pymoo.optimize import minimize
from pymoo.algorithms.nsga2 import NSGA2
from SparseSampler import SparseSampler
from pymoo.visualization.scatter import Scatter
from tests.zdt_s import ZDT_S2, ZDT_S1

problem_type = "ZDT_S1"

sampling = "sparse"

if problem_type == "ZDT_S1":
    problem = ZDT_S1(n_var=30, target_n=12)
elif problem_type == "ZDT_S2":
    problem = ZDT_S2(n_var=30, target_n=12)
else: 
    print("Invalid option")
    sys.exit(1)

if sampling == "sparse":
    s_sampler = SparseSampler(12)
    algorithm = NSGA2(pop_size=100, sampling=s_sampler)
else:
    algorithm = NSGA2(pop_size=100)


res = minimize(problem,
               algorithm,
               ('n_gen', 200),
               verbose=True)

plot = Scatter()
plot.add(problem.pareto_front(), plot_type="line", color="black", alpha=0.7)
plot.add(res.F, color="red")
plot.show()


