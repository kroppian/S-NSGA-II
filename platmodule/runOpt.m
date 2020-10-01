function  runOpt(algorithm, D)

    % Path to the install path of plat EMO 
    platEMOPath = '/Users/iankropp/Projects/platEMO/';
    [workingDir, name, ext]= fileparts(mfilename('fullpath'));
    addpath(genpath(platEMOPath));
    addpath(workingDir);

    prob = @SMOP8;
    
    Global = GLOBAL_SPS('-algorithm',algorithm,'-problem',prob,'-N',100,'-M',2, '-D', D);

    final_objs = Global.Start();
    
    disp(final_objs);

    cd(workingDir);

end


