classdef sNSGAII < ALGORITHM
% <multi> <real/binary/permutation> <constrained/none>
% Nondominated sorting genetic algorithm II

%------------------------------- Reference --------------------------------
% K. Deb, A. Pratap, S. Agarwal, and T. Meyarivan, A fast and elitist
% multiobjective genetic algorithm: NSGA-II, IEEE Transactions on
% Evolutionary Computation, 2002, 6(2): 182-197.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    methods
        function main(Algorithm,Problem)
            
            [ sampling_method, mutation_method, crossover_method ] = Algorithm.ParameterSet({@sparseSampler, 0.5, 1}, @sparsePolyMutate, @cropover_v1);
            

            
            %% Generate random population



            if class(sampling_method{1}) == "function_handle" && func2str(sampling_method{1}) == "nop"
                Population = Problem.Initialization();
            else
                sampler = sampling_method{1};
                Population = sampler(Problem, sampling_method{2}, sampling_method{3});
            end


            [~,FrontNo,CrowdDis] = EnvironmentalSelection(Population,Problem.N);

            %% Optimization
            while Algorithm.NotTerminated(Population)
                MatingPool = TournamentSelection(2,Problem.N,FrontNo,-CrowdDis);

                Offspring  = sparseOperatorGA(Population(MatingPool), ...
                                        {1,20,1,20,1,20,mutation_method,crossover_method});

                [Population,FrontNo,CrowdDis] = EnvironmentalSelection([Population,Offspring],Problem.N);
            end
        end

    end

    

end