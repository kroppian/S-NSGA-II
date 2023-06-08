function dim_saea = dim_base(mask_dim,dim,num)
%mask_dim: final mask matrix
%dim non-zero dimension in this optimization
%num:dimension of saea
non_zero = zeros(1,size(mask_dim,1));
for i = 1:size(mask_dim,1)
    non_zero(i) =size(find(mask_dim(i,:)),2);
end
index = find(non_zero==num);%含有num个维度的mask
n = size(index,2);
dim_b = zeros(n,num);
for i = 1:n
    dim_b(i,:) = dim(find(mask_dim(index(i),:)));
end 
% t= tabulate(dim_b);
dim_saea = unique(dim_b)';
end