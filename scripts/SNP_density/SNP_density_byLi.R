options(scipen=999)
num_targets <- function(chr_len, win_size, targets) {
  #   Get the break points of the windows
  win_points <- seq(0, chr_len, by=win_size)
  #   If the window size divides evenly into the chromosome length, we are
  #   fine. Otherwise, put the length on as the final endpoint.
  if(chr_len %% win_size != 0) {
    win_points <- c(win_points, chr_len)
  }
  #   Then, count how many exome capture targets are in each window
  num_in_win <- sapply(
    2:length(win_points),
    function(x) {
      in_win <- (targets$V2 >= win_points[x-1]) & (targets$V3 <= win_points[x])
      return(sum(in_win))
    }
  )
  return(num_in_win)
}


#   Function to transform a vector of numbers into a list of intervals
make_intervals <- function(endpoints) {
  starts <- endpoints[1:length(endpoints)-1]
  ends <- endpoints[2:length(endpoints)]
  return(data.frame(Start=starts, End=ends))
}


#main <- function() {
  #   Take command line arguments
  #   Stores arguments into a vector
  #args <- commandArgs(trailingOnly = TRUE)
  #bedfile <- args[1] # 1) SNPs or deletions bed file
  #chrome <- args[2] # 2) chromosome size file of Bd21-3
  #win_size <- args[3] # window size
  #outPrefix <- args [4] #outfile prefix (do not include file extension)
  #outDir <- args[5] # 4) where do our output files go?
  
bedfile <- "/global/cfs/cdirs/plantbox/llei/bscratch/llei2019/Bd21_3_mutant/circos/SNP_density/reorder_SNPs_EMS_no_scaffold.bed"
#bedfile <- "/global/cfs/cdirs/plantbox/llei/bscratch/llei2019/Bd21_3_mutant/circos/SNP_density/reorder_SNPs_NaN_no_scaffold.bed"
#bedfile <- "/global/cfs/cdirs/plantbox/llei/bscratch/llei2019/Bd21_3_mutant/circos/SNP_density/reorder_SNPs_FN.bed"

chrome <- "/global/cfs/cdirs/plantbox/llei/bscratch/llei2019/Bd21_3_mutant/circos/SNP_density/Chromosome_size.txt"
win_size <- 500000
#outPrefix <- "FN_SNPs"
#outPrefix <- "NaN_SNPs"
outPrefix <- "EMS_SNPs"
outDir <- "/global/cfs/cdirs/plantbox/llei/bscratch/llei2019/Bd21_3_mutant/circos/SNP_density/"

  capture <- read.table(bedfile, header=F)
  chr_sizes <- read.table(chrome, header=T)
  head(chr_sizes)
  head(capture)
  #   Get the chromosome names
  chromosomes <- as.character(unique(capture$V1))
  #chr_len <- as.integer(chr_sizes[chr_sizes$Chromosome == x, "Length"])
  #chr_targets <- capture[(capture$V1 == x),]
  #   Get the number of targets in each window on each chromosome
  target_num <- sapply(
    chromosomes,
    function(x) {
      chr_len <- as.integer(chr_sizes[chr_sizes$Chromosome == x, "Length"])
      chr_targets <- capture[(capture$V1 == x),]
      return(num_targets(chr_len, win_size, chr_targets))
    }
  )
  
  chr_windows <- sapply(
    chromosomes,
    function(c) {
      len <- as.integer(chr_sizes[chr_sizes$Chromosome == c, "Length"])
      win_points <- seq(0, len, by=win_size)
      if(len %% win_size != 0) {
        win_points <- c(win_points, len)
      }
      wins <- make_intervals(win_points)
      return(wins)
    })
  
  num_target_df <- data.frame(
    Chromosome=c(
      rep("Bd1", length(chr_windows["Start", "Bd1"][[1]])),
      rep("Bd2", length(chr_windows["Start", "Bd2"][[1]])),
      rep("Bd3", length(chr_windows["Start", "Bd3"][[1]])),
      rep("Bd4", length(chr_windows["Start", "Bd4"][[1]])),
      rep("Bd5", length(chr_windows["Start", "Bd5"][[1]]))
    ),
    Start=as.vector(unlist(chr_windows["Start",])),
    End=as.vector(unlist(chr_windows["End", ])),
    VarDen=as.vector(unlist(target_num))/as.numeric(win_size)
  )
  
  #head(num_target_df)
  #setwd(outDir)
  write.table(
    num_target_df,
    file=paste0(outDir,"SNPdensity.",outPrefix,".",as.numeric(win_size)/1000,"kb.tsv"),
    sep="\t",
    quote=F,
    row.names=F)
  
  write.table(
    num_target_df,
    file=paste0(outDir,"SNPdensity.",outPrefix,".",as.numeric(win_size)/1000,"kb.csv"),
    sep=",",
    quote=F,
    row.names=F)
#}
  




#main()

