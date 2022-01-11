# Human analysis

## Intro
This is a simple nextflow pipeline written with DSL 2.0 to show ho to run a rnaseq on slurm with a shared pipeline by github.

## What to do
If you want to replicate this analysis on your pc, you can use directly the nextflow pipeline putting it in the run command of nextflow. You have only to download che human.yml that is the configuration file for the conda envirnoment (the tool used to install different applications for the analysis). This file will be used by nextflow to build up a temporary conda environment via instructions written in nextflow config file.

Next step is to write a yml regards to files that you want to analyze.

Here is an example (reads.yml):

```bash
#with file you can highlight the path for yml file
file:
 /absolute/path/to/reads.yml

#with reads you can specify the params reads for nextflow
#you can add more reads following the pattern
reads:
- - name_of_read
  - ['/absolute/path/to/read_one', '/absolute/path/to/read_two' ]

#here you can specify the folder in with will be stored the output
outdir:
 /asbolute/path/to/results
 
#index, gtf and genome paths are stored in nextflow config file

#here you have to specify if the analysis is single or paired end (single_end = true or false)
single_end:
 false

#and here if there are umi or not (umi = true or false)
umi:
 true
#if you need ad analysis with removing umi, you need to specify also the pattern for them. 
#If not, you can also delete belowe command
pattern:
 NNNNNNNNNNNN

#the configuration file for STAR parameters
starconf:
 /home/tigem/g.martone/projects/human_single_end/star_settings.conf
```

---

## Tips & Tricks

When you have to create the params file, you can use absolute path or specify only folder, starting from the point that when you will use the params file input, it starts in the working directory. So you can manage data and path as in a relative mode. Remember to use absolute path if you have to set file that are in other directory, different from working directory.

Remember that there is a hierarchy when you want to specify some parameters:
- command line
- params file
- main.nf
- nextflow.config

So, if you wanto to run the same pipeline, without modify the yml file for nextflow, you can add parameters in command line.

---

## Setting parameters

Here you can find all parameteres that we have setted in nextflow config file or in the specific module. Remember the hierarchy of the input parameters and add only which you want to modify from default value in the yml file o in command line.

### Trim Galore parameters
- e = '0.1'
- quality = '20'
- length = '39'

### STAR aligner
STAR has a separeted file in wich you can specify each parameters for the alignment. In the module aligment.nf are expressed some parameters because they are these one are strictly connected with nextflow, they are part of the workflow and must are not be touched. So, for star you have to create a file like __star_settings.conf__ (loaded on this repository) in wich you can specify all parameters for the specific function of STAR. Next, you can set the path of this file in the yml file of nextflow and it will be loaded as well as other files.

An example of parameters used are:
```bash
runMode alignReads
outSAMtype BAM SortedByCoordinate
runThreadN 7 
outFilterMultimapNmax 1
twopassMode Basic
readFilesCommand zcat
```

---

## How use this repository

Last step is to configure the config file with your data, as your token for nextflow tower or other inputs.
- If you have forked the repository, you can managed the forked one as your repository and make changes in it.
- If you have not forked the repository, you have to download the config file on your local machine, make changes in it and specify it as input for nextflow pipeline.

### Input in terminal
To run this pipeline on my machine, i used this command line

```bash
nextflow run DevPeppe/RNAseq_dsl2 \
		 -r main \
		 -params-file reads.yml
```

Have fun :)
