library(tercen)
library(dplyr)
library(flowCore)
library(FlowSOM)
library(MEM)

options("tercen.workflowId" = "969f44a542c98b7d15717e0d35000cdd")
options("tercen.stepId"     = "e310bd1f-132f-4bbf-bd55-02add0913d86")

getOption("tercen.workflowId")
getOption("tercen.stepId")

getMEM <- function(data) {
  colnames(data) <- ctx$rselect()[[1]]
  dat <- flowCore::flowFrame(as.matrix(data))
  fsom <- FlowSOM(
    dat,
    colsToUse = 1:ncol(dat),
    nClus = 10,
    seed = 1
  )
  FlowSOM.clusters <- as.matrix(fsom[[2]][fsom[[1]]$map$mapping[, 1]])
  
  # Run MEM on the FlowSOM clusters found by using UMAP axes
  cluster = as.numeric(as.vector((FlowSOM.clusters)))
  
  # Run MEM on the FlowSOM clusters from UMAP
  MEM.data = cbind(dat@exprs, cluster)
  
  library(MEM)
  MEM.values.uf = MEM(
    MEM.data,
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
  MEM.matrix <- MEM.values.uf[[5]][[1]]
  MEM_vals_scale = as.matrix(round(MEM.matrix, 0))
  MEM.labels <- MEM:::create.labels(MEM_vals_scale, display.thresh = 1, MEM.matrix)
  
  MEM.matrix <- as.data.frame(MEM.matrix)
  
  MEM.matrix <- cbind.data.frame(MEM.matrix, MEM.labels)
  return((MEM.matrix))
}

(ctx = tercenCtx()) %>% 
  select(.ci, .ri, .y) %>% 
  reshape2::acast(.ci ~ .ri, value.var='.y', fill=NaN, fun.aggregate = mean) %>%
  as_tibble() %>%
  do(getMEM(.)) %>%
  as_tibble()  %>%
  mutate(.ci = seq_len(nrow(.)) - 1) %>%
  # gather(., channel, mem, colnames(.)[-ncol(.)], factor_key=TRUE) %>%
  # mutate(.ri = seq_len(nrow(.)) - 1) %>%
  ctx$addNamespace() %>%
  ctx$save()

heatmap(MEM.matrix)
