process deduplication {
 tag 'Deduplication'
 label 'deduplication'
 publishDir "${params.outdir}/deduplication"
 
 input:
 tuple val(sample_id), file(bai), file(sorted)
 
 output:
 tuple val(sample_id), file('*deduplicated.bam'), emit: dedup_bam
 
 script:
 """
 umi_tools dedup -I ${sorted} -S ${sample_id}_deduplicated.bam
 """
}
