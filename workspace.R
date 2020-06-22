library(tercen)
library(dplyr)
library(tidyr)
library(flowCore)
library(FlowSOM)
library(MEM)

options("tercen.workflowId" = "a2ac2439e77ba78ceb8f9be37d016b99")
options("tercen.stepId"     = "b6be261e-c536-495e-9ac4-d89c0da2dbe2")

do.mem <- function(df) {
  
  data <- tidyr::spread(df, .ri, .y)
  data <- data[,-1]
  colnames(data)[1] <- "cluster"
  data <- data[, c(seq_along(colnames(data))[-1], 1)] #cluster must be last column for MEM...
  
  dat <- flowCore::flowFrame(as.matrix(data))
  MEM.values.uf = MEM(
    dat@exprs,
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
  MEM.matrix <- data.frame(MEM.values.uf[[5]][[1]])
  MEM.matrix$cluster <- as.numeric(rownames(MEM.matrix))+1
  
  out <- MEM.matrix %>% as_tibble %>% gather(.ri, mem, -cluster)
  out$.ri <- as.numeric(gsub("X", "", out$.ri))
  out$cluster <- as.factor(out$cluster)
  return(out)
  
}

(ctx = tercenCtx()) %>% 
  select(.ci, .ri, .y, .colorLevels)  %>%
  do(do.mem(.)) %>%
  ctx$addNamespace() %>%
  ctx$save()


