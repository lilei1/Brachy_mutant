#!/usr/bin/env python
"""Convert from ANNOVAR output to a unified table, in the same form as the
output from SNP_Effect_Predictor.py:
    SNP ID
    Chromosome
    Position (1-based)
    Silent or not?
    Transcript ID
    Codon position
    Reference allele
    Alternate allele
    AA1
    AA2
    Residue number
"""
#this is adapted from Tomo Kono's script by Li Lei, 20170804, https://github.com/MorrellLAB/Deleterious_GP/blob/master/Analysis_Scripts/Data_Handling/ANNOVAR_To_Effects.py
#usages: ./ANNOVAR_To_Effects.py all_effects exon_effects >your_output_table
import sys

all_effects = sys.argv[1]
exon_effects = sys.argv[2]

coding_variants = {}
with open(exon_effects, 'r') as f:
    for line in f:
        tmp = line.strip().split('\t')
        #snpid = tmp[13]
        if tmp[1] == 'synonymous SNV':
            silent = 'Yes'
        else:
            silent = 'No'
        tmp1 = tmp[2].split(',')
        ann = tmp1[0].split(':')
        txid = ann[1]
        aa1 = ann[4][2]
        aa2 = ann[4][-1]
        #print(aa2)
        if tmp[1] == 'stopgain':
            aa2 = '*'
        if tmp[1] == 'stoploss':
            aa1 = '*'
        aapos = ann[4][3:-1]
        pos = tmp[4]
        chrom = tmp[3]
        snpid = '.'.join([chrom,pos])
        #print (snpid)
        ref_allele = tmp[6]
        alt_allele = tmp[7]
        cdspos = ann[3][3:-1]
        codonpos = str(3 - (int(cdspos) % 3))
        coding_variants[snpid] = (
            chrom,
            pos,
            silent,
            txid,
            codonpos,
            ref_allele,
            alt_allele,
            aa1,
            aa2,
            cdspos,
            aapos)

print ('\t'.join(
    [
        'SNP_ID',
        'Chromosome',
        'Position',
        'Silent',
        'Transcript_ID',
        'Codon_Position',
        'Ref_Base',
        'Alt_Base',
        'AA1',
        'AA2',
        'CDS_Pos',
        'AA_Pos'
    ]))

with open(all_effects, 'r') as f:
    for line in f:
        tmp = line.strip().split('\t')
        #snpid = tmp[12]
        #chrom = tmp[1]
        #pos = tmp[2]
        snpid = '.'.join([tmp[2],tmp[3]])#chrom is the tmp[2]; pos is tmp[3]
        #print (snpid)
        if tmp[0] == 'exonic':
            chrom, pos, silent, txid, codonpos, ref_allele, alt_allele, aa1, aa2, cdspos, aapos = coding_variants[snpid]
            #print("R")
        else:
            chrom = tmp[2]
            pos = tmp[3]
            silent = 'Yes'
            txid = '-'
            codonpos = '-'
            ref_allele = tmp[4]
            alt_allele = tmp[5]
            aa1 = '-'
            aa2 = '-'
            cdspos = '-'
            aapos = '-'
        print ('\t'.join(
            [
                snpid,
                chrom,
                pos,
                silent,
                txid,
                codonpos,
                ref_allele,
                alt_allele,
                aa1,
                aa2,
                cdspos,
                aapos
            ]))