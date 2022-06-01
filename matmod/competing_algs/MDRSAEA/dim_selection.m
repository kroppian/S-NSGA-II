function [dim,Dec_return,Mask_return,Ind_return,Ind_obj] = dim_selection(problem) % Function parameters edited -- IMK 

    % Start - edited IMK
    D = problem.D;
    lower = problem.lower;
    upper = problem.upper; 
    % End - edited IMK

    base = zeros(1,D);
    Dec = lower+(upper-lower).*rand(D,D);
    Mask       = eye(D);
    Population = Dec.*Mask;
    ind = [base;Population];
    ind_obj = problem.CalObj(ind);              % Edited IMK
    [FrontNo,~] = NDSort(ind_obj,D+1);
    dim = find(FrontNo<=FrontNo(1,1))-1;
    index = size(dim,2);
    t = 1;
    Dec_return = Dec;
    Mask_return = Mask;
    Ind_return = Population;
    Ind_obj = ind_obj(2:end,:);
    if index<=0.1*D
        while t<3
            base = zeros(1,D);
            Dec = lower+(upper-lower).*rand(D,D);
            Mask       = eye(D);
            Population = Dec.*Mask;
            ind = [base;Population];
            ind_obj = problem.CalObj(ind);                  % Edited IMK
            [FrontNo,~] = NDSort(ind_obj,D+1);
            dim_temp = find(FrontNo<=FrontNo(1,1))-1;
            dim = union(dim_temp,dim);
            t = t + 1;
            Dec_return = [Dec_return;Dec];
            Mask_return = [Mask_return;Mask];
            Ind_return = [Ind_return;Population];
            Ind_obj = [Ind_obj;ind_obj(2:end,:)];
        end
    
    else
        while t<3
            base = zeros(1,D);
            Dec = lower+(upper-lower).*rand(D,D);
            Mask       = eye(D);
            Population = Dec.*Mask;
            ind = [base;Population];
            ind_obj = problem.CalObj(ind);      % Edited by IMK 
            indicator = zeros(1,1000);
            for i=1:1000
                indicator(i) = compare(ind_obj(i+1,1),ind_obj(1,1))+compare(ind_obj(i+1,2),ind_obj(1,2));
            end
            index_1 = find(indicator==0);
            index_2 = find(indicator==-1);
            dim_temp = union(index_1,index_2);
            dim = intersect(dim_temp,dim);
            t = t + 1;
            Dec_return = [Dec_return;Dec];
            Mask_return = [Mask_return;Mask];
            Ind_return = [Ind_return;Population];
            Ind_obj = [Ind_obj;ind_obj(2:end,:)];
        end
    end
end


function i = compare(a,b)
    if a<b
        i = -1;
    end
    if a>b
        i=1;
    end
    if a==b
        i=0;
    end
end