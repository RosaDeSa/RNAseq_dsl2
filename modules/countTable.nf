/*
 * Step 5. Generate count table
 */
 
process countTable {
    tag "Generate count table"
    cpus 3
    executor 'slurm'
    publishDir params.outdir, mode: 'copy'
    
    input:
    tuple val(sampleId), file(bam)
    
    output:
    path '*count.out'
    path '*.summary'
    
    
    script:
    """
    featureCounts -t exon -a $params.gtf -o ${sampleId}.count.out -T 8 ${bam}
    """
}
