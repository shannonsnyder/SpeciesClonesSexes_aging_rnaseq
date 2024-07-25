#!/bin/bash 
#SBATCH -A nereus                ### Account
#SBATCH --partition=compute_intel         ### Partition
#SBATCH --job-name=kallisto_pulex         ### Job Name
#SBATCH --time=24:00:00        ### WallTime
#SBATCH --nodes=1              ### Number of Nodes
#SBATCH --ntasks=1             ### Number of tasks per array job
##SBATCH --array=0-3           ### Array index
#SBATCH --constraint=intel

#SBATCH --mail-type=END              ### Mail events (NONE, BEGIN, END, FA$
#SBATCH --mail-user=ssnyder3@uoregon.edu  ### Where to send mail
#SBATCH --cpus-per-task=8            ### Number of CPU cores per task
#SBATCH --requeue


##        DESCRIPTION      ##
# mapping of reads to transcriptome

##     TO USE    ## 
# add path to raw (or trimmed) fastq files

# load modules 
module load racs-eb/1
module load kallisto/0.43.1-intel-2017b


# Set variables
#input fastq dir 
FASTQDIR=/home/ssnyder3/nereus/aging_rnaseq/trimmomatic/trimmed_fastqs/trimmed_pulex
OUTDIR=kallisto_out


genome_dir=/home/ssnyder3/nereus/aging_rnaseq/genomes/dpulex/ncbi_dataset/data/GCF_021134715.1
fasta_file=rna.fna
# D pulicaria: D.pulicaria_LARRY_HIC_final.codingseq.fasta
# D. magna: D.magna_NIES.masked.codingseq   # Path to the reference transcriptome in FASTA format
INDEX=${fasta_file}.idx


# Index the reference transcriptome if not already indexed
if [ ! -e "${fasta_file}.idx" ]; then
    echo "Indexing reference transcriptome..."
    /usr/bin/time -v kallisto index -i ${fasta_file}.idx ${genome_dir}/$fasta_file
else
    echo "Index file ${fasta_file}.idx already exists. Skipping indexing."
fi

echo "${genome_dir}/$INDEX"

# Create output directory if it doesn't exist
mkdir -p $OUTDIR

# Loop through each pair of FASTQ files
for R1 in "${FASTQDIR}"/*_1P.fastq; do
    # Get corresponding R2 file
    R2="${R1/_1P/_2P}"

 # Extract sample name from R1 file name                                                                                      
   sample=$(basename $R1 _1P.fastq)                                                                                             

    echo "Processing sample: $sample"                                                                                           

    # Run kallisto quant                                                                                                         
    /usr/bin/time -v kallisto quant -i ${fasta_file}.idx -o $OUTDIR/$sample --threads=8 --bootstrap-samples=100 --plaintext $R1 $R2
    echo "Finished processing sample: $sample"





    
    # Debugging output
#     echo "R1: $R1"
#     echo "R2: $R2"
    
#     # Check if R2 file exists
#     if [ -e "$R2" ]; then
#         echo "Found matching pair: $R1 and $R2"
#     else
#         echo "No matching pair for $R1"
#     fi
# done





# Pseudoalign each trimmed FASTQ file
#for fastq_file in $FASTQDIR/*.fastq; do
#    # Get the base name of the file
#    base_name=$(basename $fastq_file .fastq)
    
    # Run kallisto pseudoalignment
#    echo "Running kallisto pseudoalignment for $base_name..."
#    kallisto quant \
#        -i ${fasta_file}.idx \
#        -o $OUTDIR/${base_name}_output \
#        $fastq_file
#done

#echo "Pseudoalignment complete. Output files saved in $OUTDIR."

# Loop through each pair of FASTQ files
#for R1 in ${FASTQ_DIR}/*_1P.fastq; do
#    # Get corresponding R2 file
#    R2=${R1/_1P/_2P}
#    echo $R1
#    echo $R2

    # Extract sample name from R1 file name
#    sample=$(basename $R1 1P.fastq)

#    echo "Processing sample: $sample"

    # Run kallisto quant
    #kallisto quant \
    #    --index=$INDEX \
    #    --output-dir=$OUTDIR/$sample \
    #    --threads=4 \   # Adjust number of threads according to your system
    #    --bootstrap-samples=100 \  # Optional: number of bootstrap samples
    #    --plaintext \   # Output in plaintext format
    #    $R1 $R2

    #echo "Finished processing sample: $sample"
done

