/*
 * Step 1. Create fastqc for reads
 */

process fastqc {
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
    ln -s ${reads[0]} ${sample_id}.fastq.gz
    fastqc ${sample_id}.fastq.gz
    """
}
