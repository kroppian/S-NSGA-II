classdef GLOBAL_SPS < GLOBAL
    
    properties
        sps_on = false
        sLower = 0.5
        sUpper = 1
    end
    
    methods
        %% Randomly generate an initial population
        function Population = Initialization(obj,N)
        %Initialization - Randomly generate an initial population.
        %
        %   P = obj.Initialization() returns an initial population, i.e.,
        %   an array of obj.N INDIVIDUAL objects.
        %
        %   P = obj.Initialization(N) returns an initial population with N
        %   individuals.
        %
        %   Example:
        %       P = obj.Initialization()
        
        
                    
            if nargin < 2
                N = obj.N;
            end
            
            if obj.sps_on
                genome = obj.problem.Init(obj.N);
                varCount = size(obj.lower,2);

                mask = false(N, varCount);
                for indv = 1:N
                    % generate the number of zeros 
                    zeroCount = randi(round([obj.sLower*varCount, obj.sUpper*varCount]));
                    zeroIndices = randperm(varCount, zeroCount);
                    mask(indv, zeroIndices) = true;
                end
                genome(mask) = 0;

                Population = INDIVIDUAL(genome);
            else
                Population = INDIVIDUAL(obj.problem.Init(N));
            end

        

        end
    
        function final_objs = Start(obj)
            % Start the optimization
            Start@GLOBAL(obj);
            
            % Get the last generation's results
            final_gen = obj.result{end};
            
            % Count the number of population members
            pop_count = numel(final_gen);
            
            % Create empty container for our objectives
            final_objs = ones(pop_count,obj.M)*-1;
            
            % Place the objectives for each of our final pop in there
            for indv = 1:pop_count
                final_objs(indv,:) = final_gen(indv).obj;
            end
            
            % Remove dominated solutions
            final_objs = final_objs(NDSort(final_objs,1) == true,:);
            
        end
    
    end
end

