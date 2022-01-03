process umitools {
  tag 'Umi tools'
  publishDir "${params.outdir}/umi"
  
  input:
  tuple val(sample_id), path(reads)
  
  output:
  tuple val(sample_id), path('*fastq.gz')
  
  script:
  """
  umi_tools extract \
   -p NNNNNNNNNNNN \
   -I ${reads[0]} \
   -S ${sample_id}_processed_1.fastq.gz \
   --read2-in=${reads[1]} \
   --read2-out=${sample_id}_processed_2.fastq.gz
  """
}
