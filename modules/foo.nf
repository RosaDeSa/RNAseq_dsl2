process foo {
 echo true
  
 input:
 file(multiqc)
 
 script:
 """
 echo --multiqc $multiqc
 """
 }
