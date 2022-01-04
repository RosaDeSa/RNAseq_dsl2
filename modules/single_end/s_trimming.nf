/*
 * Step 2. Trimming
 */

process s_trimming {
    tag 'Trim Galore'
    label 'trimming'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
           if (filename.indexOf(".html") > 0) "postTrimQC/$filename"
      else if (filename.indexOf(".zip") > 0) "postTrimQC/zip/$filename"
      else if (filename.indexOf(".txt") > 0) "trimming/logs/$filename"
      else if (filename.indexOf(".fq.gz")) "trimming/trimmed_fastq/$filename"
      else null
        }
    
    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path('*.fq.gz'), emit: samples_trimmed
    file '*_fastqc.{zip,html}'
    file '*.txt'
    
    script:
    """
    ln -s ${reads[0]} ${sample_id}.fastq.gz
    trim_galore --quality ${params.quality} --length ${params.length} --gzip --fastqc ${sample_id}.fastq.gz
    """
}
