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
include { alignment;
          samtools;
          countTable;
          multiqc } from './modules'

include { s_fastqc;
          s_trimming } from './modules/single_end'

include { p_fastqc;
          p_trimming } from './modules/paired_end'
          

//channel
reads = Channel.from( params.reads )

//workflow
workflow single_end {
    s_fastqc(reads)
    s_trimming(reads)
    alignment(trimming.out.samples_trimmed)
    samtools(alignment.out[0])
    countTable(alignment.out[0])
    multiqc(fastqc.out,
            trimming.out[1],
            trimming.out[2],
            alignment.out[1],
            countTable.out[1]
           )
    }
           
workflow paired_end {
    p_fastqc(reads)
    p_trimming(reads)
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

workflow {
 if (params.single_end) {
  single_end()
  } else {
   paired_end()
  }
}

workflow.onComplete {
        log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $params.outdir/multiqc_report.html\n" : "Oops .. something went wrong" )
}
