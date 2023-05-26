#This script is adapted from virginia by Li Lei
#2021-09-08

#Run locally or on cori w conda env /global/projectb/sandbox/plant/hybridum/software/grrr
library(GenomicRanges)
options(scipen=999) #to prevent scientific notation


get_chrom_df <- function(myrow){
  starts <- seq(1,chrdat[myrow,2],by=windowSize)
  ends <- append(sapply(starts, function(x) x-1)[-1], chrdat[myrow,2])
  chromdf <- data.frame(rep(chrdat[myrow,1], times=length(starts)), starts, ends)
  return(chromdf)
}



############# EDIT HERE ################
args = commandArgs(trailingOnly=TRUE)
windowSize <- as.numeric(args[4])
chromsizesfile <- args[3]
fragfile <- args[2]
genome <- args[1]

#setwd('/home/virginia/Documents/school/vogelLab/notebook/2021')
#genome <- 'ABR113'
#chromsizesfile <- paste0(genome, '.chrom.sizes')
#fragfile <- paste0('allfragments.classified_', genome)
#windowSize <- 200000
########################################

chrdat <- read.csv(chromsizesfile, sep='\t', header=FALSE, stringsAsFactors = FALSE)
frags <- read.csv(fragfile, header=TRUE, sep='\t', stringsAsFactors = FALSE)

#A GRanges object of the whole genome divided into <windowSize>-sized bins
bindf <- do.call("rbind", lapply(seq(nrow(chrdat)), function(x) get_chrom_df(x)))
binGR <- GRanges(
  seqnames = bindf[,1],
  ranges = IRanges(bindf[,2], bindf[,3]),
)

fragGR <- GRanges(
  seqnames=frags$chrom, 
  ranges=IRanges(start=frags$frag_start, end=frags$frag_end),
  strand=frags$strand)


m <- mergeByOverlaps(fragGR, binGR)
temp <- m[,2]
temp$TEspace <- width(m[,1])
q <- findOverlaps(binGR, temp, type='equal')
indices <- queryHits(q)
binGR$TEspace <- rep(0, times=length(binGR))
#takes about a minute
j <- sapply(unique(queryHits(q)), function(i) binGR[i]$TEspace <<- sum(temp[queryHits(q)==i]$TEspace))
final <- data.frame(Chr=seqnames(binGR), Start=start(binGR), End=end(binGR), TEDensity=round(binGR$TEspace/width(binGR), 3))

write.table(final, file=sprintf("TEdensity.%s.%dkb.tsv", genome, windowSize/1000), row.names = FALSE, col.names=FALSE, quote=FALSE, sep="\t")
write.table(final, file=sprintf("TEdensity.%s.%dkb.csv", genome, windowSize/1000), row.names = FALSE, col.names=TRUE, quote=FALSE, sep=",")















