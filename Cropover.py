from pymoo.model.crossover import Crossover
from pymoo.operators.crossover.simulated_binary_crossover import SimulatedBinaryCrossover
import numpy as np
import sys
import copy, math
from pymoo.model.problem import Problem


class Cropover(Crossover):
    def __init__(self, eta, prob_per_variable=0.5, **kwargs):
        # define the crossover: number of parents and number of offsprings
        super().__init__(2, 2)
        self.eta = float(eta)
        self.prob_per_variable = prob_per_variable
        self.sbx = SimulatedBinaryCrossover(eta, prob_per_variable, **kwargs)

    @staticmethod
    def simple_cross(p1, p2):

        # Use xor to find all the zero & non-zero
        mis_matches = np.logical_xor(p1, p2)           

        # Then set both parents to the sum of the two parents
        c1 = np.copy(p1)
        c2 = np.copy(p2)

        if np.random.random() < 0.5:
            c1[mis_matches], c2[mis_matches] = [c1[mis_matches] + c2[mis_matches]] * 2
        else:
            c1[mis_matches], c2[mis_matches] = [c1[mis_matches] * c2[mis_matches]] * 2

        # No need for anything for zero and zero 
        return c1, c2 

    @staticmethod    
    def _stripzs(X): 
        inds = np.where(X != 0)
        vals = X[inds]
        return np.vstack((inds[0],vals))

    @staticmethod
    def cross_try(p1, p2, problem, eta, prob_per_variable):


        # number of non-zeros
        nz1, nz2 = np.sum(p1 != 0), np.sum(p2 != 0)

        length = np.size(p1)

        # Genotype with zeros removed, and the position 
        # of the non-zeros in the second row
        p1stripd, p2stripd = Cropover._stripzs(p1), Cropover._stripzs(p2)

        # How do we match up the numbers if there are difference sparities?
        # Remove the most crowded values
        maxl = nz1 if nz1 < nz2 else nz2

        # If both parents are all zero, just continue
        if maxl == 0:
            return p1, p2

        # Calculate how crowded they are 
        dists1 = Cropover.crowding_ranking(p1stripd[0,:])
        dists2 = Cropover.crowding_ranking(p2stripd[0,:])

        # Find the indices of the top solutions 
        # under maxl with respects to crowding
        best1 = np.sort(np.argpartition(dists1, -maxl)[-maxl:])
        best2 = np.sort(np.argpartition(dists2, -maxl)[-maxl:])


        # If the sparsity doesn't match, save half of the overflow
        num2save = math.floor(abs(nz1 - nz2)/2)

        if num2save:
            worst1 = [val for val in range(nz1) if not val in best1]
            to_save_ind = np.argpartition(worst1, -num2save)[-num2save:]
            to_save1 = p1stripd[:,to_save_ind]

            worst2 = [val for val in range(nz2) if not val in best2]
            to_save_ind = np.argpartition(worst2, -num2save)[-num2save:]
            to_save2 = p2stripd[:,to_save_ind]

        # Format the arrays to function within sbx
        dense_parents = np.zeros([2,1,problem.n_var])
        dense_parents[0,0,0:maxl] = p1stripd[1,best1]
        dense_parents[1,0,0:maxl] = p2stripd[1,best2]
       
        # Calculate SBX
        sbx = SimulatedBinaryCrossover(eta, prob_per_variable)
        dense_children = sbx._do(problem, dense_parents)

        # Pull the data out from the boilerplate
        dense_children = dense_children[:,:,0:maxl]

        # We need to find out the new position of the non-zeros in the parents
        # So we need to calculate SBX on the positions

        dense_parents[0,0,0:maxl] = p1stripd[0,best1]
        dense_parents[1,0,0:maxl] = p2stripd[0,best2]

        par_size = np.size(dense_parents, 2)
        position_sbx_prob = Problem(n_var=par_size, xl=0, xu=par_size)
        
        # TODO we might need to tweak eta to do more of spread
        eta = length
        sbx = SimulatedBinaryCrossover(eta, prob_per_variable)
        new_positions_raw = sbx._do(position_sbx_prob, dense_parents)
        new_positions = np.round(new_positions_raw)

        if np.isnan(new_positions_raw).any():
            print("Error during cropover...")
            exit(1)
     
        # set any out of indexs back in index 
        overs = new_positions > (length - 1)
        new_positions[overs] = (length - 1)
       

        p1stripd[0,best1] = new_positions[0,0,0:maxl] 
        p2stripd[0,best2] = new_positions[1,0,0:maxl] 

        # Now we need to place these values back 
        # in the children at their original spaces 
        c1 = np.zeros_like(p1) 
        c2 = np.zeros_like(p2) 

        # Put the values back into the children where they were in the parents
        if np.size(dense_children[0,:,:]) != 0:
            c1[p1stripd[0,:][best1].astype(int)] = dense_children[0,:,:]
        if np.size(dense_children[1,:,:]) != 0:
            c2[p2stripd[0,:][best2].astype(int)] = dense_children[1,:,:]

        # Put the values to save into their respective places 
        if num2save:
            c1[to_save1[0,:].astype(int)] = p1[to_save1[0,:].astype(int)]
            c2[to_save2[0,:].astype(int)] = p2[to_save2[0,:].astype(int)]

        return c1, c2

    @staticmethod
    def crowding_ranking(positions):
        ranks = [] 
        l = len(positions)
        for p in range(l): 
            bef = p - 1
            aft = p + 1
            if bef < 0 or aft >= l:
                ranks.append(int(sys.maxsize))
            else:
                ranks.append(int(abs(positions[p] - positions[bef]) + abs(positions[aft] - positions[p])))

        return ranks

    def _do(self, problem, X, **kwargs):

        # 
        # zero & non-zero       -> non-zero
        # zero & zero           -> zero
        # non-zero & non-zero   -> SBX
        # 

        # The input of has the following shape (n_parents, n_matings, n_var)
        _, n_matings, n_var = X.shape

        # The output owith the shape (n_offsprings, n_matings, n_var)
        # Because there the number of parents and offsprings are equal it keeps the shape of X 
        Y = np.full_like(X, None, dtype=np.object)

        # for each mating provided
        for k in range(n_matings):

            # get the first and the second parent
            p1, p2 = X[0, k, :], X[1, k, :]
            
            c1, c2 = Cropover.cross_try(p1, p2, problem, self.eta, self.prob_per_variable)

            # join the character list and set the output
            Y[0, k, :], Y[1, k, :] = c1, c2

        # Run SBX on the two newly modified set of parents
        return self.sbx._do(problem, Y)

