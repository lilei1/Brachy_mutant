#!/usr/bin/env python

#   by Li Lei
#   A script to apply various arbitrary filters to a VCF. The three filters
#   I have included here are genotype quality score, number of heterozygous
#   samples, number of samples with missing data, and read depth.
#   All threshholds can be adjusted by modifying the parameters at the top
#   of the script. This script was written with the VCF output from the
#   GATK version 2.8.1. The format may change in the future.
#   This script writes the filtered VCF lines to standard output

import sys
import os
import gzip
#   If variants have below a PHRED-scaled quality of 40,
#   The quality score in the 5th column, we did the quantile for those values and found that 40 is correct score.
quality_cutoff = 40

#Filter the 83% of the number of heterozygotes for genotype call: The heterozygosite of distachyon is 0.2% from https://peerj.com/articles/2407/
het_cutoff = 0 #114*0.002=0.228 ~=0

#   We exclude 30% missing data
#missing_cutoff = 34 #114*0.3=34.2
missing_cutoff = 0 #114*0.3=34.2


#   If we have low genotype confidence, then we also want to exclude the SNP
#   The genotype qualities (GQ) are also stored as a PHRED-scaled probability. I calculate the quantile of the GQ and 10% of the reads, GQ>=39, but for distachyon, the lower 10% is 24, So we pick 24as thrshold for both

gt_cutoff = 30
#n_gt_cutoff = 1
#   Our coverage cutoff is 5 reads per sample
per_sample_coverage_cutoff = 5
#all of the samples should be have high coverage
#n_low_coverage_cutoff = 0
#   The number of samples
#nsam = 1

#   Read the file in line-by-line
with gzip.open(sys.argv[1], "rt") as f:
    for line in f:
        #   Skip the header lines - write them out without modification
        if line.startswith('#'):
            sys.stdout.write(line)
        else:
            tmp = line.strip().split('\t')
            #print (line)
            #   we aren't confident in our ability to call ancestral state of
            #   indels
            #if len(tmp[3]) != 1 or len(tmp[4]) != 1:
                #continue
            #else:
            format = tmp[8]
            sample_information = tmp[9:]
                #   The genotype information is the first element of each sample
                #   info block in the VCF
                #   start counting up the number of hets, low quality genotypes and
                #   low coverage sites
            nhet = 0
            low_qual_gt = 0
            low_coverage = 0
            missing_data = 0
            for s in sample_information:
                    #   For the GATK HaplotypeCaller, the per-sample information
                    #   follows the form generally, but sometimes it has GAT:AD:DP:GQ:PGT:PID:PL, and majority of the time are only
                    #   GT:AD:DP:GQ:PL. It seems like majority of the SNPs with 7 fields are 
                info = s.split(':')
                    #if len(info) != 5:
                    #    print (format,line)
                    #    break
                gt = info[0]
                    #   We have to check for missing data first, because if it is
                    #   missing, then the other fields are not filled in
                if '.' in gt:
                    missing_data += 1
                        #print (s,missing_data)
                else:
                    dp = info[2]
                    gq = info[3]
                        #   Split on / (we have unphased genotypes) and count how
                        #   many hets we have
                    if len(set(gt.split('/'))) > 1:
                        nhet += 1
                    if dp == '.' or int(dp) < per_sample_coverage_cutoff or gq == '.' or int(gq) < gt_cutoff:
                            #low_coverage += 1
                        missing_data += 1
                    #if gq == '.' or int(gq) < gt_cutoff:
                    #    low_qual_gt += 1
                #print (s,missing_data)        
            #   The quality score is the sixth element
            #print (tmp[0],tmp[1],missing_data,nhet)
            if tmp[5] == '.' or tmp[6] != 'PASS' or float(tmp[5]) < quality_cutoff or nhet > het_cutoff  or missing_data > missing_cutoff:
            #if tmp[5] == '.' or float(tmp[5]) < quality_cutoff or nhet > het_cutoff or low_qual_gt > n_gt_cutoff or low_coverage > n_low_coverage_cutoff or missing_data > missing_cutoff:
               continue
            else:
                sys.stdout.write(line)