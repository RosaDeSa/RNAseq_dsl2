/*
 * Step 4. Index the BAM file
 */

process samtools {
echo true
    tag "Samtools"
    publishDir "${params.outdir}/samtools", mode: 'copy'
    
    input:
    tuple val(sample_id), file(bam)
    
    output:
    tuple val(sample_id), file('*bai')
    
    script:
    """
    samtools index ${bam} -o ${sample_id}_index.bai
    cp ${bam} ${params.outdir}/samtools
    """
}
