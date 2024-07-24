#!/bin/bash 
#SBATCH -A nereus                ### Account
#SBATCH --partition=compute         ### Partition
#SBATCH --job-name=trimmomatic_pulex         ### Job Name
#SBATCH --time=0-24:00:00        ### WallTime
#SBATCH --nodes=1              ### Number of Nodes
#SBATCH --ntasks=1             ### Number of tasks per array job
##SBATCH --output=hostname.out   ### file in which to store job stdout
##SBATCH --error=hostname.err    ### file in which to store job stderr
##SBATCH --array=0-3           ### Array index

#SBATCH --mail-type=END              ### Mail events (NONE, BEGIN, END, FA$
#SBATCH --mail-user=ssnyder3@uoregon.edu  ### Where to send mail
#SBATCH --cpus-per-task=8            ### Number of CPU cores per task
#SBATCH --requeue


##        DESCRIPTION      ##
# Trimmomatic trims Illumina adapters and can remove low quality bases or reads 


##     TO USE    ##
# Update paths and specify trimming parameters
#

# Load Modules (if using Talapas)
module load racs-eb/1
module load Trimmomatic/0.36-Java-1.8.0_162

# Path to Trimmomatic jar file
TRIMMOMATIC_JAR="/gpfs/projects/nereus/ssnyder3/aging_rnaseq/trimmomatic/Trimmomatic/dist/jar/trimmomatic-0.40-rc1.jar"

# Path to adapter file (usually Trimmomatic's provided adapter file)
ADAPTERS="/home/ssnyder3/nereus/aging_rnaseq/trimmomatic/Trimmomatic/adapters/TruSeq3-PE-2.fa"

# Directory containing fastq files
INPUT_DIR="/home/ssnyder3/nereus/aging_rnaseq/all_raw_fastqs/pulex_fastqs"

# Output directory
OUTPUT_DIR="/home/ssnyder3/nereus/aging_rnaseq/trimmomatic/trimmomatic_out_final2"
mkdir -p $OUTPUT_DIR

# Set trimming parameters                                                                          
TRIM_PARAMS="ILLUMINACLIP:${ADAPTERS}:2:30:10 SLIDINGWINDOW:5:20"
#Illumina clip allows 2 mismatches, clipped if a score of 30 is reached (about 50 bases); 10 for SE data
#Sliding window parameter moves over a window of 5 bases and clips bases with quality scores lower than 20
# Create output directory if it doesn't exist


# Loop over each sample base name
for file in ${INPUT_DIR}/*R1_001.fastq.gz
do
  # Extract the base name (e.g., sample1 from sample1_R1_001.fastq.gz)
  base=$(basename $file _R1_001.fastq.gz)
  echo "Processing $base"
  
  java -jar $TRIMMOMATIC_JAR PE -threads 8 -trimlog ${base}.trimlog \
  -basein ${INPUT_DIR}/${base}_R1_001.fastq.gz \
  -baseout ${OUTPUT_DIR}/${base}_trimmed.fastq \
  $TRIM_PARAMS 

done

#PE : paired-end mode
# -basein : path to reads with file name of the first file, trimmomatic will find the other automatically
# -baseout : path to and file name of the trimmed reads (output)
# results: 4 files, 2 with paired reads (with 'P' char in their names)
# and 2 with unpaired reads ('U' chr in the names of the files)
