/*
 * Step 0. Build the genome index
 */

process buildIndex {
    echo true
    tag "Generate Index"
    cpus 8
    executor 'slurm'
    publishDir "$params.outdir", mode: 'copy'

    input:
    file(genome)
    file(annot)
    
    output:
    path 'index' in index_ch
    
    script:
    """
    STAR --runMode genomeGenerate \
      --genomeDir index \
      --genomeFastaFiles ${genome} \
      --sjdbGTFfile ${annot} \
      --sjdbOverhang 99 \
      --runThreadN 8
    """
}
