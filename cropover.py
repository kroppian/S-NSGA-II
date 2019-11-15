from pymoo.algorithms.nsga2 import NSGA2
from pymoo.optimize import minimize
from pymoo.visualization.scatter import Scatter

from pymoo.configuration import Configuration

Configuration.show_compile_hint = False

# Custom stuff 
from CropoverTests import CropoverTests
from AllZeroSampling import AllZeroSampling

prob = CropoverTests()
all_zero = AllZeroSampling()


algorithm = NSGA2(pop_size=100, 
        eliminate_duplicates=True,
        sampling=all_zero)



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


