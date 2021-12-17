/*
 * Step 4. Index the BAM file
 */

process samtools {
    echo true
    cpus 2
    executor 'slurm'
    memory '5GB'
    tag "Samtools"
    publishDir "$params.outdir", mode: 'copy'
    
    input:
    tuple val(sampleId), file(bam)
    
    output:
    tuple val(sampleId), file('*.bai')
    path '*.{flagstat,idxstats,stats}'
    
    script:
    """
    samtools index $bam > ${sampleId}.sorted.bam
    samtools flagstat $bam > ${sampleId}.sorted.bam.flagstat
    samtools idxstats $bam > ${sampleId}.sorted.bam.idxstats
    samtools stats $bam > ${sampleId}.sorted.bam.stats
    """
}
