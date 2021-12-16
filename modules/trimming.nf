/*
 * Step 2. Trimming
 */

process trimming {
    tag "Trim Galore"
    cpus 4
    executor 'slurm'
    echo true
    memory '10GB'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
    	   if (filename.indexOf(".html") > 0) "postTrimQC/$filename"
      else if (filename.indexOf(".zip") > 0) "postTrimQC/zip/$filename"
      else if (filename.indexOf(".txt") > 0) "trimming/logs/$filename"
      else if (filename.indexOf(".fq.gz")) "trimming/trimmed_fastq/$filename"
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