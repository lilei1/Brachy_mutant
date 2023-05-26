#!/usr/bin/env python
"""Calculate the cM/Mb rate for the BOPA SNPs."""

import sys

physical_vcf = sys.argv[1]
genetic_map = sys.argv[2]


gen = {}
with open(genetic_map, 'r') as f:
    for index, line in enumerate(f):
        if index == 0:
            continue
        else:
            t = line.strip().split('\t')
            gen[t[0]] = (t[1], t[2])

phys = {}
ordered_snps = {}
with open(physical_vcf, 'r') as f:
    for line in f:
        if line.startswith('#'):
            continue
        else:
            t = line.strip().split()
            #   Only get the physical positions of the SNPs that are on the
            #   genetic map.
            if t[2] not in gen:
                continue
            else:
                phys[t[2]] = (t[0], t[1])
                if t[0] not in ordered_snps:
                    ordered_snps[t[0]] = []
                else:
                    ordered_snps[t[0]].append(t[2])

print ('\t'.join(['Chromosome', 'LeftBP', 'RightBP', 'cMMb']))
for chrom, markers in ordered_snps.items():
    for i in range(0, len(markers)-1):
        j = i + 1
        delta_phys = int(phys[markers[j]][1]) - int(phys[markers[i]][1])
        delta_gen = float(gen[markers[j]][1]) - float(gen[markers[i]][1])
        if delta_phys > 0:
            #cmmb = (delta_gen/delta_phys) * 1000000
            cmmb = (delta_gen/delta_phys) * 250000 #run 100 kb to see how the result look like!!!
        else:
            cmmb = 'NA'
        toprint = '\t'.join([chrom, phys[markers[i]][1], phys[markers[j]][1], str(cmmb)])
        print (toprint)
