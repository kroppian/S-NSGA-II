classdef run_result
    %RUN_RESULT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        HVResults
        timeResults
        noNonDoms
        final_pops
        globalTimeEnd
    end
    
    methods
        function obj = run_result(HVResults, timeResults, noNonDoms, final_pops, globalTimeEnd)
            %RUN_RESULT Construct an instance of this class
            %   Detailed explanation goes here
            obj.HVResults     =     HVResults     ; 
            obj.timeResults   =     timeResults   ;
            obj.noNonDoms     =     noNonDoms     ;
            obj.final_pops    =     final_pops    ;
            obj.globalTimeEnd =     globalTimeEnd ;      
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

