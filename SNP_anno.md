# Aim: This analysis is to predict which SNPs are deleterious
# Since the ANNOVAR software will need to feed the vcf file without any modification, I have ask Joel Martin send me the vcf files before running SNPeff.
# Here is the directory and list of the files:

```
/global/projectb/scratch/j_martin/brachy-snpcheck/results/plate.0.gatk.hf.sc.vcf.gz 
/global/projectb/scratch/j_martin/brachy-snpcheck/results/plate.1.gatk.hf.sc.vcf.gz 
/global/projectb/scratch/j_martin/brachy-snpcheck/results/plate.2.gatk.hf.sc.vcf.gz 
/global/projectb/scratch/j_martin/brachy-snpcheck/results/plate.3.gatk.hf.sc.vcf.gz 
/global/projectb/scratch/j_martin/brachy-snpcheck/results/plate.4.gatk.hf.sc.vcf.gz 
/global/projectb/scratch/j_martin/brachy-snpcheck/results/plate.5,13-16.part1.gatk.hf.sc.vcf.gz 
/global/projectb/scratch/j_martin/brachy-snpcheck/results/plate.5,13-16.part2.gatk.hf.sc.vcf.gz 
/global/projectb/scratch/j_martin/brachy-snpcheck/results/plate.5,13-16.part3.gatk.hf.sc.vcf.gz 
/global/projectb/scratch/j_martin/brachy-snpcheck/results/plate.6.gatk.hf.sc.vcf.gz 
/global/projectb/scratch/j_martin/brachy-snpcheck/results/plate.7.gatk.hf.sc.vcf.gz 
/global/projectb/scratch/j_martin/brachy-snpcheck/results/plate.8.gatk.hf.sc.vcf.gz 
/global/projectb/scratch/j_martin/brachy-snpcheck/results/plate.9.gatk.hf.sc.vcf.gz 
/global/projectb/scratch/j_martin/brachy-snpcheck/results/plate.10.gatk.hf.sc.vcf.gz 
/global/projectb/scratch/j_martin/brachy-snpcheck/results/plate.11.gatk.hf.sc.vcf.gz 
/global/projectb/scratch/j_martin/brachy-snpcheck/results/plate.12.gatk.hf.sc.vcf.gz 
/global/projectb/scratch/j_martin/brachy-snpcheck/results/plate.17.gatk.hf.sc.vcf.gz 
/global/projectb/scratch/j_martin/brachy-snpcheck/results/plate.18.gatk.hf.sc.vcf.gz 
/global/projectb/scratch/j_martin/brachy-snpcheck/results/plate.21.gatk.hf.sc.vcf.gz 
/global/projectb/scratch/j_martin/brachy-snpcheck/results/plate.22.gatk.hf.sc.vcf.gz 
/global/projectb/scratch/j_martin/brachy-snpcheck/results/plate.23.gatk.hf.sc.vcf.gz 
/global/projectb/scratch/j_martin/brachy-snpcheck/results/plate.24.gatk.hf.sc.vcf.gz 
```

## The processes I did:

### 1. Combined all of the vcf files together with bcftools



