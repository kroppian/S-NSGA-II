classdef GLOBAL_SPS < GLOBAL
    
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
            Population = INDIVIDUAL(obj.problem.Init(N));
        end
    
        function final_objs = Start(obj)
            Start@GLOBAL(obj);
            final_objs = ones(obj.N,obj.M)*-1;
            for indv = 1:obj.N
                final_run = size(obj.result,1);

                final_objs(indv,:) = obj.result{final_run, 2}(indv).obj;
            end
        end
    
    end
end

