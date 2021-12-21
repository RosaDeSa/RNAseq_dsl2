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
include { s_fastqc } from './modules/single_end/s_fastqc.nf'
include { s_trimming } from './modules/single_end/s_trimming.nf'
include { p_fastqc } from './modules/paired_end/p_fastqc.nf'
include { p_trimming } from './modules/paired_end/p_trimming.nf'
include { alignment } from './modules/alignment.nf'
include { samtools } from './modules/samtools.nf'
include { countTable } from './modules/countTable.nf'
include { multiqc } from './modules/multiqc.nf'
include { foo } from './modules/foo.nf'

//channel
reads = Channel.from( params.reads )

//workflow
workflow single_end {
   take:
    reads
   
   emit:
    alignment.out
   
   main:
    s_fastqc(reads)
    s_trimming(reads)
    alignment(s_trimming.out.samples_trimmed)
    }
           
workflow paired_end {
   take:
    reads
   
   emit:
    alignment.out
   
   main:
    p_fastqc(reads)
    p_trimming(reads)
    alignment(p_trimming.out.samples_trimmed)
   }

workflow {
 if (params.single_end) {
  single_end()
  } else {
   paired_end()
  }
 foo(alignment.out[0])
}

workflow.onComplete {
        log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $params.outdir/multiqc_report.html\n" : "Oops .. something went wrong" )
}
