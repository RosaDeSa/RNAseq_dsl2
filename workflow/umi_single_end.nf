//modules required for single end analysis with umi
include { s_fastqc } from './../modules/single_end/s_fastqc.nf'
include { umitools } from './../modules/umitools.nf'
include { s_trimming } from './../modules/single_end/s_trimming.nf'
include { alignment } from './../modules/alignment.nf'
include { samtools } from './../modules/samtools.nf'
include { deduplication } from './../modules/deduplication.nf'
include { countTable } from './../modules/countTable.nf'
include { multiqc } from './../modules/multiqc.nf'

//workflow for single end analysis
workflow umi_paired_end {
   take:
    reads
   
   main:
    s_fastqc(reads)
    umitools(reads)
    s_trimming(reads,umitools.out)
    alignment(s_trimming.out.samples_trimmed)
    samtools(alignment.out[0])
    deduplication(alignment.out[0], samtools.out)
    countTable(deduplication.out.dedup_bam)
    multiqc(s_fastqc.out,
            s_trimming.out[1],
            s_trimming.out[2],
            alignment.out[1],
            countTable.out[1]
            )
   }
