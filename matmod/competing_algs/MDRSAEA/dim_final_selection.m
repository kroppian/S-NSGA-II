function dim = dim_final_selection(dim_saea,f,sparsity,num_temp,M,D)
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