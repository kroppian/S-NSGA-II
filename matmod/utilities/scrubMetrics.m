

%% Setup 

clear

addpath("configs");
addpath("utilities");
addpath("plotting");
addpath("problems")

inptut_dir = 'C:\Users\i-kropp\Projects\cropover\matmod\data\rawoutputs\';
output_dir = 'C:\Users\i-kropp\Projects\cropover\matmod\data\';

sNSGA_comparative_decVar_sparseSR

%% Main loop

% Iterate through the .mat files in the directory 
files = dir([inptut_dir,'*.mat']);
for file = files'

    fprintf("Loading file %s...\n", file.name);

    %% Load data
    res_final= load([inptut_dir, '\', file.name], 'res_final');

    res_final = res_final.res_final;

    disp("Fixing NNS...");
    res_fixed = fixNNS(res_final);

%     disp("Calculating IGD");
%     res_fixed = calcIGD(res_fixed);

    disp("Saving...");

    res_final = res_fixed;
    save([output_dir, file.name], 'res_final', '-v7.3');

    disp("Done.");


end




function new_res = calcIGD(res)

    rowsOfData = size(res, 1);

    igd = zeros(rowsOfData,1);

    for r = 1:rowsOfData
        pop = res{r, 'population'}{1};
    end

    % nds is the old name for nns
    res.igd = igd;

    new_res = res;

end

function new_res = fixNNS(res)

    rowsOfData = size(res, 1);

    nns = zeros(rowsOfData,1);

    for r = 1:rowsOfData
        pop = res{r, 'population'}{1};

        objs = pop.best.objs;

        unique_individs = unique(objs, 'rows');

        nns(r) = size(unique_individs,1);

    end

    % nds is the old name for nns
    res.nds = nns;

    new_res = res;

end
