#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)
png(filename="plot.png", width = 960, height = 960, units = "px", pointsize = 20 )

#x11()

minSparsity = 0
maxSparsity = 19 


#layout(matrix(minSparsity:maxSparsity, ncol = 5))

old.par <- par(mfrow=c(4,5))

currentMax1 = 0
currentMax2 = 0

xmax = 8200
ymax = 800000


for(sparsity in minSparsity:maxSparsity){

  sparsityStr = sprintf("%02d", sparsity)

  print(paste0("with_run.*", sparsityStr, "\\.csv"))

  withFiles = args[grepl(paste0("with_run.*", sparsityStr, "\\.csv"), args)]
  withoutFiles = args[grepl(paste0("without_run.*", sparsityStr, "\\.csv"), args)]

  xlabel = expression('Y'[1])
  ylabel = expression('Y'[2])
  title = paste("Sampling Sparsity", sparsity)
  

  filesFoundWith = length(withFiles)
  filesFoundWithout = length(withoutFiles)

  if(filesFoundWith != filesFoundWithout){
    print("Files with and files with out don't match") 
    stop()
  }

  if(filesFoundWith == 0){
    print("No files given") 
    stop()
  }

  print(paste(filesFoundWith, " files found with sparsity ", sparsity))

  i = 0
  for (file in withFiles){
    data = read.csv(file)
    if (i == 0)
      plot(data[,1],data[,2],col = "red", xlab=xlabel, ylab=ylabel, main=title, xlim=c(0,xmax), ylim=c(0,ymax))
    else
      points(data[,1],data[,2],col = "red")
    i = i + 1
    currentMax1 = max(c(currentMax1, data[,1])) 
    currentMax2 = max(c(currentMax2, data[,2])) 
  }

  for (file in withoutFiles){
    data = read.csv(file)
    if (i == 0)
      points(data[,1],data[,2],col = "blue")
    else
      points(data[,1],data[,2],col = "blue")
    i = i + 1
    currentMax1 = max(c(currentMax1, data[,1])) 
    currentMax2 = max(c(currentMax2, data[,2])) 
  }
  

}

print(paste("Max 1:", currentMax1))
print(paste("Max 2:", currentMax2))

par(old.par)

dev.off()

