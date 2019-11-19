#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

withFiles = args[grepl("with_run.*\\.csv", args)]
withoutFiles = args[grepl("without_run.*\\.csv", args)]
#x11()


i = 0
for (file in withFiles){
  print(file)
  data = read.csv(file)
  if (i == 0)
    plot(data[,1],data[,2],col = "red")
  else
    points(data[,1],data[,2],col = "red")
  i = i + 1
}

for (file in withoutFiles){
  print(file)
  data = read.csv(file)
  if (i == 0)
    points(data[,1],data[,2],col = "blue")
  else
    points(data[,1],data[,2],col = "blue")
  i = i + 1
}

