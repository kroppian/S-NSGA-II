max_ref = 7; 

config = run_config('M:\Projects\PlatEMO_3.4.0\PlatEMO\',  ...    %   platPath          
                    'M:\Projects\cropover\matmod\sNSGAII', ...    %   sNSGAIIPath       
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




