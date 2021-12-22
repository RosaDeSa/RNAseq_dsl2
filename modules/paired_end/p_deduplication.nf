process p_deduplication {
 tag 'Deduplication'
 label 'deduplication'
 publishDir "${params.outdir}/deduplication"
 
 input:
 tuple val(sample_id), file(sorted_bai)
 
 output:
 tuple val(sample_id), file(ded_bam)
 
 script:
 """
 umi_tools dedup -I ${sorted_bai} --output-stats=${sample_id}_deduplicated -S ${sample_id}_deduplicated.bam
 """
}
