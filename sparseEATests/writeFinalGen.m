function [] = writeFinalGen(obj)
%WRITEFINALGEN Summary of this function goes here
%   Detailed explanation goes here

    if obj.gen == obj.maxgen
        
        pop_objs = ones(obj.N,obj.M)*-1;
        for indv = 1:obj.N
            final_run = size(obj.result,1);

            pop_objs(indv,:) = obj.result{final_run, 2}(indv).obj;
        end
       
        writematrix(pop_objs, "/Users/iankropp/Desktop/deleteme.csv");
    end
end

