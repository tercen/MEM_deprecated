# MEM operator

##### Description

`Marker Enrichment Modeling` operator for flow cytometry data is designed to calculate enrichment scores.


##### Usage

Input projection|.
---|---
`row`   | represents the variables (e.g. channels, markers)
`col`   | represents the clusters (e.g. flowSOM clusters) 
`y-axis`| is the value of measurement signal of the channel/marker

Output relations|.
---|---
`mem`| numeric, mem scores per row and per color (e.g. per channel/marker and per flowSOM clusters)

##### Details

The operator is a wrapper for the `MEM` function of the `MEM` R package.`MEM` generates readable labels that quantify the features enriched in a sample. The classic use of MEM is to identify multiple populations of cells and to compare each population to all of the other remaining cells from the original sample. MEM enrichment scores range from +10 (meaning greatly enriched) through 0 (meaning not enriched) to -10 (meaning greatly lacking).

#### References

https://github.com/cytolab/mem

##### See Also

[flowsom_operator](https://github.com/tercen/flowsom_operator)

[flowsom_mst_shiny_operator](https://github.com/tercen/flowsom_mst_shiny_operator)

