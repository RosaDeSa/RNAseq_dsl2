/*
 * Step 2. Trimming
 */

process umi_p_trimming {
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
    tuple val(sample_id), file(processed), path(reads)
    
    output:
    tuple val(sample_id), path('*.fq.gz'), emit: samples_trimmed
    file '*_fastqc.{zip,html}'
    file '*.txt'
    
    script:
    """
    ln -s ${processed} ${sample_id}_1.fastq.gz
    ln -s ${reads[1]} ${sample_id}_2.fastq.gz
    trim_galore --quality ${params.quality} --length ${params.length} --gzip --fastqc --paired ${sample_id}_1.fastq.gz ${sample_id}_2.fastq.gz
    """
}
