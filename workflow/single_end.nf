//modules required for single end analysis
include { s_fastqc } from './../modules/single_end/s_fastqc.nf'
include { s_trimming } from './../modules/single_end/s_trimming.nf'
include { alignment } from './../modules/alignment.nf'
include { samtools } from './../modules/samtools.nf'
include { countTable } from './../modules/countTable.nf'
include { multiqc } from './../modules/multiqc.nf'


//workflow for single end analysis
workflow single_end {
   take:
    reads
   
   main:
    s_fastqc(reads)
    s_trimming(reads)
    alignment(s_trimming.out.samples_trimmed)
    samtools(alignment.out[0])
    countTable(alignment.out[0])
    multiqc(s_fastqc.out.collect(),
            s_trimming.out[1].collect(),
            s_trimming.out[2].collect(),
            alignment.out[1].collect(),
            countTable.out[1].collect()
           )
    
   emit:
    multiqc_r = multiqc.out[0]
   }
