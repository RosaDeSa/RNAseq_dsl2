workflow paired_end {
   take:
    reads
   
   main:
    p_fastqc(reads)
    p_trimming(reads)
    alignment(p_trimming.out.samples_trimmed)
    
   emit:
    bam = alignment.out[0]
    mapped = alignment.out[1]
   }
