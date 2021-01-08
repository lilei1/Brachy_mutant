# Aim: This analysis is to predict which SNPs are deleterious
 Since the ANNOVAR software will need to feed the vcf file without any modification, I have ask Joel Martin send me the vcf files before running SNPeff.
 Here is the directory and list of the files:

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

### 1. Combined all of the vcf files together with bcftools.

The job script can be see [here](https://github.com/lilei1/Brachy_mutant/blob/master/jobs/bcf_merge.sub)

```
sbatch -C haswell /global/projectb/scratch/llei2019/jobs/bcf_merge.sub

```
The merged vcf file can be avaible at this path `/global/cscratch1/sd/llei2019/Bdist_mutant/plate.0_24.gatk.hf.sc.vcf.gz`

### 2. Extract the nonsyn. SNPs based on Joel's annotation.

At first I thought since Joel has annotated those SNPs with SNPeff, I only focus on the nonsyn SNPs. so I just extract the nonsyn. SNPs from the merged vcf file.

I need to extract the position of the nonsyn SNPs from combined csv file from the local computer `/Users/LiLei/Projects/Brachy_mutant/filtered_calls/combined/combined_plates_filtered_mutant_lines_1-18column_deloutlier_orgnell.csv`

- Extract the nonsyn. SNPs with this command line:

```
grep "NON_SYNONYMOUS_CODING" combined_plates_filtered_mutant_lines_1-18column_deloutlier_orgnell.csv|cut -d "," -f 3,4,8,9|tr '[,]' '[\t]'|sort -k1,1 -k2,2n|uniq >sorted_unique_nonsynSNPs_tab.txt
```

- Convert the file generated from the previous step into bed file:

```
awk -F '\t' -v OFS='\t' '{ $(NF+1) = $2-1; print }' /global/cscratch1/sd/llei2019/Bdist_mutant/sorted_unique_nonsynSNPs_tab.txt >/global/cscratch1/sd/llei2019/Bdist_mutant/sorted_unique_nonsynSNPs_tab_forbed.txt

paste  <(cut -f 1 /global/cscratch1/sd/llei2019/Bdist_mutant/sorted_unique_nonsynSNPs_tab_forbed.txt) <(cut -f 2 /global/cscratch1/sd/llei2019/Bdist_mutant/sorted_unique_nonsynSNPs_tab_forbed.txt) <(cut -f 5 /global/cscratch1/sd/llei2019/Bdist_mutant/sorted_unique_nonsynSNPs_tab_forbed.txt) >/global/cscratch1/sd/llei2019/Bdist_mutant/sorted_unique_nonsynSNPs_tab.bed
```

- Extract the varaints from the combined vcf file

```
bcftools view --regions-file /global/cscratch1/sd/llei2019/Bdist_mutant/sorted_unique_nonsynSNPs_tab.bed plate.0_24.gatk.hf.sc.vcf.gz -O z -o nonsyn_plate.0_24.gatk.hf.sc.vcf.gz

```

- Extract biallelic SNPs from the vcf file extracted by previous step

```
vcftools --gzvcf /global/u2/l/llei2019/cscratch/Bdist_mutant/nonsyn_plate.0_24.gatk.hf.sc.vcf.gz --remove-indels --min-alleles 2 --max-alleles 2 --recode --recode-INFO-all --out /global/u2/l/llei2019/cscratch/Bdist_mutant/reanno_all/biSNPs_nonsyn_plate.0_24.gatk.hf.sc.vcf
```

### 3. check the SNPs from the file `/global/u2/l/llei2019/cscratch/Bdist_mutant/reanno_all/biSNPs_nonsyn_plate.0_24.gatk.hf.sc.vcf`

I found ~4% of the SNPs in the csv file but not in the vcf file, and I am contacting Joel and tried to figure out what is going on with those file. Maybe Test Plate and Tubes are missing??
Slack with Joel and I figured out that "Test Plate" = "plate0", so that could be because of missing samples from tubes. Joel is going to check those SNPs and return me the vcf file back.

### 4. Start to annotate SNPs with [ANNOVAR]( http://www.openbioinformatics.org/annovar/download/0wgxR2rIVP/annovar.latest.tar.gz)

    - a. Download the v1.1.gene_exons from the phytozome 12 Potal v1.1
    
    - b. convert the gff3 into gtf with [gffread](https://github.com/gpertea/gffread)
    
    ```
    /global/projectb/scratch/llei2019/software/gffread/gffread -E -F -T /global/u2/l/llei2019/cscratch/Bd21_3/v1.1/annotation/BdistachyonBd21_3_460_v1.1.gene_exons.gff3 -o /global/u2/l/llei2019/cscratch/Bdist_mutant/BdistachyonBd21_3_460_v1.1.gene_exons.gtf
    ```

    - c. Then just extract the primary transcript!!!!

```
# This is identify the primary transcript id
zgrep ">" /global/u2/l/llei2019/cscratch/Bd21_3/v1.1/annotation/BdistachyonBd21_3_460_v1.1.cds_primaryTranscriptOnly.fa|cut -d " " -f 1 >primaryTranscriptOnly.list
sed -i 's/>//g' primaryTranscriptOnly.list
```

```
# This is for extracting the primary transcript according to the primary transcript id
perl /global/u2/l/llei2019/Github/Brachy_mutant/scripts/extract_primaryTranscripts.pl /global/u2/l/llei2019/cscratch/Bdist_mutant/primaryTranscriptOnly.list /global/u2/l/llei2019/cscratch/Bdist_mutant/BdistachyonBd21_3_460_v1.1.gene_exons.gtf /global/u2/l/llei2019/cscratch/Bdist_mutant/BdistachyonBd21_3_460_v1.1.gene_exons_primary.gtf /global/u2/l/llei2019/cscratch/Bdist_mutant/BdistachyonBd21_3_460_v1.1.gene_exons_secondary.gtf
```
So the gtf file we are going to use is here:

`/global/u2/l/llei2019/cscratch/Bdist_mutant/BdistachyonBd21_3_460_v1.1.gene_exons_primary.gtf`

    - d. build the database for ANNOVAR
```    
/global/projectb/scratch/llei2019/software/annovar/gtfToGenePred -genePredExt /global/u2/l/llei2019/cscratch/Bdist_mutant/BdistachyonBd21_3_460_v1.1.gene_exons_primary.gtf /global/cscratch1/sd/llei2019/Bdist_mutant/ANNOVAR/Bd21_3/Bd21_3_refGene.txt
```

```
perl /global/projectb/scratch/llei2019/software/annovar/retrieve_seq_from_fasta.pl --format refGene --seqfile /global/u2/l/llei2019/cscratch/Bd21_3/v1.1/assembly/BdistachyonBd21_3_460_v1.0.fa /global/cscratch1/sd/llei2019/Bdist_mutant/ANNOVAR/Bd21_3/Bd21_3_refGene.txt --out /global/cscratch1/sd/llei2019/Bdist_mutant/ANNOVAR/Bd21_3/Bd21_3_refGeneMrna.fa
NOTICE: Reading region file /global/cscratch1/sd/llei2019/Bdist_mutant/ANNOVAR/Bd21_3/Bd21_3_refGene.txt ... Done with 36647 regions from 8 chromosomes
NOTICE: Finished reading 11 sequences from /global/u2/l/llei2019/cscratch/Bd21_3/assembly/BdistachyonBd21_3_460_v1.0.fa
NOTICE: Finished reading 11 sequences from /global/u2/l/llei2019/cscratch/Bd21_3/assembly/BdistachyonBd21_3_460_v1.0.fa
NOTICE: Finished reading 11 sequences from /global/u2/l/llei2019/cscratch/Bd21_3/assembly/BdistachyonBd21_3_460_v1.0.fa
NOTICE: Finished reading 11 sequences from /global/u2/l/llei2019/cscratch/Bd21_3/assembly/BdistachyonBd21_3_460_v1.0.fa
NOTICE: Finished reading 11 sequences from /global/u2/l/llei2019/cscratch/Bd21_3/assembly/BdistachyonBd21_3_460_v1.0.fa
NOTICE: Finished reading 11 sequences from /global/u2/l/llei2019/cscratch/Bd21_3/assembly/BdistachyonBd21_3_460_v1.0.fa
NOTICE: Finished reading 11 sequences from /global/u2/l/llei2019/cscratch/Bd21_3/assembly/BdistachyonBd21_3_460_v1.0.fa
NOTICE: Finished reading 11 sequences from /global/u2/l/llei2019/cscratch/Bd21_3/assembly/BdistachyonBd21_3_460_v1.0.fa
NOTICE: Finished writting FASTA for 36647 genomic regions to /global/cscratch1/sd/llei2019/Bdist_mutant/ANNOVAR/Bd21_3/Bd21_3_refGeneMrna.fa
```

     - e. convert the vcf file from GATK to the format vcf ANNOVAR liked:

```
perl /global/projectb/scratch/llei2019/software/annovar/convert2annovar.pl --format vcf4 --allsample --withfreq --includeinfo --outfile /global/u2/l/llei2019/cscratch/Bdist_mutant/ANNOVAR/Bd21_3_annovar_in_onlybiSNPnonsyn.txt /global/u2/l/llei2019/cscratch/Bdist_mutant/reanno_all/biSNPs_nonsyn_plate.0_24.gatk.hf.sc.vcf.recode.vcf
NOTICE: Finished reading 202554 lines from VCF file
NOTICE: A total of 202472 locus in VCF file passed QC threshold, representing 202472 SNPs (193123 transitions and 9349 transversions) and 0 indels/substitutions
NOTICE: Finished writing allele frequencies based on 399274784 SNP genotypes (380838556 transitions and 18436228 transversions) and 0 indels/substitutions for 1972 samples
(/global/homes/l/llei2019/bscratch/software/my_work_en) 
```
    - f. annotation with Annovar
    
```
perl /global/projectb/scratch/llei2019/software/annovar/annotate_variation.pl --geneanno --dbtype refGene --buildver Bd21_3 /global/u2/l/llei2019/cscratch/Bdist_mutant/ANNOVAR/Bd21_3_annovar_in_onlybiSNPnonsyn.txt /global/u2/l/llei2019/cscratch/Bdist_mutant/ANNOVAR/Bd21_3/
```

    - g. convert the annovaar table into unified table:
    
```
python /global/u2/l/llei2019/Github/Brachy_mutant/scripts/ANNOVAR_To_Effects.py /global/cscratch1/sd/llei2019/Bdist_mutant/ANNOVAR/Bd21_3_annovar_in_onlybiSNPnonsyn.txt.variant_function /global/cscratch1/sd/llei2019/Bdist_mutant/ANNOVAR/Bd21_3_annovar_in_onlybiSNPnonsyn.txt.exonic_variant_function >/global/cscratch1/sd/llei2019/Bdist_mutant/ANNOVARBd21_3_onlybiSNPnonsyn_annovar_unified.table
```

Then I checked how may nonsyn. SNPs I have:

```
grep "No" ANNOVARBd21_3_onlybiSNPnonsyn_annovar_unified.table|wc -l
201,931
```

But the nonsyn SNPs Joel annotated 

```
wc -l sorted_unique_nonsynSNPs_tab.bed
203,458 sorted_unique_nonsynSNPs_tab.bed
```
But the nonsyn SNPs Joel annotated and also showing in the merged vcf file:
```
grep -v "#" /global/u2/l/llei2019/cscratch/Bdist_mutant/reanno_all/biSNPs_nonsyn_plate.0_24.gatk.hf.sc.vcf|wc -l 
202,472

```
so there are 202,472 - 201,931=541 not consistent with Joel's annotation. After talk to Joel and John, and it seems like Joel used all of the gene model to do annotation but for somereason the csv file only report single annotation from one gene model. This could be the reason why there are 541/202472=0.0027 inconsistent.

Since this project is hurry and Debi need to grow the plants, so I may just focus on my prediction with the nonsyn. annotated by ANNOVAR using the filtered mergerd vcf file (filtered by bioallelic SNPs)


---

What I did for those SNPs, the steps like this

- Extract the biallelic SNPs with vcftools

```
vcftools --gzvcf /global/u2/l/llei2019/cscratch/Bdist_mutant/plate.0_24.gatk.hf.sc.vcf.gz --remove-indels --min-alleles 2 --max-alleles 2 --recode --recode-INFO-all --out /global/u2/l/llei2019/cscratch/Bdist_mutant/reanno_all/biSNPs_plate.0_24.gatk.hf.sc.vcf

```

The a-d steps are the same as the nonsyn. SNPs processing,

    - e' convert the vcf file from GATK to the format vcf ANNOVAR liked with [run_anno_variants.sub] (https://github.com/lilei1/Brachy_mutant/blob/master/jobs/run_convert2annovar.sub):
    
```    
 sbatch -C haswell ~/bscratch/jobs/run_anno_variants.sub
Submitted batch job 37672877
(/global/homes/l/llei2019/bscratch/software/my_work_en) 
```

    - f' Annotation with Annovar with [run_convert2annovar.sub] (https://github.com/lilei1/Brachy_mutant/blob/master/jobs/run_anno_variants.sub)
    
```
sbatch -C haswell /global/projectb/scratch/llei2019/jobs/run_convert2annovar.sub 
```

    -e' convert the annovaar table into unified table with [run_table_annovar.sub] ()
    
```

```