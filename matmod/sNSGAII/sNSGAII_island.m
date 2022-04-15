classdef sNSGAII_island < ALGORITHM
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
            
            tStart = tic;
            
            [ sampling_method, mutation_method, crossover_method ] = Algorithm.ParameterSet({@sparseSampler, 0.5, 1}, @sparsePolyMutate, @cropover_v1);
            
            %% Set up islands
            island_count = 6; 

            global_pop = [];

            slb = sampling_method{2};
            sub = sampling_method{3};

            targetSparsities = linspace(slb, sub, island_count);

%             origMaxFE = Problem.maxFE;
%             Problem.maxFE = Problem.maxFE / island_count;



            for i = 1:island_count

                final_pop = {};
                % Added this try/catch to avoid being kicked back to parent
                % routine 
                try

                    %% Generate random population
        
                    sampler = sampling_method{1};
                    Population = sampler(Problem, targetSparsities(i), targetSparsities(i));
        
                    [~,FrontNo,CrowdDis] = EnvironmentalSelection(Population,Problem.N);

                    %% Optimization
                    while Algorithm.NotTerminated(Population)
 
                        MatingPool = TournamentSelection(2,Problem.N,FrontNo,-CrowdDis);
        
                        Offspring  = sparseOperatorGA(Population(MatingPool), ...
                                                {1,20,1,20,1,20,mutation_method,crossover_method});
        
                        [Population,FrontNo,CrowdDis] = EnvironmentalSelection([Population,Offspring],Problem.N);
                        final_pop = Population;
                        
                    end
                catch err

                    %% Handle recently finished optimization 
                    % Current optimization just finished
                    if ~strcmp(err.identifier,'PlatEMO:Termination')
                        rethrow(err);
                    end
                    
                    % record final population 
                    global_pop = [global_pop, final_pop];
                    
                    % reboot for the next run 
                    Problem.FE = 0;

                end

            end % End -- individual island optimization

            %% Resume optimization with global popualtion 
            Population = global_pop; 
            [~,FrontNo,CrowdDis] = EnvironmentalSelection(Population,Problem.N*island_count);
            
            %% Final Optimization
            while Algorithm.NotTerminated(Population)
                MatingPool = TournamentSelection(2,Problem.N,FrontNo,-CrowdDis);

                Offspring  = sparseOperatorGA(Population(MatingPool), ...
                                        {1,20,1,20,1,20,mutation_method,crossover_method});

                [Population,FrontNo,CrowdDis] = EnvironmentalSelection([Population,Offspring],Problem.N);
                
            end

            obj.metric.runtime = toc(tStart);

        end
        

    end
    

    

end