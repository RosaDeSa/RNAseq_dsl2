/*
 * Step 3. Alignment reads to human index genome
 */

process alignment {
    tag "Align Reads"
    publishDir "$params.outdir", mode: 'copy'

    input:
    tuple val(sample_id), file(reads)
    
    output:
    tuple val(sample_id), file('mapped/*.bam')
    file('mapped/*.final.out')
    
    script:
    """
    STAR --runMode alignReads \
        --genomeDir $params.index \
        --outSAMtype BAM SortedByCoordinate \
        --readFilesIn ${reads} \
        --runThreadN 7 \
        --outFileNamePrefix mapped/${sample_id}_ \
        --outFilterMultimapNmax 1 \
        --twopassMode Basic \
        --readFilesCommand zcat 
    """
}
