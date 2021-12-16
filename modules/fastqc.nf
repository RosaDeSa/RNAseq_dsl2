/*
 * Step 1. Create fastqc for reads
 */

process fastqc {
    echo true
    cpus 2
    tag 'Fastqc'
    executor 'slurm'
    publishDir "$params.outdir" , mode: 'copy',
        saveAs: {filename ->
                 if (filename.indexOf("zip") > 0)     "fastqc/zips/$filename"
            else if (filename.indexOf("html") > 0)    "fastqc/${filename}"
            else if (filename.indexOf("txt") > 0)     "fastqc_stats/$filename"
            else null            
        }

    input:
    tuple val(sampleId), file(read1), file(read2)

    output:
    file "*.{zip,html}"

    script:
    """
    ln -s $read1 ${sampleId}_1.fastq.gz
    ln -s $read2 ${sampleId}_2.fastq.gz
    fastqc ${sampleId}_1.fastq.gz
    fastqc ${sampleId}_2.fastq.gz
    """
}