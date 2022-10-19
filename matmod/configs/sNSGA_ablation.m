max_ref = 7; 

comp = "WORKPC";

if comp == "EGR"
    platPath = 'M:\Projects\PlatEMO_3.4.0\PlatEMO\';
    sNSGAIIPath = 'M:\Projects\cropover\matmod\sNSGAII';
elseif comp == "WORKPC"
    platPath = 'C:\Users\i-kropp\Projects\PlatEMO-3.4\PlatEMO';
    sNSGAIIPath = 'C:\Users\Ian Kropp\Projects\cropover\matmod\sNSGAII';
elseif comp == "MAC"
    platPath = '/Users/iankropp/Projects/PlatEMO-3.4/PlatEMO';
    sNSGAIIPath = '/Users/iankropp/Projects/cropover/matmod/sNSGAII';
elseif comp == "GILG"
    platPath = '/home/ian/Projects/PlatEMO-3.4/PlatEMO';
    sNSGAIIPath = '/home/ian/Projects/cropover/matmod/sNSGAII';
end



algorithms =   {@sNSGAII    , @sNSGAII 	       , @sNSGAII         };
mutation_op =  {@polyMutate , @sparsePolyMutate, @sparsePolyMutate};
crossover =    {@cropover_v2, @sbx             , @cropover_v2     };
               
 
pop_samplers = {{@VariedStripedSparseSampler_v3, 0.75, 1}, ...
                {@VariedStripedSparseSampler_v3, 0.75, 1}, ... 
                @nop};

labels = ["No S-PM", ... 
          "No S-SBX", ...
          "MOEA-PSL" ];



config = run_config(platPath,                                                 ...    %   platPath          
                    sNSGAIIPath,                                              ...    %   sNSGAIIPath       
                    30,                                                       ...    %   repetitions    
                    algorithms,                                               ...    %   algorithms          
                    pop_samplers,                                             ...    %   sampling_method
                    mutation_op,                                              ...    %   mutation_method      
                    crossover,                                                ...    %   crossover_method   
                    labels,                                                   ...    %   labels         
                    "sNSGAIIAblation",                                     ...    %   run_label         
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
                    false,                                                    ...    %   saveAllGens
                    @nop); 





