/*
 * Step 3. Alignment reads to human index genome
 */

process alignment {
    tag "Align Reads"
    publishDir "$params.outdir", mode: 'copy'

    input:
    tuple val(sample_id), file(read)
    
    output:
    tuple val(sample_id), file('mapped/*.bam')
    file('mapped/*.final.out')
    
    script:
    """
    STAR --parametersFiles ${params.starconf} \
         --runMode alignReads \
         --genomeDir $params.index \
         --readFilesIn ${read} \
         --outFileNamePrefix mapped/${sample_id}_
    """
}
