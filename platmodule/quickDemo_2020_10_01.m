
% Inner loop 
algorithms = {@NSGAII, @NSGAII, @SparseEA};
colors = ["red", "blue", "green"];
sps_on = {true, false, false};

% Outer loop
%Dz = {100, 1000, 5000, 10000};
Dz = {2000};

hold on

for i = 1:size(Dz,2)
    
    for a = 1:size(algorithms,2)
        disp("foo");
        final_pop = runOpt(algorithms{a}, Dz{i}, sps_on{a});
        scatter(final_pop(:,1), final_pop(:,2), colors{a});
        disp("bar");

    end
    
end


hold off

