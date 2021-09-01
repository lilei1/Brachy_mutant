#by Li Lei 20210827 in El Cerrito and adapted from Tom Kono, https://github.com/MorrellLAB/Deleterious_GP/blob/master/Analysis_Scripts/Data_Handling/Capture_Targets_Per_Mb.R
#   Calculate the number of exons per Mb in the pseudomolecule
#   assembly. Calculates in non-overlapping windows. Counts partial overlaps of
#   capture targets with the window as a full target (may double-count a few).

#   Define a function to return the number of overlapping intervals, given an
#   interval size.
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

setwd("/Users/LiLei/Projects/Brachy_mutant/filtered_calls/combined/Natural_lines/")
capture <- read.table("BdistachyonBd21_3_460_v1.1.gene_exons_primary.bed", header=F)
chr_sizes <- read.table("Chrom_Lengths.txt", header=T)
chromosomes <- as.character(unique(capture$V1))
#as.integer(chr_sizes[chr_sizes$Chromosome == "Bd1", "Length"])
#capture[capture$V1 == "Bd1",]
#   Get the number of targets in each window on each chromosome
target_num <- sapply(
  chromosomes,
  function(x) {
    chr_len <- as.integer(chr_sizes[chr_sizes$Chromosome == x, "Length"])
    chr_targets <- capture[capture$V1 == x,]
    return(num_targets(chr_len, 100000, chr_targets))
  }
)


chr_windows <- sapply(
  chromosomes,
  function(c) {
    len <- as.integer(chr_sizes[chr_sizes$Chromosome == c, "Length"])
    win_points <- seq(0, len, by=100000)
    if(len %% 100000 != 0) {
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
    rep("Bd5", length(chr_windows["Start", "Bd5"][[1]])),
    rep("scaffold_21", length(chr_windows["Start", "scaffold_21"][[1]])),
    rep("scaffold_28", length(chr_windows["Start", "scaffold_28"][[1]])),
    rep("scaffold_33", length(chr_windows["Start", "scaffold_33"][[1]]))
  ),
  Start=as.vector(unlist(chr_windows["Start",])),
  End=as.vector(unlist(chr_windows["End", ])),
  NExCap=as.vector(unlist(target_num))
)


write.table(
  num_target_df,
  file="Exome_nb_per_Mb.txt",
  sep="\t",
  quote=F,
  row.names=F)
