#!/bin/bash
#SBATCH --account=nereus   ### change this to your actual account for charging
#SBATCH --partition=compute     ### queue to submit to
#SBATCH --job-name=fastqc    ### job name
#SBATCH --time=08:00:00                ### wall-clock time limit, in minutes
#SBATCH --nodes=1               ### number of nodes to use
#SBATCH --ntasks-per-node=1     ### number of tasks to launch per node
#SBATCH --cpus-per-task=8       ### number of cores for each task

# load modules
module load fastqc/0.11.5

# make output dir
OUTPUT_DIR=fastqc_out
mkdir -p $OUTPUT_DIR

# run fastqc
/usr/bin/time -v fastqc *.fastq -o $OUTPUT_DIR
