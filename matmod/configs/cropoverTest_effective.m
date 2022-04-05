max_ref = 7; 

comp = 'c';

if comp == 'a'
    platPath = 'M:\Projects\PlatEMO_3.4.0\PlatEMO\';
    sNSGAIIPath = 'M:\Projects\cropover\matmod\sNSGAII';
elseif comp == 'b'
    platPath = 'C:\Users\Ian Kropp\Projects\PlatEMO-3.4\PlatEMO';
    sNSGAIIPath = 'C:\Users\Ian Kropp\Projects\cropover\matmod\sNSGAII';
elseif comp == 'c'
    platPath = '/Users/iankropp/Projects/PlatEMO-3.4/PlatEMO';
    sNSGAIIPath = '/Users/iankropp/Projects/cropover/matmod/sNSGAII';
end

config = run_config(platPath,                                                 ...    %   platPath          
                    sNSGAIIPath,                                              ...    %   sNSGAIIPath       
                    4,                                                        ...    %   repetitions        ( TODO revert)
                    {@sNSGAII, @sNSGAII},                                     ...    %   algorithms          
                    { {@stripedSparseSampler, 0.5, 1},                        ...    %   pop sampling 
                      {@sparseSampler, 0.5, 1}},  ...  
                    {@sparsePolyMutate, @sparsePolyMutate},                   ...    %   mutation_method      
                    {@cropover_v1, @cropover_v1},                             ...    %   crossover_method            
                    ["With mutation", "Without mutation"],                    ...    %   labels         
                    "Mutation",                                               ...    %   run_label         
                    max_ref,                                                  ...    %   max_ref           
                    1:max_ref,                                                ...    %   refPoints         
                    @SMOP8,                                                   ...    %   prob              
                    true,                                                     ...    %   indep_var_dec_vars
                    100,                                                      ...    %   defaultDecVar     
                    0.1,                                                      ...    %   defaultSparsity   
                    [100, 500, 1000, 2500],                                   ...    %   Dz                (TODO revert)             
                    linspace(0.05, 0.45,2),                                   ...    %   sparsities        (TODO revert)
                    "compDecVar")       ;                                            %   runType           





