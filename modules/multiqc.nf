/*
 * Step 6. Multiqc
 */

process multiqc {
    tag "Generate MultiQC"
    cpus 1
    executor 'slurm'
    publishDir "${params.outdir}/multiqc", mode: 'copy'
	
    input:
    file ('fastqc/*')
    file ('postTrimQC/*')
    file ('trimming/*')
    path ('mapped/*')
    path ('*.summary')
    
    
    output:
    file("multiqc_posttrim_report.html")
    file("multiqc_posttrim_report_data")
    
    script:
    """
    multiqc . -n multiqc_posttrim_report.html
    """
}