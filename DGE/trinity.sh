#!/bin/sh

# create a gene expression matrix from kallisto output files.

perl /home/ssnyder3/nereus/aging_rnaseq/sleuth/trinityrnaseq/util/abundance_estimates_to_matrix.pl \
--est_method kallisto \
    --gene_trans_map none \
    --out_prefix pulicaria_output \
    --name_sample_by_basedir \
    /home/ssnyder3/nereus/aging_rnaseq/kallisto/kallisto_out/pulicaria_aligned/*_trimmed/abundance.tsv \
