
clear;
% Path to the install path of plat EMO 

addpath("..");
addpath("../configs");

sNSGA_eff_400;


fncs = {@SMOP1, @SMOP2, @SMOP3, @SMOP4, @SMOP5, @SMOP6, @SMOP7, @SMOP8};



parfor f = 1:numel(fncs)
    prob = fncs{f}();
    
    optimal_hv = CalcHV(prob.optimum, prob.optimum);

    fprintf("SMOP%d %f\n", f, optimal_hv);
end

