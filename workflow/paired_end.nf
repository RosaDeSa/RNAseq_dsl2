//modules required for single end analysis
include { p_fastqc } from './../modules/paired_end/p_fastqc.nf'
include { umitools } from './../modules/paired_end/umitools.nf'
include { p_trimming } from './../modules/paired_end/p_trimming.nf'
include { alignment } from './../modules/alignment.nf'
include { samtools } from './../modules/samtools.nf'
include { p_deduplication } from './../modules/paired_end/p_deduplication.nf'
include { countTable } from './../modules/countTable.nf'
include { multiqc } from './../modules/multiqc.nf'

//workflow for single end analysis
workflow paired_end {
   take:
    reads
   
   main:
    p_fastqc(reads)
    umitools(reads)
    p_trimming(reads,umitools.out)
    alignment(p_trimming.out.samples_trimmed)
    samtools(alignment.out[0])
    p_deduplication(samstools.out)
   }
