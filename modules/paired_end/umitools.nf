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
   --stdin=${reads[0]} \
   --bc-pattern=$params.pattern \
   --stdout ${sammple_id}_processed.fastq.gz
  """
}
