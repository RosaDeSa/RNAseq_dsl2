//modules required for single end analysis
include { s_fastqc } from './modules/single_end/s_fastqc.nf'
include { s_trimming } from './modules/single_end/s_trimming.nf'

//workflow for single end analysis
workflow single_end {
   take:
    reads
   
   main:
    s_fastqc(reads)
    s_trimming(reads)
    alignment(s_trimming.out.samples_trimmed)
   
   emit:
    bam = alignment.out[0]
    mapped = alignment.out[1]
    }
