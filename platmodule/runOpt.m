function final_objs = runOpt(algorithm, D, prob, sps_on)

    % Path to the install path of plat EMO 
    addpath(genpath('/Users/iankropp/Projects/platEMO/'));
    addpath(genpath('/Users/iankropp/Projects/platEMO/Public'));

    
    [workingDir, name, ext]= fileparts(mfilename('fullpath'));
    addpath(workingDir);

    
    Global = GLOBAL_SPS('-algorithm',algorithm,'-evaluation', 20000,'-problem',prob,'-N',100,'-M',2, '-D', D,'-outputFcn', @nop);

    if sps_on
        Global.sps_on = true;
    end
    
    final_objs = Global.Start();
    
    
    cd(workingDir);

    
    
end


