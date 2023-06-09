

% function saea_obj = MDR_SAEA(sparsity,M,D)
%% Based Dimension Selection
    sparsity = 0.01;
    D = 1000;
    original_D = 1000;
    M = 2;
    lower    = [zeros(1,M-1)+0,zeros(1,D-M+1)-1];
    upper    = [zeros(1,M-1)+1,zeros(1,D-M+1)+2];
    global evaluation;% expensive function evaluations used
    evaluation = 0 ;
    f = @CalObj;
    [dim,TDec_o,TMask_o,TempPop_o,popobj_o] = dim_selection_local(f,sparsity,M,D,lower,upper);%3*D
    dim(dim==0)=[];
    
%% Initialization
    N = size(dim,2);
    TempPop = zeros(3*N,D);
    TempPop(1:N,:) = TempPop_o(dim(1,1:N),:);
    TempPop(N+1:2*N,:) = TempPop_o(D+dim(1,1:N),:);
    TempPop(2*N+1:3*N,:) = TempPop_o(2*D+dim(1,1:N),:);
    TMask = [eye(N);eye(N);eye(N)];
    popobj = zeros(3*N,M);
    popobj(1:N,:) = popobj_o(dim(1,1:N),:);
    popobj(N+1:2*N,:) = popobj_o(D+dim(1,1:N),:);
    popobj(2*N+1:3*N,:) = popobj_o(2*D+dim(1,1:N),:);
    fitness  = zeros(1,N);
    for i = 1:3
            fitness    = fitness + NDSort(popobj((i-1)*N+1:i*N,:),inf);
    end
    lower    = [zeros(1,M-1)+0,zeros(1,D-M+1)-1];
    upper    = [zeros(1,M-1)+1,zeros(1,D-M+1)+2];
    init_time = 4;
    if init_time*size(dim,2)>0.5*D
    init_time = floor(0.5*D/size(dim,2));
    end
    for i = 1 :init_time
     Dec = lower+(upper-lower).*rand(N,D);
    Mask_temp       = eye(N);
    Mask = zeros(N,D);
    for j =1:N
        Mask(j,dim(find(Mask_temp(j,:)))) = 1;
    end
    population = Dec.*Mask;
        PopObj     = f(population,sparsity);
        popobj     = [popobj;PopObj];
        TMask      = [TMask;Mask_temp];
        TempPop    = [TempPop;population];
        fitness    = fitness + NDSort(PopObj,inf);
    end
    % Generate initial population
    Dec = lower+(upper-lower).*rand(N,D);
    Mask_dim = eye(N);
    Mask = zeros(N,D);
    for i =1:N
        Mask(i,dim(find(Mask_dim(i,:)))) = 1;
    end
    Population = Dec.*Mask;
    PopObj_1     = f(Population,sparsity);
    PopObj = [popobj;PopObj_1];
    num_e = 0;
    if init_time*N<100
        num_e = init_time*N;
    else
        num_e = 100;
    end
    [population,mask_dim,FrontNo,CrowdDis,popobj] = EnvironmentalSelection([TempPop;Population],PopObj,[TMask;Mask_dim],num_e);
    num_time = 0;
    
%% Search Proper Dimension
%开始循环
non_zero_all = zeros(1,50);
non_zero = zeros(50,100);
for time = 1:50
    MatingPool       = TournamentSelection(2,2*100,FrontNo,-CrowdDis);
    mask_off = operate_spea(mask_dim(MatingPool,:),1,fitness);
    Dec = lower+(upper-lower).*rand(100,D);
    Mask = zeros(100,1000);
    for i =1:100
        Mask(i,dim(find(mask_off(i,:)))) = 1;
    end
    population_off = Dec.*Mask;
    PopObj = [popobj;f(population_off,sparsity)];
    [population,mask_dim,FrontNo,CrowdDis,popobj] = EnvironmentalSelection([population;population_off],PopObj,[mask_dim;mask_off],100);
    for i =1:100
        non_zero_temp = find(mask_dim(i,:));
        non_zero(time,i) = size(non_zero_temp,2);
    end
    num_temp = mode(non_zero(time,:),2);
    if time>1
    if num_temp == dim_init
        num_time = num_time+1;
    else
        num_time = 1;
    end
    end
    dim_init = num_temp;
    if num_time>4
        break
    end
end

%% Selection of Dimension on K-RVEA
%循环结束输出
dim_saea = dim_base(mask_dim,dim,num_temp);% b = zeros(1,30);
result = saea_check(dim_saea,num_temp);
if result>0
    evaluation = evaluation + 40*num_temp;
    dim_saea = dim_final_selection_local(dim_saea,f,sparsity,num_temp,M,D);
else
    evaluation = evaluation + 40*num_temp;
end
% evaluation_time(evaluation_temp) = evaluation;
saea_combination= nchoosek(dim_saea,num_temp);
saea_time = size(saea_combination,1);
saea_obj = zeros(20*num_temp*saea_time,2);
for krvea_time = 1:saea_time
dim = saea_combination(krvea_time,:);
%% Parameter setting
    alpha = 2;
    wmax = 20;
    mu = 5;
    M = 2;
    D  = size(dim,2);
    N1 = 20*D;
    lower_o   = [zeros(1,2-1)+0,zeros(1,1000-2+1)-1];
    upper_o    = [zeros(1,2-1)+1,zeros(1,1000-2+1)+2];
    lower = lower_o(:,dim);
    upper = upper_o(:,dim);
    %% Generate the reference points and population
    [V0,N1] = UniformPoint(20*D,M);
	V     = V0;
    NI    = 20*D;
    P     = lhsdesign(NI,D);
    A2    = repmat(upper-lower,NI,1).*P+repmat(lower,NI,1);
    A1    = A2;  %当前种群
    THETA = 5.*ones(M,D);
    Model = cell(1,M);
    num = 0;
    %% Optimization
    while size(A2,1)< 40*num_temp
        % Refresh the model and generate promising solutions
        A1Dec = A1;
        A1Obj = CalObj_dim(A1,dim,sparsity);
        for i = 1 : M
            % The parameter 'regpoly1' refers to one-order polynomial
            % function, and 'regpoly0' refers to constant function. The
            % former function has better fitting performance but lower
            % efficiency than the latter one
            dmodel     = dacefit(A1Dec,A1Obj(:,i),'regpoly0','corrgauss',THETA(i,:),1e-5.*ones(1,D),20*D.*ones(1,D));
            Model{i}   = dmodel;
            THETA(i,:) = dmodel.theta;
        end
        PopDec = A1Dec;
        w      = 1;
        while w <= wmax
            drawnow();
            OffDec = GA(PopDec,lower,upper);
            PopDec = [PopDec;OffDec];
            [N,~]  = size(PopDec);
            M =2;
            PopObj = zeros(N,M);
            MSE    = zeros(N,M);
            for i = 1: N
                for j = 1 : M
                    [PopObj(i,j),~,MSE(i,j)] = predictor(PopDec(i,:),Model{j});
                end
            end
            index  = KEnvironmentalSelection(PopObj,V,(w/wmax)^alpha);
            PopDec = PopDec(index,:);
            PopObj = PopObj(index,:);
            
            % Adapt referece vectors
            if ~mod(w,ceil(wmax*0.1))
                V(1:N1,:) = V0.*repmat(max(PopObj,[],1)-min(PopObj,[],1),size(V0,1),1);
            end
            w = w + 1; 
        end
        
        % Select mu solutions for re-evaluation
        [NumVf,~] = NoActive(A1Obj,V0);
        PopNew    = KrigingSelect(PopDec,PopObj,MSE,V,V0,NumVf,0.05*N,mu,(w/wmax)^alpha); 
        A2        = [A2;PopNew];%历史总个体
        A1        = UpdataArchive(A1,PopNew,V,mu,NI);%当前集合中个体 
    end
saea_obj((krvea_time-1)*20*num_temp+1:krvea_time*20*num_temp,:) = CalObj_dim(A1,dim,sparsity);
end
chr_s = ['Proposed_SMOP1_',num2str(sparsity),'_',num2str(original_D),'.mat'];
 save(chr_s,'saea_obj');
% end
% end
        %% Calculate objective values
        %smop1
    function PopObj = CalObj_dim(X,dim,sparsity)
    [N,~] = size(X);
    new = zeros(N,1000);
    for i = 1:N
        new(i,dim) = X(i,:);
    end
    X = new;
    [N,D] = size(X);
    M = 2;
    K = ceil(sparsity*(D-M+1));
    g = sum(g1(X(:,M:M+K-1),pi/3),2) + sum(g2(X(:,M+K:end),0),2);
    PopObj = repmat(1+g/(D-M+1),1,M).*fliplr(cumprod([ones(N,1),X(:,1:M-1)],2)).*[ones(N,1),1-X(:,M-1:-1:1)];
    function g = g1(x,t)
    g = (x-t).^2;
end

function g = g2(x,t)
    g = 2*(x-t).^2 + sin(2*pi*(x-t)).^2;
end

function g = g3(x,t)
    g = 4-(x-t)-4./exp(100*(x-t).^2);
end

function g = g4(x,t)
    g = (x-pi/3).^2 + t.*sin(6*pi*(x-pi/3)).^2;
end
end

%smop1
function PopObj = CalObj(X,sparsity)
    global evaluation;
    [N,D] = size(X);
    evaluation = evaluation + N;
    M = 2;
    K = ceil(sparsity*(D-M+1));
    g = sum(g1(X(:,M:M+K-1),pi/3),2) + sum(g2(X(:,M+K:end),0),2);
    PopObj = repmat(1+g/(D-M+1),1,M).*fliplr(cumprod([ones(N,1),X(:,1:M-1)],2)).*[ones(N,1),1-X(:,M-1:-1:1)];
    function g = g1(x,t)
    g = (x-t).^2;
end

function g = g2(x,t)
    g = 2*(x-t).^2 + sin(2*pi*(x-t)).^2;
end

function g = g3(x,t)
    g = 4-(x-t)-4./exp(100*(x-t).^2);
end

function g = g4(x,t)
    g = (x-pi/3).^2 + t.*sin(6*pi*(x-pi/3)).^2;
end
end



function dim = dim_final_selection_local(dim_saea,f,sparsity,num_temp,M,D)
    N = size(dim_saea,2);

    lower    = [zeros(1,M-1)+0,zeros(1,D-M+1)-1];
    upper    = [zeros(1,M-1)+1,zeros(1,D-M+1)+2];
    Dec = lower+(upper-lower).*rand(N,D);
        Mask = zeros(N,D);
    for i =1:N
        Mask(i,dim_saea(i)) = 1;
    end
    Population = Dec.*Mask;
    popobj = f(Population,sparsity);
    [FrontNo,~] = NDSort(popobj,N);
    [B,I] = sort(FrontNo,'ascend');
    dim = dim_saea(I(1:num_temp));
end



function [dim,Dec_return,Mask_return,Ind_return,Ind_obj] = dim_selection_local(f,sparsity,M,D,lower,upper)
    base = zeros(1,D);
    Dec = lower+(upper-lower).*rand(D,D);
    Mask       = eye(D);
    Population = Dec.*Mask;
    ind = [base;Population];
    ind_obj = f(ind,sparsity);
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
            ind_obj = f(ind,sparsity);
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
            ind_obj = f(ind,sparsity);
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



