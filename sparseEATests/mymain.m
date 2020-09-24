

% Path to the install path of plat EMO 
platEMOPath = '/Users/iankropp/Projects/platEMO/';
workingDir = pwd;
addpath(platEMOPath);
addpath(workingDir);
addpath(strcat(workingDir, '/NSGAII_SS'));


main('-algorithm',@NSGAII_SS,'-problem',@DTLZ2,'-N',200,'-M',10);


cd(workingDir);