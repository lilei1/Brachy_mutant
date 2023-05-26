#!/usr/bin/env python

# By Li Lei adapted from https://github.com/MorrellLAB/Barley_Inversions/edit/master/analyses/GATK_SNP_call/scripts/HeterozogotesVcfFilter.py
#A script to apply various arbitrary filters to a VCF. The three filters
#   I have included here are genotype quality score, number of heterozygous
#   samples, number of samples with missing data, and read depth.
#   All threshholds can be adjusted by modifying the parameters at the top
#   of the script. This script was written with the VCF output from the
#   GATK version 2.8.1. The format may change in the future.
#   This script writes the filtered VCF lines to standard output

import sys
import gzip
#   Our thresholds for filtering false positive heterozygous sites
#       Mininum depth for a single sample. 5 reads minimum, 102 reads max. This can be seen from the stacei samples!!!!
#mindp = 15
# Mininum depth for a single sample 5 reads minimum, 47 reads max. This is based on the distribution of the depth for all 114 distachyon samples
mindp = 5
maxdp = 47
#       Like "minor allele frequency" - the minimum amount of deviation from
#       50-50 ref/alt reads. +/- 10% deviation from 50-50
mindev = 0.10       
#   The genotype qualities (GQ) are also stored as a PHRED-scaled probability. I calculate the quantile of the GQ and 8% of the reads,So we pick 24 as thrshold 
#gt_cutoff = 30
gt_cutoff = 30
#   Our coverage cutoff is 5 reads per sample
#per_sample_coverage_cutoff = 5
per_sample_coverage_cutoff = 5
#   Read the file in line-by-line
with gzip.open(sys.argv[1], "rt") as f:
    for line in f:
        #   Skip the header lines - write them out without modification
        if line.startswith('#'):
            sys.stdout.write(line)
        else:
            tmp = line.strip().split('\t')
            #   we aren't confident in our ability to call ancestral state of
            #   indels, multiple alleles:
            #if len(tmp[3]) != 1 or len(tmp[4]) != 1:
            #    continue #skip the lines satisfied with the condition;
            #else:
                #We want to keep the PASS SNPs
            if tmp[6] == 'PASS':
                genotypes = tmp[9:]
                    ####enumerate is the function to iterate the index and the values for the list:
                for geno_index, s in enumerate(genotypes):
                        #   GT:AD:DP:GQ:PL
                    gt_metadata = s.split(':')
                    gt = gt_metadata[0]
                    dp = gt_metadata[2]
                    ad = gt_metadata[1].split(',')
                    gq = gt_metadata[3]
                    if  dp == '.' or gq == '.' :
                        continue
                    else:
                        if int(dp) < per_sample_coverage_cutoff or int(gq) < gt_cutoff:
                            tmp[9+geno_index] = ':'.join(['./.'] + tmp[9+geno_index].split(':')[1:])
                        else:                           
                            if gt == '0/1':
                                ref = float(ad[0])
                                alt = float(ad[1]) 
                                if ref+alt !=0:
                                    balance = ref/(ref+alt)                         
                                    if dp != '.':
                                        if int(dp) < mindp or int(dp) > maxdp or abs(0.5 - balance) > mindev:
                                                 #gt = './.'
                                                tmp[9+geno_index] = ':'.join(['./.'] + tmp[9+geno_index].split(':')[1:])
                                else:
                                    tmp[9+geno_index] = ':'.join(['./.'] + tmp[9+geno_index].split(':')[1:])
                                    #sys.stdout.write('\t'.join(tmp) + '\n')
                sys.stdout.write('\t'.join(tmp) + '\n')
