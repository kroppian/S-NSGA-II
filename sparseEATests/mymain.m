

% Path to the install path of plat EMO 
platEMOPath = '/Users/iankropp/Projects/platEMO/';
[workingDir, name, ext]= fileparts(mfilename('fullpath'));
addpath(platEMOPath);
addpath(workingDir);
addpath(strcat(workingDir, '/NSGAII_SS'));


main('-algorithm',@NSGAII_SS,'-problem',@DTLZ2,'-N',100,'-M',10);


cd(workingDir);