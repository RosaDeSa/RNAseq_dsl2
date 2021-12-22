/*
 * Step 4. Index the BAM file
 */

process samtools {
    tag "Samtools"
    publishDir "${params.outdir}/samtools", mode: 'copy'
    
    input:
    tuple val(sample_id), file(bam)
    
    output:
    tuple val(sample_id), file('*.bai')
    tuple val(sample_id), file('*index_sorted.bam')
    
    script:
    """
    samtools sort $bam -o ${sample_id}_sorted.bam
    samtools index ${sample_id}_sorted.bam > ${sample_id}_index_sorted.bam
    """
}
