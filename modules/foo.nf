process foo {
 echo true
 
 script:
 """
 #!/usr/bin/env Rscript
 print(paste("GTf is here:", $params.gtf))
 """
 }
