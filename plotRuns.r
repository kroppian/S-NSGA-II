#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

i = 0
for (file in args){
  data = read.csv(file)
  if (i == 0)
    plot(data[,1],data[,2],col = rainbow(length(args))[i])
  else
    points(data[,1],data[,2],col = rainbow(length(args))[i])
  
  i = i + 1
}

