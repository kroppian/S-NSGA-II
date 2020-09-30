#!/bin/bash

matlab_exec=/Applications/MATLAB_R2020b.app/bin/matlab
com="fprintf('\nSTART\n'); ${1}(${2}); fprintf('\nEND\n');"
scriptFile="/tmp/matlab_command_${2}.m"

echo ${com} > ${scriptFile}

cd "$( dirname "${BASH_SOURCE[0]}" )"
output="$(${matlab_exec} -nojvm -nodisplay -nosplash < ${scriptFile})"

IFS=$'\n'

inPrintRange=false
outPrintRange=false

for line in $output
do
  if [[ $line == 'END' ]]; then
    outPrintRange=true 
  elif [[ $inPrintRange = true && $outPrintRange = false ]]; then
    echo "$line"
  elif [[ $line == 'START' ]]; then
    inPrintRange=true
  fi
done

rm ${scriptFile}



