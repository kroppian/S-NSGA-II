
clear;

refPoint = [7,7];


% Path to the install path of plat EMO 
addpath(genpath('/Users/iankropp/Projects/platEMO/'));
addpath(genpath('/Users/iankropp/Projects/platEMO/Public'));


[workingDir, name, ext]= fileparts(mfilename('fullpath'));
addpath(workingDir);

fncs = {SMOP1, SMOP2, SMOP3, SMOP4, SMOP5, SMOP6, SMOP7, SMOP8};
fncs_names = {'SMOP1', 'SMOP2', 'SMOP3', 'SMOP4', 'SMOP5', 'SMOP6', 'SMOP7', 'SMOP8'};

parfor f = 1:numel(fncs)
    ref_front = fncs{f}.Global.PF;
    hv = CalHV(ref_front, refPoint);
    fprintf("HV for %s is %f\n", fncs_names{f}, hv);

end

