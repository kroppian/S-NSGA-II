

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

%     disp("Fixing NNS...");
%     res_fixed = fixNNS(res_final);

    disp("Calculating IGD");
    optimum = getTestFncOptim(file.name);
    res_fixed = calcIGD(res_final, optimum);

    disp("Saving...");

    res_final = res_fixed;
    save([output_dir, file.name], 'res_final', '-v7.3');

    disp("Done.");


end




function new_res = calcIGD(res, optimum)

    rowsOfData = size(res, 1);

    igd = zeros(rowsOfData,1);

    for r = 1:rowsOfData
        pop = res{r, 'population'}{1};
        igd(r) = IGD(pop, optimum);
    end

    res.igd = igd;

    new_res = res;

end

function new_res = fixNNS(res, optimum)

    rowsOfData = size(res, 1);

    nns = zeros(rowsOfData,1);

    for r = 1:rowsOfData
        pop = res{r, 'population'}{1};

%         full_pop_properties = [pop.best.objs, pop.best.decs];
%         unique_individs = unique(full_pop_properties, 'rows');
        %strcmp(res{r,'alg'}{1}, 'sNSGAII-VariedStripedSparseSampler_v3-sparsePolyMutate-cropover_v2')
        %full_pop_properties = [pop.best.objs, pop.best.decs];
        unique_individs = unique(pop.best.objs, 'rows');

        nns(r) = size(unique_individs,1);

    end

    % nds is the old name for nns
    res.nds = nns;

    new_res = res;

end

function optimum = getTestFncOptim(file_name)
    
    if contains(file_name, "SMOP1")
        funcell = {@SMOP1};
    elseif contains(file_name, "SMOP2")
        funcell = {@SMOP2};
    elseif contains(file_name, "SMOP3")
        funcell = {@SMOP3};
    elseif contains(file_name, "SMOP4")
        funcell = {@SMOP4};
    elseif contains(file_name, "SMOP5")
        funcell = {@SMOP5};
    elseif contains(file_name, "SMOP6")
        funcell = {@SMOP6};
    elseif contains(file_name, "SMOP7")
        funcell = {@SMOP7};
    elseif contains(file_name, "SMOP8")
        funcell = {@SMOP8};
    else
        error("No test function associated with this file.");
    end

    % I wish I knew a better way of doing this
    func = funcell{1}();

    optimum = func.optimum; 

end

