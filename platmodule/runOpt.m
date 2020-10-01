function final_objs = runOpt(algorithm, D, sps_on)

    % Path to the install path of plat EMO 
    platEMOPath = '/Users/iankropp/Projects/platEMO/';
    [workingDir, name, ext]= fileparts(mfilename('fullpath'));
    addpath(genpath(platEMOPath));
    addpath(workingDir);

    prob = @SMOP8;
    
    Global = GLOBAL_SPS('-algorithm',algorithm,'-problem',prob,'-N',100,'-M',2, '-D', D, '-outputFcn', @nop);

    if sps_on
        Global.sps_on = true;
    end
    
    final_objs = Global.Start();
    
    
    cd(workingDir);

    
    
end


