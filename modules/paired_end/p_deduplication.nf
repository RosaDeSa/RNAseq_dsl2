process deduplication {
 tag 'Deduplication'
 
 input:
 tuple val(sample_id), file(sorted_bam)
 
 output:
 tuple val(sample_id), file(ded_bam)
 
 script:
 """
 umi_tools dedup -I $sorted_bam --output-stats=${sample_id}_deduplicated -S ${sample_id}_deduplicated.bam
 """
}
