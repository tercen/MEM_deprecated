library(tercen)
library(dplyr)
library(flowCore)
library(FlowSOM)
library(MEM)

options("tercen.workflowId" = "7eee20aa9d6cc4eb9d7f2cc2430313b6")
options("tercen.stepId"     = "6189b041-008a-4435-a0b2-fba24ae5386d")


heatmap(MEM.matrix)

data <- (ctx = tercenCtx()) %>% 
  select(.ci, .ri, .y)  %>%
  reshape2::acast(.ci ~ .ri, value.var = ".y", fill=NaN, fun.aggregate = mean) %>%
  as_tibble()

cluster <- as.numeric(as.vector((ctx$select(ctx$colors)[[1]])))
# colnames(data) <- ctx$rselect()[[1]]
data <- cbind(data, cluster)

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

MEM.matrix <- MEM.values.uf[[5]][[1]]
MEM_vals_scale = as.matrix(round(MEM.matrix, 0))
MEM.labels <- MEM:::create.labels(MEM_vals_scale, display.thresh = 1, MEM.matrix)
MEM.matrix <- as.data.frame(MEM.matrix)
# MEM.matrix <- cbind.data.frame(MEM.matrix, MEM.labels)
# return(MEM.matrix)

# MEM.matrix$.ci <- seq_len(nrow(MEM.matrix))-1
toret <- tidyr::gather(MEM.matrix, .ri, mem)
toret %>% ctx$addNamespace() %>%
  ctx$save()

heatmap(MEM.values.uf[[5]][[1]], labRow = MEM.labels)
