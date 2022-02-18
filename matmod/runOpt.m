function final_objs = runOpt(algorithm, D, sparsity, prob,sps_on)

    % Path to the install path of plat EMO 
    addpath(genpath('/Users/iankropp/Projects/platEMO/'));
    addpath(genpath('/Users/iankropp/Projects/platEMO/Public'));

    
    [workingDir, name, ext]= fileparts(mfilename('fullpath'));
    addpath(workingDir);

    [Dec, Obj, Con] = platemo('algorithm', algorithm        , ...
                              'problem'  , {prob , sparsity}, ...
                              'N'        , 50               , ...
                              'maxFE'    , 20000            , ...
                              'N'        , 100              , ...
                              'M'        , 2                , ...
                              'D'        , D                , ...
                              'outputFcn', @nop);
                          %                               'D'        , D)

    cd(workingDir);

    final_objs = Obj;  
    

    
    
end


