process foo {
 echo true
 
 script:
 """
 #!/usr/bin/env Rscript
 load_annotation <- function(fname) {
 #Function annotation takes in input GTF file (using rtracklater)
 #and selects gene_id and gene_name from column 9 
   fname |> 
     rtracklayer::import() |> 
     BiocGenerics::as.data.frame() |> 
     dplyr::select(gene_id, gene_name) |> 
     dplyr::distinct()
 }

 annotation <- load_annotation(gtf)
 cat('GTF Loaded')
 """
 }
