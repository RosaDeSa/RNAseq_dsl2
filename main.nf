#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.sampleId = ""

/*
 * Step 0. Set up channel for reads, gtf and genome
 */
 
Channel
    .fromPath(params.sampleId)
    .splitCsv(header:true, sep: ",")
    .map{ row-> tuple(row.sampleId, file(row.read1, checkIfExists: true), file(row.read2, checkIfExists: true)) }
    .set { samples_ch }

Channel
    .fromPath( params.gtf )
    .ifEmpty { error "Cannot find any annotation matching: ${params.gtf}" }
    .set { annot_ch }

 Channel
    .fromPath( params.genome )
    .ifEmpty { error "Cannot find any annotation matching: ${params.genome}" }
    .set { genome_ch }

Channel
    .fromPath( params.index )
    .ifEmpty { error "Cannot find any annotation matching: ${params.index}" }
    .set { index_ch }

samples_ch.view()

/*
 * Step 1. Create fastqc for reads
 */

process fastqc {
    echo true
    cpus 8
    tag 'Fastqc'
    executor 'slurm'
    publishDir "$params.outdir" , mode: 'copy',
        saveAs: {filename ->
                 if (filename.indexOf("zip") > 0)     "fastqc/zips/$filename"
            else if (filename.indexOf("html") > 0)    "fastqc/${sampleId}_${filename}"
            else if (filename.indexOf("txt") > 0)     "fastqc_stats/$filename"
            else null            
        }

    input:
    tuple val(sampleId), file(read1), file(read2)

    output:
    file "*.{zip,html}"

    script:
    """
    fastqc $read1 
    fastqc $read2 
    """
}

/*
 * Step 2. Trimming
 */

process trimming {
    tag "Trim Galore"
    cpus 16
    executor 'slurm'
    echo true
    memory '10GB'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
    	   if (filename.indexOf("_trimmed_fastqc.html") > 0) "postTrimQC/$filename"
      else if (filename.indexOf("_trimmed_fastqc.zip") > 0) "postTrimQC/zip/$filename"
      else if (filename.indexOf(".txt") > 0) "trimming/logs/$filename"
      else if (filename.indexOf("_trimmed.fq.gz")) "trimming/trimmed_fastq/$filename"
      else null
	}
    
    input:
    tuple val(sampleId), file(read1), file(read2)

    output:
    tuple val(sampleId), path('*.fq.gz'), emit: samples_trimmed
    file '*_fastqc.{zip,html}'
    file '*.txt'
    
    script:
    """
    ln -s $read1 ${sampleId}_1.fastq.gz
    ln -s $read2 ${sampleId}_2.fastq.gz
    trim_galore --quality ${params.quality} --length ${params.length} --gzip --fastqc --paired ${sampleId}_1.fastq.gz ${sampleId}_2.fastq.gz
    """
}

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
    path index
    tuple val(sampleId), path(read1), path(read2)
    
    output:
    tuple val(sampleId), file('mapped/*.bam')  
    
    script:
    """
    STAR --runMode alignReads \
	--genomeDir ${index} \
	--outSAMtype BAM SortedByCoordinate \
	--readFilesIn $read1 $read2 \
	--runThreadN 16 \
	--outFileNamePrefix mapped/${sampleId}_ \
	--outFilterMultimapNmax 1 \
	--twopassMode Basic \
        --readFilesCommand zcat 
    """
}

index_ch.view()

workflow {
    fastqc(samples_ch)
    trimming(samples_ch)
    alignment(index_ch.collect(), trimming.out.samples_trimmed)
}
