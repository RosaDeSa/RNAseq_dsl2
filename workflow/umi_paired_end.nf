//modules required for paired end analysis with umi
include { p_fastqc } from './../modules/paired_end/p_fastqc.nf'
include { umitools } from './../modules/umitools.nf'
include { p_trimming } from './../modules/paired_end/p_trimming.nf'
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
    p_fastqc(reads)
    umitools(reads)
    p_trimming(reads,umitools.out)
    alignment(p_trimming.out.samples_trimmed)
    samtools(alignment.out[0])
    deduplication(alignment.out[0], samtools.out)
    countTable(deduplication.out.dedup_bam)
    multiqc(p_fastqc.out,
            p_trimming.out[1],
            p_trimming.out[2],
            alignment.out[1],
            countTable.out[1]
            )
   }
