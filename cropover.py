from pymoo.algorithms.nsga2 import NSGA2
from pymoo.optimize import minimize
from pymoo.visualization.scatter import Scatter
from CropoverTests import CropoverTests

from pymoo.configuration import Configuration
Configuration.show_compile_hint = False

prob = CropoverTests()

algorithm = NSGA2(pop_size=100, eliminate_duplicates=True)

res = minimize(prob,
               algorithm,
               ('n_gen', 200),
               seed=1,
               verbose=True)

print("Optima with regards to yield: %d" % prob.get_optimal())

plot = Scatter()
plot.add(prob.pareto_front(), plot_type="line", color="black", alpha=0.7)
plot.add(res.F, color="red")
plot.show()


