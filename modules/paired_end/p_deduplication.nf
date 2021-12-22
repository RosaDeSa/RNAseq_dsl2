process p_deduplication {
 echo true
 tag 'Deduplication'
 label 'deduplication'
 
 input:
 tuple val(sample_id), file(sorted_bai)
 
 output:
 tuple val(sample_id), file(ded_bam)
 
 script:
 """
 echo $sorted_bai
 """
}
