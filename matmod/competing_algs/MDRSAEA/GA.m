function Offspring = GA(Parent,lower,upper)
proC = 1;
disC = 20;
proM = 1;
disM = 20;
    %% Parameter setting
%     if nargin > 1
%         [proC,disC,proM,disM] = deal(Parameter{:});
%     else
%         [proC,disC,proM,disM] = deal(1,20,1,20);
%     end
%     if isa(Parent(1),'INDIVIDUAL')
%         calObj = true;
%         Parent = Parent.decs;
%     else
%         calObj = false;
%     end
    Parent1 = Parent(1:floor(end/2),:);
    Parent2 = Parent(floor(end/2)+1:floor(end/2)*2,:);
    [N,D]   = size(Parent1);
%     Global  = GLOBAL.GetObj();
 
%     switch Global.encoding
%         case 'binary'
%             %% Genetic operators for binary encoding
%             % One point crossover
%             k = repmat(1:D,N,1) > repmat(randi(D,N,1),1,D);
%             k(repmat(rand(N,1)>proC,1,D)) = false;
%             Offspring1    = Parent1;
%             Offspring2    = Parent2;
%             Offspring1(k) = Parent2(k);
%             Offspring2(k) = Parent1(k);
%             Offspring     = [Offspring1;Offspring2];
%             % Bitwise mutation
%             Site = rand(2*N,D) < proM/D;
%             Offspring(Site) = ~Offspring(Site);
%         case 'permutation'
%             %% Genetic operators for permutation based encoding
%             % Order crossover
%             Offspring = [Parent1;Parent2];
%             k = randi(D,1,2*N);
%             for i = 1 : N
%                 Offspring(i,k(i)+1:end)   = setdiff(Parent2(i,:),Parent1(i,1:k(i)),'stable');
%                 Offspring(i+N,k(i)+1:end) = setdiff(Parent1(i,:),Parent2(i,1:k(i)),'stable');
%             end
%             % Slight mutation
%             k = randi(D,1,2*N);
%             s = randi(D,1,2*N);
%             for i = 1 : 2*N
%                 if s(i) < k(i)
%                     Offspring(i,:) = Offspring(i,[1:s(i)-1,k(i),s(i):k(i)-1,k(i)+1:end]);
%                 elseif s(i) > k(i)
%                     Offspring(i,:) = Offspring(i,[1:k(i)-1,k(i)+1:s(i)-1,k(i),s(i):end]);
%                 end
%             end
%         otherwise
            %% Genetic operators for real encoding
            % Simulated binary crossover
            beta = zeros(N,D);
            mu   = rand(N,D);
            beta(mu<=0.5) = (2*mu(mu<=0.5)).^(1/(disC+1));
            beta(mu>0.5)  = (2-2*mu(mu>0.5)).^(-1/(disC+1));
            beta = beta.*(-1).^randi([0,1],N,D);
            beta(rand(N,D)<0.5) = 1;
            beta(repmat(rand(N,1)>proC,1,D)) = 1;
            Offspring = [(Parent1+Parent2)/2+beta.*(Parent1-Parent2)/2
                         (Parent1+Parent2)/2-beta.*(Parent1-Parent2)/2];
            % Polynomial mutation
            Lower = repmat(lower,2*N,1);
            Upper = repmat(upper,2*N,1);
            Site  = rand(2*N,D) < proM/D;
            mu    = rand(2*N,D);
            temp  = Site & mu<=0.5;
            Offspring       = min(max(Offspring,Lower),Upper);
            Offspring(temp) = Offspring(temp)+(Upper(temp)-Lower(temp)).*((2.*mu(temp)+(1-2.*mu(temp)).*...
                              (1-(Offspring(temp)-Lower(temp))./(Upper(temp)-Lower(temp))).^(disM+1)).^(1/(disM+1))-1);
            temp = Site & mu>0.5; 
            Offspring(temp) = Offspring(temp)+(Upper(temp)-Lower(temp)).*(1-(2.*(1-mu(temp))+2.*(mu(temp)-0.5).*...
                              (1-(Upper(temp)-Offspring(temp))./(Upper(temp)-Lower(temp))).^(disM+1)).^(1/(disM+1)));
    end
%     if calObj
%         Offspring = INDIVIDUAL(Offspring);
%     end
