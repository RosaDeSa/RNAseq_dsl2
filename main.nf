#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// parmas path
params.pattern = ""
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
 genome       : ${params.genome}
 gtf          : ${params.gtf}
 """

//include section for workflows
include { single_end } from 'workflow/single_end.nf'
include { paired_end } from 'workflow/paired_end.nf'
include { umi_single_end } from 'workflow/umi_single_end.nf'
include { umi_paired_end } from 'workflow/umi_paired_end.nf'

//channel
reads = Channel.from( params.reads )

//workflow
workflow {
 if (params.single_end && !params.umi) 
  single_end(reads)
 else if (params.single_end && params.umi)
  umi_single_end(reads)
 else if (!params.single_end && !params.umi)
  paired_end(reads)
 else
  umi_paired_end(reads)
}

workflow.onComplete { 
        log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $params.outdir/multiqc_report.html\n" : "Oops .. something went wrong" )
}
