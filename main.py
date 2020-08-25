from pymoo.optimize import minimize
from pymoo.algorithms.nsga2 import NSGA2
from SparseSampler import SparseSampler
from pymoo.visualization.scatter import Scatter
from tests.zdt_s import ZDT_S2, ZDT_S1
from Cropover import Cropover

problem_type = "ZDT_S2"
s_sampling_on = False
cropover_on = False

if problem_type == "ZDT_S1":
    problem = ZDT_S1(n_var=30, target_n=12)
elif problem_type == "ZDT_S2":
    problem = ZDT_S2(n_var=30, target_n=12)
else: 
    print("Invalid option")
    sys.exit(1)

cropover = Cropover(eta=30, prob=1.0)

if s_sampling_on and cropover_on:
    # Both cropover and s samping
    s_sampler = SparseSampler(12)
    algorithm = NSGA2(
            pop_size=100, 
            crossover=cropover,
            sampling=s_sampler)
elif s_sampling_on and not cropover_on: 
    # Just s samping
    s_sampler = SparseSampler(12)
    algorithm = NSGA2(
            pop_size=100, 
            sampling=s_sampler)
elif not s_sampling_on and cropover_on: 
    # Just cropover 
    algorithm = NSGA2(
            pop_size=100, 
            crossover=cropover)
else:
    # Neither
    algorithm = NSGA2(pop_size=100)

res = minimize(problem,
               algorithm,
               ('n_gen', 200),
               verbose=True)


print("Problem: %s" % problem_type)
print("Sparse sampling: %s" % s_sampling_on)
print("Cropover: %s" % cropover_on)


plot = Scatter()
plot.add(problem.pareto_front(), plot_type="line", color="black", alpha=0.7)
plot.add(res.F, color="red")
plot.show()


