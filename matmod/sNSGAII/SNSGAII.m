classdef SNSGAII < ALGORITHM
% <multi> <real> <large/none> <constrained/none> <sparse>
% Sparse Nondominated sorting genetic algorithm II

%------------------------------- Reference --------------------------------
% I. Kropp, A. Pouyan Nejadhashemi, and K. Deb, Improved Evolutionary 
% Operators for Sparse Large-Scale Multiobjective Optimization Problems
% IEEE Transactions on Evolutionary Computation, 2023, (Early access) 
%--------------------------------------------------------------------------

    methods
        function main(Algorithm, Problem)

            [ sampling_method, mutation_method, crossover_method ] = ...
               Algorithm.ParameterSet( ...
                 {@vssps, 0.75, 1}, ...
                 @spm, ...
                 @ssbx ...
               );
            
            %% Generate random population

            sampler = sampling_method{1};
            lowerBound = sampling_method{2};
            upperBound = sampling_method{3};
            Population = sampler(Problem, lowerBound, upperBound);

            [~,FrontNo,CrowdDis] = EnvironmentalSelection(Population,Problem.N);

            %% Optimization
            while Algorithm.NotTerminated(Population)
                MatingPool = TournamentSelection(2,Problem.N,FrontNo,-CrowdDis);

                Offspring  = sparseOperatorGA(Problem, Population(MatingPool), ...
                                        {1,20,1,20,1,20,mutation_method,crossover_method});

                [Population,FrontNo,CrowdDis] = EnvironmentalSelection([Population,Offspring],Problem.N);
            end
        end

    end

    

end
