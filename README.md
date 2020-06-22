# MEM operator

##### Description

`Marker Enrichment Modeling` operator for flow cytometry data.


##### Usage

Input projection|.
---|---
`row`   | represents the variables (e.g. channels, markers)
`col`   | represents the clusters (e.g. cells) 
`colors`   | represents the groups (e.g. flowSOM clusters) 
`y-axis`| is the value of measurement signal of the channel/marker

Output relations|.
---|---
`mem`| numeric, mem scores per row and per color (e.g. per channel/marker and per flowSOM clusters)
`cluster`| character, cluster value

##### Details

The operator is a wrapper for the `MEM` function of the `MEM` R package.

#### References

https://github.com/cytolab/mem

##### See Also

[flowsom_operator](https://github.com/tercen/flowsom_operator)

[flowsom_mst_shiny_operator](https://github.com/tercen/flowsom_mst_shiny_operator)

