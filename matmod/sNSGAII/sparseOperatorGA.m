function Offspring = sparseOperatorGA(Problem, Parent, Parameter)


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
    
    calObj = false;

    if isa(Parent(1),'SOLUTION')
        calObj = true;
        Parent = Parent.decs;
    end

    % The Parent object: 
    % The first 50% are the genomes of the population that were selected
    % during tournament selection
    % The second 50% are the genomes of the population that will be crossed
    % over with the first 50% of "Parent"
    
    % Check if any of the decision variables are non-real values 
    if any(ones(size(Problem.encoding)) ~= Problem.encoding)
        error('Only real encoding supported.');
    end

    Offspring = crossover_method(Parent, Problem.lower, Problem.upper, {proC,disC});

    if func2str(mutation_method) == "polyMutate"
        mutation_params = {proM,disM};
    else
        mutation_params = {proM,disM, proSM,disSM};
    end
    Offspring = mutation_method(Offspring, Problem.lower, Problem.upper, mutation_params);        

    if calObj
        Offspring = Problem.Evaluation(Offspring);
    end
    
    
end
