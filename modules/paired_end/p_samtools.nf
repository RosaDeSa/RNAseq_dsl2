/*
 * Step 4. Index the BAM file
 */

process samtools {
    tag "Samtools"
    publishDir "${params.outdir}/alignment", mode: 'copy'
    
    input:
    tuple val(sample_id), file(bam)
    
    output:
    tuple val(sample_id), file('*.bai')
    path '*.{flagstat,idxstats,stats}'
    
    script:
    """
    samtools index $bam > ${sample_id}.sorted.bam
    samtools flagstat $bam > ${sample_id}.sorted.bam.flagstat
    samtools idxstats $bam > ${sample_id}.sorted.bam.idxstats
    samtools stats $bam > ${sample_id}.sorted.bam.stats
    """
}
