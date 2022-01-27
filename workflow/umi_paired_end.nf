//modules required for paired end analysis with umi
include { p_fastqc } from './../modules/paired_end/p_fastqc.nf'
include { umitools } from './../modules/umitools.nf'
include { umi_p_trimming } from './../modules/paired_end/umi_p_trimming.nf'
include { alignment } from './../modules/alignment.nf'
include { samtools } from './../modules/samtools.nf'
include { deduplication } from './../modules/deduplication.nf'
include { countTable } from './../modules/countTable.nf'
include { multiqc } from './../modules/multiqc.nf'

//workflow for single end analysis
workflow umi_paired_end {
   take:
    reads
    starconf
   
   main:
    p_fastqc(reads)
    umitools(reads)
    umi_out = umitools.out.join(reads)
    umi_p_trimming(umi_out)
    alignment(umi_p_trimming.out.samples_trimmed)
    samtools(alignment.out[0])
    for_dedup = samtools.out.join(alignment.out[0])
    deduplication(for_dedup)
    countTable(deduplication.out.dedup_bam)
    multiqc(p_fastqc.out.collect(),
            umi_p_trimming.out[1].collect(),
            umi_p_trimming.out[2].collect(),
            alignment.out[1].collect(),
            countTable.out[1].collect()
            )

   emit:
    multiqc_r = multiqc.out[0]
}
