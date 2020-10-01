
% Inner loop 
algorithms = {@SparseEA, @NSGAII, @NSGAII};
%algorithms = {@NSGAII, @NSGAII, @NSGAII};
colors = ["red", "blue", "green"];
sps_on = {false, true, false};
labels = ["SparseEA", "NSGAII-SPS", "NSGAII"];
%labels = ["NSGAII-SPS", "NSGAII", "NSGAII"];




% Outer loop
Dz = {100, 500, 1000, 5000};


for i = 1:size(Dz,2)
    subplot(2,2,i);
    hold on

    for a = 1:size(algorithms,2)

        fprintf("%s starting... \n", labels{a});
        tStart = cputime;
        final_pop = runOpt(algorithms{a}, Dz{i}, sps_on{a});
        tEnd = cputime - tStart;
        scatter(final_pop(:,1), final_pop(:,2), colors{a});
        fprintf("%s Finished with %f Seconds\n", labels{a}, tEnd);

    end
    title(sprintf("%d decision variables", Dz{i}));
    legend(labels{1}, labels{2}, labels{3});

    hold off

end



