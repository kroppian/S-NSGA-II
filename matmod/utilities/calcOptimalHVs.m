
clear;

refPoint = [7,7];

% Path to the install path of plat EMO 
addpath(genpath('/Users/iankropp/Projects/platEMO/'));
addpath(genpath('/Users/iankropp/Projects/platEMO/Public'));


[workingDir, name, ext]= fileparts(mfilename('fullpath'));
addpath(workingDir);

fncs = {@SMOP1, @SMOP2, @SMOP3, @SMOP4, @SMOP5, @SMOP6, @SMOP7, @SMOP8};
fncs_names = {'SMOP1', 'SMOP2', 'SMOP3', 'SMOP4', 'SMOP5', 'SMOP6', 'SMOP7', 'SMOP8'};



for f = 1:numel(fncs)
    Global = GLOBAL_SPS('-algorithm',@NSGAII,'-evaluation', 20000,'-problem',fncs{f},'-N',100,'-M',2, '-D', 100,'-outputFcn', @nop);
    
    ref_front = Global.problem.PF(100);
        
    hv = CalHV(ref_front, refPoint);
    fprintf("HV for %s is %f\n", fncs_names{f}, hv);
end

