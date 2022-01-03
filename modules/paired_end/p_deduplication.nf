process p_deduplication {
 echo true
 tag 'Deduplication'
 label 'deduplication'
 publishDir "${params.outdir}/deduplication"
 
 input:
 tuple val(sample_id), path(sorted)
 
 output:
 tuple val(sample_id), file(dedu_bam)
 
 script:
 """
 umi_tools dedup -I ${sorted} --output-stats=${sample_id}_deduplicated -S ${sample_id}_deduplicated.bam
 """
}
