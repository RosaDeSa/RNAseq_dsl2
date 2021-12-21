process foo {
 echo true
  
 input:
 tuple val(sample_id), file('mapped/*.bam')
 
 script:
 """
 echo --sample_id $sample_id
 """
 }
