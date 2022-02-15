import autograd.numpy as anp
from pymop.problem import Problem
import sys
from random import randint

def get_problem(problem_type, n_var=-1, target_n=-1, constrained=False):


    if(n_var < target_n):
        print("Error: number of variables (%d) is smaller than the target n (%d)" % (n_var, target_n))
        sys.exit(1)

    # Default values
    defaults = {
        "ZDT_S1": { "n_var" : 30, "target_n" : 15},
        "ZDT_S2": { "n_var" : 30, "target_n" : 12},
        "ZDT_S3": { "n_var" : 30, "target_n" : 12},
        "ZDT_S4": { "n_var" : 10, "target_n" : 3},
        "ZDT_S6": { "n_var" : 10, "target_n" : 2} 
    }

    if n_var == -1: 
        n_var = defaults[problem_type]["n_var"]
       
    if target_n == -1:
        target_n = defaults[problem_type]["target_n"]

    if problem_type == "ZDT_S1":
        problem = ZDT_S1(n_var=n_var, target_n=target_n, constrained=constrained)
    elif problem_type == "ZDT_S2":
        problem = ZDT_S2(n_var=n_var, target_n=target_n, constrained=constrained)
    elif problem_type == "ZDT_S3":
        problem = ZDT_S3(n_var=n_var, target_n=target_n, constrained=constrained)
    elif problem_type == "ZDT_S4":
        problem = ZDT_S4(n_var=n_var, target_n=target_n, constrained=constrained)
    elif problem_type == "ZDT_S6":
        problem = ZDT_S6(n_var=n_var, target_n=target_n, constrained=constrained)
    else: 
        print("Invalid option")
        sys.exit(1)

    return (problem, target_n)

class ZDT(Problem):

    def __init__(self, n_var=30, **kwargs):
        super().__init__(n_var=n_var, n_obj=2, n_constr=0, xl=0, xu=1, type_var=anp.double, **kwargs)

class ZDT_S(ZDT):

    @staticmethod
    def sparse_penalty(x, target_n): 

        non_zs = anp.sum(x != 0, 1) 

        penalty = anp.abs(non_zs - target_n)

        d = 9

        return d*(penalty/anp.size(x))

    def __init__(self, n_var=30, target_n=30, constrained=False, **kwargs):
        self.target_n = target_n
        self.constrained = constrained
        lower = 1
        upper = n_var  -1
        self.nzs_locales = [randint(lower, upper) for a in range(target_n)]
        self.zs_locales = list(filter(
                (lambda a : a not in self.nzs_locales), range(lower, upper+1)
            ))
        super().__init__(n_var=n_var)

class ZDT_S1(ZDT_S):

    def _calc_pareto_front(self, n_pareto_points=100):
        x = anp.linspace(0, 1, n_pareto_points)
        return anp.array([x, 1 - anp.sqrt(x)]).T

    def _evaluate(self, x, out, *args, **kwargs):

        f1 = x[:, 0]

        g_nzs = 9.0 / (self.n_var - 1) * anp.sum(anp.abs(x[:, self.nzs_locales] - 0.5), axis=1)
        g_zs  = 9.0 / (self.n_var - 1) * anp.sum(x[:, self.zs_locales], axis=1) 
        g = 1 + g_nzs + g_zs

        f2 = g * (1 - anp.power((f1 / g), 0.5))

        if self.constrained: 
            out["G"] = self.sparse_penalty(x[:, 1:], self.target_n)

        out["F"] = anp.column_stack([f1, f2])

class ZDT_S2(ZDT_S):

    def _calc_pareto_front(self, n_pareto_points=100):
        x = anp.linspace(0, 1, n_pareto_points)
        return anp.array([x, 1 - anp.power(x, 2)]).T

    def _evaluate(self, x, out, *args, **kwargs):
        f1 = x[:, 0]
        c = anp.sum(x[:, 1:], axis=1)
        g = 1.0 + 9.0 * c / (self.n_var - 1)
        g += self.sparse_penalty(x[:, 1:], self.target_n)
        f2 = g * (1 - anp.power((f1 * 1.0 / g), 2))

        if self.constrained: 
            out["G"] = self.sparse_penalty(x[:, 1:], self.target_n)


        out["F"] = anp.column_stack([f1, f2])


class ZDT_S3(ZDT_S):

    def _calc_pareto_front(self, n_pareto_points=100):
        regions = [[0, 0.0830015349],
                   [0.182228780, 0.2577623634],
                   [0.4093136748, 0.4538821041],
                   [0.6183967944, 0.6525117038],
                   [0.8233317983, 0.8518328654]]

        pareto_front = anp.array([]).reshape((-1, 2))
        for r in regions:
            x1 = anp.linspace(r[0], r[1], int(n_pareto_points / len(regions)))
            x2 = 1 - anp.sqrt(x1) - x1 * anp.sin(10 * anp.pi * x1)
            pareto_front = anp.concatenate((pareto_front, anp.array([x1, x2]).T), axis=0)
        return pareto_front

    def _evaluate(self, x, out, *args, **kwargs):
        f1 = x[:, 0]
        c = anp.sum(x[:, 1:], axis=1)
        g = 1.0 + 9.0 * c / (self.n_var - 1) 
        g = g + self.sparse_penalty(x[:, 1:], self.target_n)
        f2 = g * (1 - anp.power(f1 * 1.0 / g, 0.5) - (f1 * 1.0 / g) * anp.sin(10 * anp.pi * f1))

        if self.constrained: 
            out["G"] = self.sparse_penalty(x[:, 1:], self.target_n)

        out["F"] = anp.column_stack([f1, f2])


class ZDT_S4(ZDT_S):
    def __init__(self, n_var=10, target_n=3):
        super().__init__(n_var, target_n=3)
        self.xl = -5 * anp.ones(self.n_var)
        self.xl[0] = 0.0
        self.xu = 5 * anp.ones(self.n_var)
        self.xu[0] = 1.0
        self.func = self._evaluate

    def _calc_pareto_front(self, n_pareto_points=100):
        x = anp.linspace(0, 1, n_pareto_points)
        return anp.array([x, 1 - anp.sqrt(x)]).T

    def _evaluate(self, x, out, *args, **kwargs):
        f1 = x[:, 0]
        g = 1.0
        g += 10 * (self.n_var - 1)
        for i in range(1, self.n_var):
            g += x[:, i] * x[:, i] - 10.0 * anp.cos(4.0 * anp.pi * x[:, i])
    
        g += self.sparse_penalty(x[:, 1:], self.target_n)

        h = 1.0 - anp.sqrt(f1 / g)
        f2 = g * h

        out["F"] = anp.column_stack([f1, f2])


class ZDT_S6(ZDT_S):

    def _calc_pareto_front(self, n_pareto_points=100):
        x = anp.linspace(0.2807753191, 1, n_pareto_points)
        return anp.array([x, 1 - anp.power(x, 2)]).T

    def _evaluate(self, x, out, *args, **kwargs):
        f1 = 1 - anp.exp(-4 * x[:, 0]) * anp.power(anp.sin(6 * anp.pi * x[:, 0]), 6)
        g = 1 + 9.0 * anp.power(anp.sum(x[:, 1:], axis=1) / (self.n_var - 1.0), 0.25)

        g += self.sparse_penalty(x[:, 1:], self.target_n)

        f2 = g * (1 - anp.power(f1 / g, 2))

        out["F"] = anp.column_stack([f1, f2])


