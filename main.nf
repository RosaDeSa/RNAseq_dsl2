#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// 1.1 input file from cli
params.sampleId = ""

// 1.2 input file from config file
Channel
    .fromPath( params.sampleId )
    .splitCsv(header:true, sep: ",")
    .map{ row-> tuple(row.sampleId, file(row.read1, checkIfExists: true), file(row.read2, checkIfExists: true)) }
    .set { samples_ch }

Channel
    .fromPath( params.gtf )
    .ifEmpty { error "Cannot find any annotation matching: ${params.gtf}" }
    .set { annot_ch }

 Channel
    .fromPath( params.genome )
    .ifEmpty { error "Cannot find any annotation matching: ${params.genome}" }
    .set { genome_ch }

Channel
    .fromPath( params.index )
    .ifEmpty { error "Cannot find any annotation matching: ${params.index}" }
    .set { index_ch }

// 2 load script from modules
include { fastqc } from './modules/fastqc'
include { trimming } from './modules/trimming'
include { alignment } from './modules/alignment'
include { samtools } from './modules/samtools'
include { countTable } from './modules/countTable'
include { multiqc } from './modules/multiqc'

// workflow
workflow {
    fastqc(samples_ch)
    trimming(samples_ch)
    alignment(trimming.out.samples_trimmed)
    samtools(alignment.out[0])
    countTable(alignment.out[0])
    multiqc(fastqc.out.collect(),
    	trimming.out[1].collect(),
	    trimming.out[2].collect(),
	    alignment.out[1].collect(),
	    countTable.out[1].collect())
}
