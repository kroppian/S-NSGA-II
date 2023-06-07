function  A1 = UpdataArchive(A1,New,V,mu,NI)
% Update archive

%------------------------------- Copyright --------------------------------
% Copyright (c) 2018-2019 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by Cheng He

    %% Delete duplicated solutions
    All       = [A1;New];
    [~,index] = unique(All,'rows');
    ALL       = [A1;New];
    Total     = ALL(index,:);
    NewObj = CalObj_original(New);
    %% Select NI solutions for updating the models 
	if length(Total)>NI
        [~,active] = NoActive(NewObj,V);
        Vi         = V(setdiff(1:size(V,1),active),:);
        % Select the undeplicated solutions without re-evaluated
        % solutions
        index = ismember(Total,New,'rows');
        Total = Total(~index,:);
        % Since the number of inactive reference vectors is smaller than
        % NI-mu, we cluster the solutions instead of reference vectors
        PopObj = CalObj_original(Total);
        PopObj = PopObj - repmat(min(PopObj,[],1),length(Total),1);
        Angle  = acos(1-pdist2(PopObj,Vi,'cosine'));
        [~,associate] = min(Angle,[],2);
        Via    = Vi(unique(associate)',:);
        Next   = zeros(1,NI-mu);
        if size(Via,1) > NI-mu
            [IDX,~] = kmeans(Via,NI-mu);
            for i = unique(IDX)'
                current = find(IDX==i);
                if length(current)>1
                    best = randi(length(current),1);
                else
                    best = 1;
                end
                Next(i)  = current(best);
            end
        else
            % Cluster solutions based on objective vectors when the number
            % of active reference vectors is smaller than NI-mu
            [IDX,~] = kmeans(PopObj,NI-mu);
                for i   = unique(IDX)'
                    current = find(IDX==i);
                    if length(current)>1
                        best = randi(length(current),1);
                    else
                        best = 1;
                    end
                    Next(i)  = current(best);
                end
            A1 = [Total(Next',:);New];
        end
   else 
       A1 = Total;
   end
end       
     function PopObj = CalObj_original(X)
            M =2;
            theta = 0.1;
            [N,D] = size(X);
            add = zeros(N,100-D);
            X = [X,add];
            [N,D] = size(X);
            K = ceil(theta*(D-M+1));
            g = sum(g1(X(:,M:M+K-1),pi/3),2) + sum(g2(X(:,M+K:end),0),2);
            PopObj = repmat(1+g/(D-M+1),1,M).*fliplr(cumprod([ones(N,1),X(:,1:M-1)],2)).*[ones(N,1),1-X(:,M-1:-1:1)];
        end
        
        function PopObj = CalObj_fix(X)
            M =2;
            theta = 1;
            [N,D] = size(X);
            K = ceil(theta*(D-M+1));
            g = sum(g1(X(:,M:M+K-1),pi/3),2) + sum(g2(X(:,M+K:end),0),2);
            PopObj = repmat(1+g/(D-M+1),1,M).*fliplr(cumprod([ones(N,1),X(:,1:M-1)],2)).*[ones(N,1),1-X(:,M-1:-1:1)];
        end

        function g = g1(x,t)
            g = (x-t).^2;
        end

        function g = g2(x,t)
            g = 2*(x-t).^2 + sin(2*pi*(x-t)).^2;
        end