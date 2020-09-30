

function  runOpt(algorithm, D)

    % Path to the install path of plat EMO 
    platEMOPath = '/Users/iankropp/Projects/platEMO/';
    [workingDir, name, ext]= fileparts(mfilename('fullpath'));
    addpath(platEMOPath);
    addpath(workingDir);
    addpath(strcat(workingDir, '/NSGAII_SS'));

    prob = @SMOP8;

    main('-algorithm',algorithm,'-problem',prob,'-N',100,'-M',2, '-D', D, '-outputFcn', @writeFinalGen);

    fprintf("It worked!\n")

    cd(workingDir);

end


