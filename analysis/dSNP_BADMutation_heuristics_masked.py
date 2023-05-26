#!/usr/bin/env python
#Write by Li Lei 2021/06/15
"""Decide which SNP is deleterious by BAD_Mutations. Since compile in BAD_Mutation is not correct if we used 61 aligned genome, so we have to switch
to the heuristics approach according to Kono et al., 2017 MBE paper and Chun and Fay 2009 Genome Res paper."""


import sys

min_lrt_seq = 20
#   We predicted on 228,110 codons (nonsynonymous SNPs), so that becomes the basis of our multiple
#   testing correction
#lrt_sig = 0.05/228110#mutant
lrt_sig = 0.05/235307#natural lines

with open(sys.argv[1], 'r') as f:
    for index, line in enumerate(f):
        if index == 0:
            continue
        else:
            tmp = line.strip().split('\t')
            if tmp[12] == "-":#some SNPs are not predicted by BAD_Mutations because of the alignment problems
                tmp.append("-")
            else: 
        #For the columns combined with Annovar table and pph2, provean,(zero based) are
        #       MaskedConstraint: 23
        #       MaskedP-value: 24
        #       seqcount: 20
        #       alignment: 21
        #       ref: 8
        #       alt: 9
                masked_constraint = float(tmp[23])
                masked_pval = float(tmp[24])
                aln = tmp[21]
                #nseq = int(tmp[20])
                ref = tmp[8]
                alt = tmp[9]
                rn = aln.count(ref)
                an = aln.count(alt)
                #print (min([rn,an]))
                #if (masked_pval < lrt_sig):
                #    print (masked_pval)
                if (masked_pval < lrt_sig) and (float(abs(rn-an)) >= min_lrt_seq) and (masked_constraint < 1) and (min([rn,an]) == 0):
                    tmp.append("Deleterious") 
                else:
                    tmp.append("Tolerant") 

            print ('\t'.join(tmp))
