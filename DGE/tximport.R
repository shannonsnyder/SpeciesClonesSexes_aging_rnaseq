# Load libraries
library(DESeq2)
library(tidyverse)
library(RColorBrewer)
library(pheatmap)
library(DEGreport)
library(tximport)
library(tximportData)
library(ggplot2)
library(ggrepel)

dir="/home/ssnyder3/nereus/aging_rnaseq/kallisto/kallisto_aligned/magna_aligned"

#CSV to specify sample names (ie epa-14-12a...)
samplesheet <- read.csv("/home/ssnyder3/nereus/aging_rnaseq/DGE/magna_samplesheet.csv",header=TRUE,stringsAsFactors=F)


## List all directories containing data - input for tximport
samples <- list.files(path = "/home/ssnyder3/nereus/aging_rnaseq/kallisto/kallisto_aligned/magna_aligned", full.names = T)
files <- file.path(samples, "abundance.tsv")

#specify sample names using Sample column in samplesheet
names(files) <- samplesheet$Sample

# Download from EMSEMBL biomart: NEEDS TO BE FORMATTED "transcript ID, geneID"
tx2gene <- read_csv("magna_martexport.csv")

# utilize tximport function to call abundances and correlate with genes
txi.kallisto.tsv <- tximport(files, type = "kallisto", tx2gene = tx2gene, ignoreAfterBar = TRUE)
head(txi.kallisto.tsv$counts)

# write output to tsv
write.table(txi.kallisto.tsv, file="magna_genematrix.tsv", quote=FALSE, sep='\t', col.names = NA)






#magna = magna %>% mutate(Age = as.factor(Age))
#dds <- DESeqDataSetFromTximport(txi.kallisto.tsv, magna, ~Day)

# GRAVEYARD #
#txi.kallisto.tsv <- as.data.frame(txi.kallisto.tsv$counts)
#write_csv(txi.kallisto.tsv, file = "magna_genematrix.tsv", col_names = TRUE)
#files <- file.path(dir, "kallisto", magna$Sample, "abundance.tsv")
#names(files) <- paste0("sample", 1:9)
#txi.kallisto.tsv <- as.data.frame(txi.kallisto.tsv)
#write_csv(txi.kallisto.tsv, file = "magna_genematrix.tsv")
#txi.kallisto.tsv <- tximport(files, type = "kallisto", tx2gene = tx2gene, ignoreAfterBar = TRUE)
#names(txi.kallisto)
#files <- paste("kallisto_aligned". list.files(path = "kallisto_aligned",pattern = "abundance.tsv", recursive = TRUE),sep = "/")
#txi.kallisto.tsv <- tximport(files, type = "kallisto", tx2gene = tx2gene, ignoreAfterBar = TRUE)