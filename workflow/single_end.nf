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
