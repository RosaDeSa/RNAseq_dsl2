include { p_fastqc } from './modules/paired_end/p_fastqc.nf'
include { p_trimming } from './modules/paired_end/p_trimming.nf'

workflow paired_end {
   take:
    reads
   
   main:
    p_fastqc(reads)
    p_trimming(reads)
    alignment(p_trimming.out.samples_trimmed)
    
   emit:
    fastqc_r = p_fastqc.out
    trimming_r = p_trimming.out
    bam = alignment.out
   }
