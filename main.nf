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
    tuple val(sampleId), file('*.fq.gz'), emit: samples_trimmed
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
    tuple val(sampleId), file(reads)
    
    output:
    tuple val(sampleId), file('mapped/*.bam')  
    
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

/*
 * Step 4. Index the BAM file
 */

process samtools {
    echo true
    cpus 16
    executor 'slurm'
    memory '35GB'
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

/*
 * Step 5. Generate count table
 */
 
process countTable {
    tag "Generate count table"
    cpus 8
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

/*
 * Step 6. Multiqc
 */

process multiqc {
    tag "Generate MultiQC"
    cpus 8
    executor 'slurm'
    publishDir "${params.outdir}/multiqc", mode: 'copy'
	
    input:
    file "*.{zip,html}"
    file '*_fastqc.{zip,html}'
    file '*.txt'
    path '*.{flagstat,idxstats,stats}'
    path '*.summary'
    
    
    output:
    file("multiqc_posttrim_report.html")
    file("multiqc_posttrim_report_data")
    
    script:
    """
    multiqc . -n multiqc_posttrim_report.html
    """
}

workflow {
    fastqc(samples_ch)
    trimming(samples_ch)
    // trimming.out.samples_trimmed.view()
    alignment(trimming.out.samples_trimmed)
    samtools(alignment.out)
    countTable(alignment.out)
    // multiqc(fastqc.out.fastqc_for_mqc, trimming.out.post_trimqc_reports, trimming.out.post_trimqc_results, samtools.out.stats_for_mqc, countTable.out.count_for_mqc)
    multiqc(fastqc.out, trimming.out[1,2], samtools.out[1], countTable.out[1])
}
