#   Make a fancy plot of dSNPs, recombination rate, exonsity, and dSNPs, and all mutations from the mutant projects

#by Li Lei 2021/08/31


library(ggplot2)

#   Read the exon capture density data,9k genptyping data, and exon-capture SNP data;

excap <- read.delim(file="/Users/LiLei/Projects/Brachy_mutant/filtered_calls/combined/Natural_lines/Exome_nb_per_Mb.txt",header = T, sep="\t")
head(excap)
tail(excap)

highSNP <- read.delim("/Users/LiLei/Projects/Brachy_mutant/filtered_calls/combined/sorted_uniq_high_impact_variants", header=T, sep="\t")
head(highSNP)

dSNP <- read.delim("/Users/LiLei/Projects/Brachy_mutant/filtered_calls/combined/sorted_uniq_dSNPs_variants", header=T, sep="\t")

nrow(dSNP)

allSNP <- read.delim(file="/Users/LiLei/Projects/Brachy_mutant/filtered_calls/combined/sorted_uniq_all_variants",header = T, sep="\t")
head(allSNP)
tail(allSNP)
str(allSNP)

allSNP_Bd1 <- allSNP[(allSNP$Chromosome == "Bd1"),]
tail(allSNP_Bd1)
rec_rate <- read.table("/Users/LiLei/Projects/Brachy_mutant/filtered_calls/combined/rec/9k_cM_100kb_Smoothed.txt", header=T)
head(rec_rate)

#   Drop the unmapped chromosome
#arraySNP <- arraySNP[arraySNP$Chromosome != "chrUn",]
#exonSNP <- exonSNP[exonSNP$Chromosome != "chrUn",]
#excap <- excap[excap$Chromosome != "chrUn",]
#rec_rate <- rec_rate[rec_rate$Chromosome != "chrUn",]

get_num_excap <- function(snp) {
  chrom <- as.character(snp["Chromosome"])
  pos <- as.numeric(snp["Position"])
  sel_row <- which((excap$Chromosome == chrom) & (pos > excap$Start) & (pos <= excap$End))
  n_excap <- excap[sel_row, "NExon"]
  if(length(n_excap) == 0) {
    return(NA)
  }
  return(n_excap)
}

#allSNP$Position <- as.numeric(allSNP$Position)

#sorted_allSNP <- allSNP[order(Position),]

get_recomb_rate <- function(snp) {
  chrom <- as.character(snp["Chromosome"])
  pos <- as.numeric(snp["Position"])
  sel_row <- which((rec_rate$Chromosome == chrom) & (pos > rec_rate$LeftBP) & (pos < rec_rate$RightBP))
  rrate <- rec_rate[sel_row, "Smoothed_cMMb"]
  #   Set recombination rates that are too high to NA. Same with those that
  #   do not match any given interval
  if(length(rrate) == 0) {
    return(NA)
  }
  if(is.na(rrate)) {
    return(NA)
  }
  if(rrate > 10) {
    return(NA)
  }
  return(rrate)
}


##Adjust a little! 

pdf(file="~/Projects/Brachy_mutant/filtered_calls/combined/Brachy_mutant/plot/rec_dSNP_genedensity.pdf", 10, 3)

ggplot(allSNP) +geom_vline(aes(xintercept=Position/100000),size=0.02, alpha=0.1, color="#a6cee3")+
  geom_line(aes(x=(Start+End)/200000, y=NExCap/10), data=excap,size=0.75, color="blue", alpha=0.7) +
  geom_line(aes(x=(LeftBP+RightBP)/200000, y=Smoothed_cMMb), data=rec_rate, color="#FFBF00", size=1, alpha=1) +
  geom_point(aes(x=Position/100000,y=24), data=highSNP, color="purple", shape=1,size=1, alpha=0.25) +
  geom_point(aes(x=Position/100000,y=18), data=dSNP, color="purple", shape=6,size=1, alpha=0.25)+
  facet_grid(Chromosome~.) +
  scale_y_continuous(limits=c(0, 24), breaks=seq(0, 20, by=5)) +
  scale_x_continuous(limits=c(0, 760), breaks=seq(0, 800, by=50)) +
  theme_bw() +
  theme(
    strip.background=element_blank(),
    strip.text.y=element_text(size=10, colour="black", angle=0),
    axis.ticks.y=element_blank()) +
  labs(y="", x="Physical Position (Mb)")

dev.off()


###We need to split chr3H out and plot it as the main text figure and then put the rest of them as supplemental figures:

#   extract Bd1 only:
allSNP_Bd1 <- allSNP[(allSNP$Chromosome == "Bd1"),]
tail(allSNP_Bd1)
dSNP_Bd1 <- dSNP[dSNP$Chromosome == "Bd1",]
highSNP_Bd1 <- highSNP[highSNP$Chromosome == "Bd1",]
excap_Bd1 <- excap[excap$Chromosome == "Bd1",]
rec_rate_Bd1 <- rec_rate[rec_rate$Chromosome == "Bd1",]
head(allSNP_Bd1)
str(allSNP_Bd1)
head(excap_Bd1)
head(rec_rate_Bd1)
tail(allSNP_Bd1)
tail(dSNP_Bd1)


pdf(file="~/Projects/Brachy_mutant/filtered_calls/combined/Brachy_mutant/plot/rec_dSNP_genedensity.pdf", 10, 3)
#ggplot(allSNP) +geom_vline(aes(xintercept=Position/100000),size=0.02, alpha=0.1, color="#a6cee3")
  
ggplot(allSNP_Bd1) +geom_vline(aes(xintercept=Position/100000),size=0.02, alpha=0.1, color="#a6cee3")+
  geom_line(aes(x=(Start+End)/200000, y=NExCap/10), data=excap_Bd1,size=0.75, color="blue", alpha=0.7) +
  geom_line(aes(x=(LeftBP+RightBP)/200000, y=Smoothed_cMMb), data=rec_rate_Bd1, color="#FFBF00", size=1, alpha=1) +
  geom_point(aes(x=Position/100000,y=20), data=highSNP_Bd1, color="purple", shape=1,size=1.5, alpha=0.25) +
  geom_point(aes(x=Position/100000,y=18), data=dSNP_Bd1, color="purple", shape=6,size=1.5, alpha=0.25)+
  geom_vline(aes(xintercept=Position/100000), data=allSNP,size=0.02, alpha=0.1, color="#a6cee3") +
  facet_grid(Chromosome~.) +
  scale_y_continuous(limits=c(0, 22), breaks=seq(0, 20, by=5)) +
  scale_x_continuous(limits=c(0, 760), breaks=seq(0, 800, by=50)) +
  theme_bw() +
  theme(
    strip.background=element_blank(),
    strip.text.y=element_text(size=10, colour="black", angle=0),
    axis.ticks.y=element_blank()) +
  labs(y="", x="Physical Position (Mb)")

dev.off()

#   extract the rest of chrs only:
arraySNP_rest <- arraySNP[arraySNP$Chromosome != "chr3H",]
exonSNP_rest <- exonSNP[exonSNP$Chromosome != "chr3H",]
excap_rest <- excap[excap$Chromosome != "chr3H",]
rec_rate_rest <- rec_rate[rec_rate$Chromosome != "chr3H",]

pdf(file="~/Projects/Brachy_mutant/filtered_calls/combined/Brachy_mutant/plot/rec_dSNP_genedensity.pdf", 10, 6)

ggplot(exonSNP_rest) +
  geom_vline(aes(xintercept=Position/1000000), size=0.02, alpha=0.1, color="#a6cee3") +
  geom_line(aes(x=(Start+End)/2000000, y=NExCap/10), data=excap_rest, size=0.75, color="#1f78b4", alpha=0.7) +
  geom_line(aes(x=(LeftBP+RightBP)/2000000, y=Smoothed_cMMb), data=rec_rate_rest, color="#9900ff", size=1, alpha=1) +
  geom_point(aes(x=PhysPos_2016/1000000,y=-log10(P.value)), data=arraySNP_rest, color="#ff4000", size=0.50, alpha=0.45) +
  geom_hline(yintercept = 3.30103,size=0.25,color="#000000",linetype="dotted") +
  facet_grid(Chromosome~.) +
  scale_y_continuous(limits=c(0, 10), breaks=c(0, 5, 10)) +
  scale_x_continuous(limits=c(0, 725), breaks=seq(0, 725, by=50)) +
  theme_bw() +
  theme(
    strip.background=element_blank(),
    strip.text.y=element_text(size=10, colour="black", angle=0),
    axis.ticks.y=element_blank()) +
  labs(y="", x="Physical Position (Mb)")

dev.off()
