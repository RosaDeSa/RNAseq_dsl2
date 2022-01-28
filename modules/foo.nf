process foo {
 echo true
 
 script:
 """
 #!/usr/bin/env Rscript
 
 #install pacman
 if (!require("pacman", quietly = TRUE))
  install.packages("pacman") 
 
 #load with pacman package
 pacman::p_load(tidyverse, BiocGenerics, rtracklayer) 
 
 #define load gtf function
 #Function annotation takes in input GTF file (using rtracklater)
 #and selects gene_id and gene_name from column 9 
 load_annotation <- function(fname) {
   fname |> 
     rtracklayer::import() |> 
     BiocGenerics::as.data.frame() |> 
     dplyr::select(gene_id, gene_name) |> 
     dplyr::distinct()
 }
 
 #load gtf
 annotation <- load_annotation(gtf)
 
 #done
 cat('GTF Loaded')
 """
 }
