/*
 * Step 5. Generate count table
 */
 
process countTable {
    tag "Generate count table"
    publishDir "${params.outdir}/countTable", mode: 'copy'
    
    input:
    tuple val(sample_id), file(bam)
    
    output:
    path '*count.out'
    path '*.summary'
    
    
    script:
    """
    featureCounts -t exon -a $params.gtf -o ${sample_id}.count.out -T 8 ${bam}
    """
}
