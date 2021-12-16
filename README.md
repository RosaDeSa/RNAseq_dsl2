# Human analysis

## Intro
This is a simple nextflow pipeline written with dsl 2.0 to show ho to run a rnaseq on slurm with a shared pipeline by github.

## What to do
If you want to reproduce this pipeline on your machine, you have to download the yml file that can be use to create the conda environment used for this analysis. You have to download also the csv file that it is used as input for the netxflow.

Last step is to configure the config file with your data, as your token for nextflow tower or other inputs.
- If you have forked the repository, you can managed the forked one as your repository and make changes in it.
- If you have not forked the repository, you have to download the config file on your local machine, make changes in it and specify it as input for nextflow pipeline.

## Input in terminal
To run this pipeline on my machine, i used this command line

```bash
nextflow run DevPeppe/human_dsl2 \
		 -r multiqc \
		 --sampleId human_d.csv \
		 --outdir /home/tigem/g.martone/human/results \
		 -resume
```

Have fun :)
