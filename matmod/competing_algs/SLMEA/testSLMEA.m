
clear;

% Change to your own local path
addpath("/Users/iankropp/Projects/PlatEMO-3.5/PlatEMO");

platemo(                                             ...
          'algorithm',  @SLMEA                     , ...
          'problem'  ,  {@SMOP7, 0.9}              , ...
          'maxFE'    ,  20000                      , ...
          'N'        ,  100                        , ...
          'M'        ,  2                          , ...
          'D'        ,  100                        , ...
          'save'     ,  20000);