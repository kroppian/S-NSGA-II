max_ref = 7; 

comp = 'b';

if comp == 'a'
    platPath = 'M:\Projects\PlatEMO_3.4.0\PlatEMO\';
    sNSGAIIPath = 'M:\Projects\cropover\matmod\sNSGAII';
elseif comp == 'b'
    platPath = 'C:\Users\Ian Kropp\Projects\PlatEMO-3.4\PlatEMO';
    sNSGAIIPath = 'C:\Users\Ian Kropp\Projects\cropover\matmod\sNSGAII';
elseif comp == 'c'
    platPath = '/Users/iankropp/Projects/PlatEMO-3.4/PlatEMO';
    sNSGAIIPath = '/Users/iankropp/Projects/cropover/matmod/sNSGAII';
elseif comp == 'd'
    platPath = '/home/ian/Projects/PlatEMO-3.4/PlatEMO';
    sNSGAIIPath = '/home/ian/Projects/cropover/matmod/sNSGAII';
end

config = run_config(platPath,                                                 ...    %   platPath          
                    sNSGAIIPath,                                              ...    %   sNSGAIIPath       
                    30,                                                       ...    %   repetitions    
                    {@sNSGAII_island , @SparseEA, @SparseEA2},                ...    %   algorithms          
                    {{@stripedSparseSampler, 0.5, 0.99}, @nop, @nop},         ...    %   sampling_method
                    {@sparsePolyMutate, @nop, @nop},                          ...    %   mutation_method      
                    {@cropover_v1, @nop, @nop},                               ...    %   crossover_method   
                    ["sNSGA-II", "SparseEA", "SparseEA2"],                    ...    %   labels         
                    "sNSGAIIComparative",                                     ...    %   run_label         
                    max_ref,                                                  ...    %   max_ref           
                    1:max_ref,                                                ...    %   refPoints         
                    @SMOP1,                                                   ...    %   prob              
                    true,                                                     ...    %   indep_var_dec_vars
                    100,                                                      ...    %   defaultDecVar     
                    0.1,                                                      ...    %   defaultSparsity   
                    [100, 200, 400, 800, 1600, 3200, 6400],                   ...    %   Dz                          
                    linspace(0.05, 0.45,2),                                   ...    %   sparsities        (TODO revert)
                    "compDecVar",                                             ...    %   runType           
                    true,                                                     ...    %   saveData
                    "/mnt/nas/kroppian/sNSGAIIRuns/",                         ...    %   savePath
                    false                                                     ...    %   saveAllGens
                    ); 





