function Offspring = sparseOperatorGA(Parent, Parameter)


    % proC --- 1 --- Probability of crossover
    % disC --- 20 --- Distribution index of crossover
    % proM --- 1 --- Expectation of the number of mutated variables 
    % disM --- 20 --- Distribution index of mutation
    

    %% Parameter setting
    if nargin > 1
        [proC,disC,proM,disM,proSM,disSM,mutation_method,crossover_method] = deal(Parameter{:});
    else
        [proC,disC,proM,disM,proSM,disSM,mutation_method,crossover_method] = deal(1,20,1,20,true,true);
    end
    if isa(Parent(1),'SOLUTION')
        calObj = true;
        Parent = Parent.decs;
    else
        calObj = false;
    end

    % The Parent object: 
    % The first 50% are the genomes of the population that were selected
    % during tournament selection
    % The second 50% are the genomes of the population that will be crossed
    % over with the first 50% of "Parent"
    [N,D]   = size(Parent);
    Problem = PROBLEM.Current();
    
    switch Problem.encoding
        case 'binary'
            error('Binary encoding not supported.');
        case 'permutation'
            error('Permutation encoding not supported.');
        otherwise

            Offspring = crossover_method(Parent, Problem.lower, Problem.upper, {proC,disC});

            if func2str(mutation_method) == "polyMutate"
                mutation_params = {proM,disM};
            else
                mutation_params = {proM,disM, proSM,disSM};
            end
            Offspring = mutation_method(Offspring, Problem.lower, Problem.upper, mutation_params);        


            
    end
    if calObj
        Offspring = SOLUTION(Offspring);
    end

    
    
end
            
% Sparse polynomial mutation
%             Lower = repmat(Problem.lower,2*N,1); 
%             Upper = repmat(Problem.upper,2*N,1);
%             Site  = rand(2*N,D) < probMut/D;        % Where to mutate? 
%             mu    = rand(2*N,D);                    % Random numbers between 0 and 1
%             temp  = Site & mu<=0.5;                 % So of the locations specified in the Site var, choose roughly half?

