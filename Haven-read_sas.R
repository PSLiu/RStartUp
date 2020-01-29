### 01. Loading packages ----
library(haven)
library(fst)

### 02. Transfer SAS data to fst for R ----

timeStartO <- Sys.time()

### 02-1. Setting dataset dictionary ----
wd01 <- "C:/File/DataLab/NHIRD_DemoFile2013_SAS_UTF8" # old folder path
wd02 <- "C:/File/DataLab/NHIRD_DemoFile2013_R"        # new folder path

all.sas.1 <- list.files(path = wd01, pattern = ".sas7bdat")
all.fst.1 <- gsub(".sas7bdat", ".fst", all.sas.1)

all.sas.2 <- paste0(wd01, "/", all.sas.1)
all.fst.2 <- paste0(wd02, "/", all.fst.1)


### 02-2. Transfer in for loop ---- 
for (i in 1:length(all.sas.2)) {
  
  # log on
  timeStart <- Sys.time() 
  
  ###   Main Process   ###
  x <- read_sas(all.sas.2[[i]])
  names(x) <- tolower(names(x))
  write_fst(x, all.fst.2[[i]], compress = 100)
  
  # log off
  timeEnd <- Sys.time()   
  difference <- round(difftime(timeEnd, timeStart, units='mins'), digit = 2)
  
  # log print
  print(paste0("Transfer ", all.sas.1[i], " successfully using ", difference, " mins."))
  
  rm(x, timeStart, timeEnd, difference)
  gc()
}

timeEndO <- Sys.time()

print(paste0("Totally use ", round(difftime(timeEndO, timeStartO, units='mins'), digit = 2), " mins."))