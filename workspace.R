library(tercen)
library(dplyr)
library(tidyr)
library(flowCore)
#library(FlowSOM)
library(MEM)


options("tercen.workflowId" = "3af2d8241c5193c9f386b9ebc100d804")
options("tercen.stepId"     = "0341888c-b673-458c-838e-1657a0d1e16d")

do.mem <- function(df) {
  data<-pivot_wider(df,names_from = .ri, values_from = .y)
  data <- data[,-1]
  colnames(data)[1] <- "cluster"
  cluster<-data[,1]
  data <- data[, c(seq_along(colnames(data))[-1], 1)] #cluster must be last column for MEM...
  data<-as.matrix(data)
  
  MEM.values.uf_wf = MEM(
    data,
    #dat@exprs,
    transform = FALSE,
    cofactor = 0,
    choose.markers = FALSE,
    markers = "all",
    choose.ref = FALSE,
    zero.ref = FALSE,
    rename.markers = FALSE,
    new.marker.names = "none",
    file.is.clust = FALSE,
    add.fileID = FALSE,
    IQR.thresh = NULL
  )
  MEM.matrix_wf <- data.frame(MEM.values.uf_wf[[5]][[1]])
  MEM.matrix_wf$.ci <- c(1:nrow(MEM.matrix_wf))-1
  
  out<-pivot_longer(MEM.matrix_wf,cols =c(colnames(MEM.matrix_wf),-.ci), names_to = ".ri", values_to = "value")
  out$.ri <- as.numeric(gsub("X", "", out$.ri))
  return(out)
}

ctx <- tercenCtx()

ctx %>% 
  select(.sids,.ci, .ri, .y) %>% 
  do(do.mem(.)) %>%
  ctx$addNamespace() %>%
  ctx$save()


