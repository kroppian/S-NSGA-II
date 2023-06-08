function [indicator,index_final] = indicator_generation(dim_current,dim_base,dim)
obj_temp = zeros(100,1000);
for i = 1:9
    index_perm = randperm(90)+10; 
    obj_temp(i*10+1:(i+1)*10,dim_base) = -1+2*rand(10,10);
    obj_temp(i*10+1:(i+1)*10,dim(index_perm(1:i*10))) = -1+2*rand(10,i*10);
end
final_obj = CalObj(Risk,Yield,obj_temp);
[a1,~] = NDSort(final_obj(:,1:2),100);
index_good_o = find(a1==1);
%     obj1 = final_obj(index_good,:);
index_good = ceil(index_good_o/10);
index_temp = mode(index_good,2);
%     best_dim(j) = temp(index_temp(1));
index_final = index_temp(1);
if index_final<=dim_current
    indicator = -1;
else
    indicator = 1;
end

end