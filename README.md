# MEM operator

##### Description

`Marker Enrichment Modeling` operator.

##### Usage

Input projection|.
---|---
`y-axis`        | numeric, input data, per cell 

Output relations|.
---|---
`median`        | numeric, median of the input data

##### Details

The operator takes all the values of a cell and returns the value which is the median.The computation is done per cell. There is one value returned for each of the input cell.

#### References

https://github.com/cytolab/mem

##### See Also

[flowsom_operator](https://github.com/tercen/flowsom_operator)

[flowsom_mst_shiny_operator](https://github.com/tercen/flowsom_mst_shiny_operator)

#### Examples
