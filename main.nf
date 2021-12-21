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

//include section for modules
include { s_fastqc } from './modules/single_end/s_fastqc'
include { s_trimming } from './modules/single_end/s_trimming'
include { p_fastqc } from './modules/paired_end/p_fastqc'
include { p_trimming } from './modules/paired_end/p_trimming'
include { alignment } from './modules/alignment'
include { samtools } from './modules/samtools'
include { countTable } from './modules/countTable'
include { multiqc } from './modules/multiqc'
include { foo } from './modules/foo'

//include section for workflows
include { single_end } from './workflow/single_end'
include { paired_end } from './workflow/paired_end'

//channel
reads = Channel.from( params.reads )

//workflow
workflow {
 if (params.single_end) {
   single_end(reads)
   foo(single_end.bam.out)
  } else {
   paired_end(reads)
   foo(paired_end.out.bam)
  }
}

workflow.onComplete {
        log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $params.outdir/multiqc_report.html\n" : "Oops .. something went wrong" )
}
