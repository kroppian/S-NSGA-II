max_ref = 7; 

comp = 'b';

if comp == 'a'
    platPath = 'M:\Projects\PlatEMO_3.4.0\PlatEMO\';
    sNSGAIIPath = 'M:\Projects\cropover\matmod\sNSGAII';
elseif comp == 'b'
    platPath = 'C:\Users\Ian Kropp\Projects\PlatEMO-3.4';
    sNSGAIIPath = 'C:\Users\Ian Kropp\Projects\cropover\matmod\sNSGAII';

end



config = run_config(platPath,                              ...    %   platPath          
                    sNSGAIIPath,                           ...    %   sNSGAIIPath       
                    4,                                     ...    %   repetitions        ( TODO revert)
                    {@sNSGAII, @SparseEA2},                ...    %   algorithms        
                    {false, true},                         ...    %   sps_on            
                    ["SparseEA2", "sNSGAII"],              ...    %   labels            
                    "comparative",                         ...    %   run_label         
                    max_ref,                               ...    %   max_ref           
                    1:max_ref,                             ...    %   refPoints         
                    @SMOP1,                                ...    %   prob              
                    true,                                  ...    %   indep_var_dec_vars
                    1000,                                  ...    %   defaultDecVar     
                    0.1,                                   ...    %   defaultSparsity   
                    [100, 500, 1000, 2500],                ...    %   Dz                (TODO revert)             
                    linspace(0.05, 0.45,2),                ...    %   sparsities        (TODO revert)
                    "compDecVar")       ;                         %   runType           




