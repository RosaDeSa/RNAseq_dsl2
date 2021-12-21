include { p_fastqc } from './../modules/paired_end/p_fastqc.nf'
include { p_trimming } from './../modules/paired_end/p_trimming.nf'
include { alignment } from './../modules/alignment.nf'
include { samtools } from './../modules/samtools.nf'
include { countTable } from './../modules/countTable.nf'
include { multiqc } from './../modules/multiqc.nf'

workflow paired_end {
   take:
    reads
   
   main:
    p_fastqc(reads)
    p_trimming(reads)
    alignment(p_trimming.out.samples_trimmed)
    samtools(alignment.out[0])
    countTable(alignment.out[0])
    multiqc(p_fastqc.out.collect(),
            p_trimming.out[1].collect(),
            p_trimming.out[2].collect(),
            alignment.out[1].collect(),
            countTable.out[1].collect()
           )
    
   emit:
    multiqc_r = multiqc.out[0]
   }
