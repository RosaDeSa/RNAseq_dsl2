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
