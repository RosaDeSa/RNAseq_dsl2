/*
 * Step 3. Alignment reads to human index genome
 */

process alignment {
    echo true
    tag "Align Reads"
    cpus 16
    executor 'slurm'
    memory '35GB'
    publishDir "$params.outdir", mode: 'copy'

    input:
    tuple val(sampleId), file(reads)
    
    output:
    tuple val(sampleId), file('mapped/*.bam')
    file('mapped/*.final.out')
    
    script:
    """
    STAR --runMode alignReads \
	--genomeDir $params.index \
	--outSAMtype BAM SortedByCoordinate \
	--readFilesIn ${reads} \
	--runThreadN 16 \
	--outFileNamePrefix mapped/${sampleId}_ \
	--outFilterMultimapNmax 1 \
	--twopassMode Basic \
        --readFilesCommand zcat 
    """
}