# Human analysis

## Intro
This is a simple nextflow pipeline written with DSL 2.0 to show ho to run a rnaseq on slurm with a shared pipeline by github.

## What to do
If you want to replicate this analysis on your pc, you can use directly the nextflow pipeline putting it in the run command of nextflow. You have only to download che human.yml that is the configuration file for the conda envirnoment (the tool used to install different applications for the analysis). Next you have to setting up a yml file as input for the nextflow pipeline, as the reads.yml pushed on this repository.

Here is an example:

```bash
file:
 /home/tigem/g.martone/human_dsl2/reads.yml

reads:
- - day_10
  - ['/home/tigem/g.martone/human_dsl2/data/SRR1633256_1.fastq.gz', '/home/tigem/g.martone/human_dsl2/data/SRR1633256_2.fastq.gz' ]
- - day_14
  - ['/home/tigem/g.martone/human_dsl2/data/SRR1633267_1.fastq.gz', '/home/tigem/g.martone/human_dsl2/data/SRR1633267_2.fastq.gz' ]

outdir:
 /home/tigem/g.martone/human_dsl2/results
 
#index, gtf and genome paths are stored in nextflow config file

single_end:
 false

umi:
 true
```

### Tips

When you have to create the params file, you can use absolute path (as i did) or specify only folder, starting from the point that when you will use the params file input, it starts in the working directory. So you can manage data and path as in a relative mode. Remember to use absolute path if you have to set file that are in other directory, different from working directory.

## How use this repository

Last step is to configure the config file with your data, as your token for nextflow tower or other inputs.
- If you have forked the repository, you can managed the forked one as your repository and make changes in it.
- If you have not forked the repository, you have to download the config file on your local machine, make changes in it and specify it as input for nextflow pipeline.

## Input in terminal
To run this pipeline on my machine, i used this command line

```bash
nextflow run DevPeppe/human_dsl2 \
		 -r main \
		 -params-file reads.yml
```

Have fun :)
