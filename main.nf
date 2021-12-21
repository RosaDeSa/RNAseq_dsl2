#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// parmas path
params.reads = ""
params.index = ""
params.outdir = ""
params.multiqc = ""
params.file = ""
params.gtf = ""
params.genome = ""

//log info
log.info """\
 R N A S E Q - N F   P I P E L I N E
 ===================================
 index        : ${params.index}
 file         : ${params.file}
 outdir       : ${params.outdir}
 """

//include section
include { fastqc } from './modules/fastqc'
include { trimming } from './modules/trimming'
include { alignment } from './modules/alignment'
include { samtools } from './modules/samtools'
include { countTable } from './modules/countTable'
include { multiqc } from './modules/multiqc'

//channel
reads = Channel.from( params.reads )

//workflow
workflow {
    fastqc(reads)
    trimming(reads)
    alignment(trimming.out.samples_trimmed)
    samtools(alignment.out[0])
    countTable(alignment.out[0])
    multiqc(fastqc.out.collect(),
            trimming.out[1].collect(),
            trimming.out[2].collect(),
            alignment.out[1].collect(),
            countTable.out[1].collect()
           )
}

workflow.onComplete {
        log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $params.outdir/multiqc_report.html\n" : "Oops .. something went wrong" )
}
