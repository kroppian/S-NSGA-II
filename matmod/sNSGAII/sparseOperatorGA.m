function Offspring = sparseOperatorGA(Parent, Parameter)


    % proC --- 1 --- Probability of crossover
    % disC --- 20 --- Distribution index of crossover
    % proM --- 1 --- Expectation of the number of mutated variables 
    % disM --- 20 --- Distribution index of mutation
    

    %% Parameter setting
    if nargin > 1
        [proC,disC,proM,disM,proSM,disSM,s_mut_on,s_x_on] = deal(Parameter{:});
    else
        [proC,disC,proM,disM,proSM,disSM,s_mut_on,s_x_on] = deal(1,20,1,20,true,true);
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
            %% Genetic operators for real encoding

            if s_x_on 
                Offspring = cropover(Parent, Problem.lower, Problem.upper, {proC,disC});
            else
                % Simulated binary crossover
                Offspring = sbx(Parent, Problem.lower, Problem.upper, proC, disC);
            end

            if s_mut_on
                Offspring = sparsePolyMutate(Offspring, Problem.lower, Problem.upper, {proM,disM, proSM,disSM});
            else
                
                Lower = repmat(Problem.lower,N,1);
                Upper = repmat(Problem.upper,N,1);
                Site  = rand(N,D) < proM/D;
                mu    = rand(N,D);
                temp  = Site & mu<=0.5;
                Offspring       = min(max(Offspring,Lower),Upper);
                Offspring(temp) = Offspring(temp)+(Upper(temp)-Lower(temp)).*((2.*mu(temp)+(1-2.*mu(temp)).*...
                                  (1-(Offspring(temp)-Lower(temp))./(Upper(temp)-Lower(temp))).^(disM+1)).^(1/(disM+1))-1);
                temp = Site & mu>0.5; 
                Offspring(temp) = Offspring(temp)+(Upper(temp)-Lower(temp)).*(1-(2.*(1-mu(temp))+2.*(mu(temp)-0.5).*...
                                  (1-(Upper(temp)-Offspring(temp))./(Upper(temp)-Lower(temp))).^(disM+1)).^(1/(disM+1)));
            end


            
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

