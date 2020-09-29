

% Path to the install path of plat EMO 
platEMOPath = '/Users/iankropp/Projects/platEMO/';
[workingDir, name, ext]= fileparts(mfilename('fullpath'));
addpath(platEMOPath);
addpath(workingDir);
addpath(strcat(workingDir, '/NSGAII_SS'));

prob = @SMOP8;

main('-algorithm',@NSGAII_SS,'-problem',prob,'-N',100,'-M',2, '-D', 2000);


main('-algorithm',@SparseEA,'-problem',prob,'-N',100,'-M',2, '-D', 2000);


main('-algorithm',@NSGAII,'-problem',prob,'-N',100,'-M',2, '-D', 2000);


cd(workingDir);