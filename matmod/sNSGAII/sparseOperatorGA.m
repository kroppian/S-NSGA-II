function Offspring = sparseOperatorGA(Parent, Parameter)


    % proC --- 1 --- Probability of crossover
    % disC --- 20 --- Distribution index of crossover
    % proM --- 1 --- Expectation of the number of mutated variables 
    % disM --- 20 --- Distribution index of mutation
    

    %% Parameter setting
    if nargin > 1
        [probCross,distrCross,~,~] = deal(Parameter{:});
    else
        [probCross,distrCross,~,~] = deal(1,20,1,20);
    end
    if isa(Parent(1),'SOLUTION')
        calObj = true;
        Parent = Parent.decs;
    else
        calObj = false;
    end
    Parent1 = Parent(1:floor(end/2),:);
    Parent2 = Parent(floor(end/2)+1:floor(end/2)*2,:);
    [N,D]   = size(Parent1);
    Problem = PROBLEM.Current();
    
    switch Problem.encoding
        case 'binary'
            error('Binary encoding not supported.');
        case 'permutation'
            error('Permutation encoding not supported.');
        otherwise
            %% Genetic operators for real encoding
            % Simulated binary crossover
            beta = zeros(N,D);
            mu   = rand(N,D);
            beta(mu<=0.5) = (2*mu(mu<=0.5)).^(1/(distrCross+1));
            beta(mu>0.5)  = (2-2*mu(mu>0.5)).^(-1/(distrCross+1));
            beta = beta.*(-1).^randi([0,1],N,D);
            beta(rand(N,D)<0.5) = 1;
            beta(repmat(rand(N,1)>probCross,1,D)) = 1;
            Offspring = [(Parent1+Parent2)/2+beta.*(Parent1-Parent2)/2
                         (Parent1+Parent2)/2-beta.*(Parent1-Parent2)/2];

            Lower = repmat(Problem.lower,2*N,1);
            Upper = repmat(Problem.upper,2*N,1);
            
            % Put everything back in bounds
            Offspring       = min(max(Offspring,Lower),Upper);

                     
            if nargin > 1
                Offspring = sparsePolyMutate(Offspring, Problem, Parameter{3:4});
            else
                Offspring = sparsePolyMutate(Offspring, Problem);
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

