//modules required for paired end analysis with umi
include { p_fastqc } from './../modules/paired_end/p_fastqc.nf'
include { umitools } from './../modules/umitools.nf'
include { umi_p_trimming } from './../modules/paired_end/umi_p_trimming.nf'
include { alignment } from './../modules/alignment.nf'
include { samtools } from './../modules/samtools.nf'
include { deduplication } from './../modules/deduplication.nf'
include { countTable } from './../modules/countTable.nf'
include { multiqc } from './../modules/multiqc.nf'

//workflow for single end analysis
workflow umi_paired_end {
   take:
    reads
    starconf
   
   main:
    p_fastqc(reads)
    umitools(reads)
}
