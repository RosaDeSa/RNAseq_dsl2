/*
 * Step 1. Create fastqc for reads
 */

process p_fastqc {
    tag 'Fastqc'
    publishDir "$params.outdir" , mode: 'copy',
        saveAs: {filename ->
                 if (filename.indexOf("zip") > 0)     "fastqc/zips/$filename"
            else if (filename.indexOf("html") > 0)    "fastqc/${filename}"
            else if (filename.indexOf("txt") > 0)     "fastqc_stats/$filename"
            else null            
        }

    input:
    tuple val(sample_id), path(reads)

    output:
    file  "*.{zip,html}"

    script:
    """
    ln -s ${reads[0]} ${sample_id}_1.fastq.gz
    ln -s ${reads[1]} ${sample_id}_2.fastq.gz
    fastqc ${sample_id}_1.fastq.gz
    fastqc ${sample_id}_2.fastq.gz
    """
}
