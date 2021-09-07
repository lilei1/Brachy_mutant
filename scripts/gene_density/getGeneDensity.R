# A script to calculate gene density for a given window size
# across each chromosome in ABR113.
# Chromosome sizes were obtained like so:
# bwa index ABR113.fa
# samtools faidx ABR113.fa
# cut -f1,2 ABR113.fa.fai > ABR113.chrom.sizes
#This will help us get a sense of the relative gene density of
#each chromosome, which in turn tells us a bit about where in 
#the nucleus we might expect to find that chromosome. 
#May also make a nice figure if we plot as a karyogram.

#Run with command line args: genome, gff, chrom sizes file, bin size (in that order) e.g.
# Rscript getGeneDensity.R Bd21 Bdistachyon_314_v3.1.gene_exons.gff3 Bd21.chrom.sizes 1000000

#Run locally or on cori w conda env /global/projectb/sandbox/plant/hybridum/software/grrr
suppressPackageStartupMessages({
library(GenomicRanges)
})
options(scipen=999) #to prevent scientific notation


get_chrom_df <- function(myrow){
  starts <- seq(1,chrdat[myrow,2],by=windowSize)
  ends <- append(sapply(starts, function(x) x-1)[-1], chrdat[myrow,2])
  chromdf <- data.frame(rep(chrdat[myrow,1], times=length(starts)), starts, ends)
  return(chromdf)
}

########################## 
args = commandArgs(trailingOnly=TRUE)
windowSize <- as.numeric(args[4])
chromsizesfile <- args[3]
gfffile <- args[2]
genome <- args[1]
#setwd('/home/virginia/Documents/school/vogelLab/scripts/densities')
#windowSize <- 250000
#chromsizesfile <- "ABR113.chrom.sizes"
#gfffile <- "Bhybridum_463_v1.1.gene_exons.gff3"
########################## 


chrdat <- read.csv(chromsizesfile, sep='\t', header=FALSE, stringsAsFactors = FALSE)
bindf <- do.call("rbind", lapply(seq(nrow(chrdat)), function(x) get_chrom_df(x)))
binGR <- GRanges(
  seqnames = bindf[,1],
  ranges = IRanges(bindf[,2], bindf[,3]),
)

gff <- read.table(file=gfffile, skip=3, header=FALSE, sep="\t", stringsAsFactors=FALSE)
gffDat <- GRanges(
  seqnames=gff[,1], 
  ranges=IRanges(start=gff[,4], end=gff[,5]),
  strand=rep('*', times=nrow(gff)), #gff[,7],
  feature=gff[,3])

genes <- subset(gffDat, feature=="gene")
collapsed_genes <- reduce(genes)

m <- mergeByOverlaps(collapsed_genes, binGR)
temp <- m[,2]
temp$genespace <- width(m[,1])


q <- findOverlaps(binGR, temp, type='equal')
indices <- queryHits(q)

binGR$genespace <- rep(0, times=length(binGR))
j <- sapply(unique(queryHits(q)), function(i) binGR[i]$genespace <<- sum(temp[queryHits(q)==i]$genespace))

final <- data.frame(Chr=seqnames(binGR), Start=start(binGR), End=end(binGR), GeneDensity=round(binGR$genespace/width(binGR), 3))

write.csv(final, file=sprintf("geneDensity.%s.%dkb.txt", genome, windowSize/1000), row.names = FALSE, quote=FALSE)
write.table(final, file=sprintf("geneDensity.%s.%dkb.tsv", genome, windowSize/1000), sep="\t", col.names=FALSE, row.names = FALSE, quote=FALSE)

