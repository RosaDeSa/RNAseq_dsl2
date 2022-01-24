//modules required for single end analysis with umi
include { s_fastqc } from './../modules/single_end/s_fastqc.nf'
include { umitools } from './../modules/umitools.nf'
include { umi_s_trimming } from './../modules/single_end/umi_s_trimming.nf'
include { alignment } from './../modules/alignment.nf'
include { samtools } from './../modules/samtools.nf'
include { deduplication } from './../modules/deduplication.nf'
include { countTable } from './../modules/countTable.nf'
include { multiqc } from './../modules/multiqc.nf'

//workflow for single end analysis
workflow umi_single_end {
   take:
    reads
    starconf
   
   main:
    s_fastqc(reads)
    umitools(reads)
    umi_s_trimming(umitools.out)
}
