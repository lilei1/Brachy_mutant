Objective: This tutorial is to filter the variants from diverse lines.

The vcf file called with GATK by Jie is : `/global/projectb/sandbox/reseq/projects/working/Brachypodium_distachyon_redux_Bd21-3/set_distanchyon_redo/genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno.vcf.gz`


What we need to do?
fromat the file and filter out the SNPs

How to do filtering for natural lines!!
1: only PASS?
2: biaalelic?

## Steps: 

### 1 Extract the only PASS and biaalelic SNPs

```
source activate /global/homes/l/llei2019/bscratch/software/my_work_en

cp /global/projectb/sandbox/reseq/projects/working/Brachypodium_distachyon_redux_Bd21-3/set_distanchyon_redo/genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno.vcf.gz .

#Keep PASS SNPs
bcftools index genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno.vcf.gz
bcftools view -f PASS genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno.vcf.gz >filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno.vcf

#Then keep only biallelic variants with vcftools:

vcftools --vcf filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno.vcf --min-alleles 2 --max-alleles 2 --recode --recode-INFO-all --out biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno.vcf
```

### 2 Do further filtering

#### 1) check the depth threshold:

```
vcftools --vcf biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno.vcf.recode.vcf --geno-depth --out biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno
```

#Then we need to do some filtering based on the read depth and run R to check the depths:

```
GP <- read.table(file="~/bscratch/Bd21_3_mutant/natural_lines/data/biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno.gdepth",sep="\t", header =T, na.strings="NA")	
GP[,c(1:2)]<- NULL
GP_quantile <- quantile(as.numeric(as.matrix(as.vector(GP))),probs=seq(0,1,0.01),na.rm = TRUE)

write.table(x=GP_quantile, file="~/bscratch/Bd21_3_mutant/natural_lines/data/biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno.gdepth.quantile",sep="\t")

```
#5-47 is a good depths!!!

#### 2) check the GQ threshold:

#extract the GQ from the vcf file:
```
vcftools --vcf biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno.vcf.recode.vcf --extract-FORMAT-info GQ --out biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno.GQ

GQ <- read.table(file="~/bscratch/Bd21_3_mutant/natural_lines/data/biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno.GQ.GQ.FORMAT",sep="\t", header =T, na.strings="NA")
GQ[,c(1:2)]<- NULL
GQ_quantile <- quantile(as.numeric(as.matrix(as.vector(GQ))),probs=seq(0,1,0.01),na.rm = TRUE)

write.table(x=GQ_quantile, file="~/bscratch/Bd21_3_mutant/natural_lines/data/biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno.GQ.GQ.FORMAT.quantile",sep="\t")


# I Want to plot the distachyon but can not do that due to so many samples. I have to radomly subsampled 50 samples and see what is going on

```
GQ_quantile
  0%   1%   2%   3%   4%   5%   6%   7%   8%   9%  10%  11%  12%  13%  14%  15% 
   0    3    6   12   15   21   24   27   30   31   33   36   36   39   39   42 
 16%  17%  18%  19%  20%  21%  22%  23%  24%  25%  26%  27%  28%  29%  30%  31% 
  42   45   45   45   48   48   48   51   51   51   53   54   54   54   57   57 
 32%  33%  34%  35%  36%  37%  38%  39%  40%  41%  42%  43%  44%  45%  46%  47% 
  57   57   57   60   60   60   60   60   60   60   60   60   60   61   63   63 
 48%  49%  50%  51%  52%  53%  54%  55%  56%  57%  58%  59%  60%  61%  62%  63% 
  63   64   66   66   68   69   69   72   72   72   72   72   72   72   72   72 
 64%  65%  66%  67%  68%  69%  70%  71%  72%  73%  74%  75%  76%  77%  78%  79% 
  74   75   75   77   78   79   81   81   81   81   81   81   81   83   84   84 
 80%  81%  82%  83%  84%  85%  86%  87%  88%  89%  90%  91%  92%  93%  94%  95% 
  87   89   90   90   90   90   90   93   94   98   99   99   99   99   99   99 
 96%  97%  98%  99% 100% 
  99   99   99   99   99 
```
#GQ: 30-99 is good!

#### 3) treat the heterozygotes of the distachyon series samples with missing: treat unbalanced heterozygotes or heterozygotes with super low or high depth reads as missing genotypes
QUAL

#The heterozygosity of distachyon is : 0.002 from
https://bmcecolevol.biomedcentral.com/track/pdf/10.1186/s12862-017-0996-x.pdf

114*0.002=0.228 

```
bgzip biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno.vcf.recode.vcf

#Treat something as missing

llei2019@cori13 14:35:57 ~/bscratch/Bd21_3_mutant/natural_lines/data 

$ python  ~/bscratch/Bd21_3_mutant/natural_lines/scripts/HeterozogotesVcfFilter_dist.py biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno.vcf.recode.vcf.gz >treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno.vcf.recode.vcf

#do filtering including missing: 60% missing will be filkter out!!!

#Here allow only 0.3 missingness!!!

```
llei2019@cori13 16:43:18 ~/bscratch/Bd21_3_mutant/natural_lines/data 
$ python  ~/bscratch/Bd21_3_mutant/natural_lines/scripts/Filter_sites_dist.py treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno.vcf.recode.vcf.gz >filtered_treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno.vcf.recode.vcf
```

#### 3) Filter the SNPs and plot the SFSF to see how it look like?

```
grep -v "#" filtered_treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno.vcf.recode.vcf|wc -l
6,924,193
(base) 
```

##We need to filter out the SNPs with monomorphic SNPs
114*2=228 
Since 1/228=0.0044  (if singleton in the file), we need to filter out the MAF < 0.0044 

```
vcftools --vcf filtered_treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno.vcf.recode.vcf --maf 0.0044 --recode --recode-INFO-all --out filtered_treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno_mafgt0.0044
After filtering, kept 6376145 out of a possible 6924193 Sites
Everage varaints = to ???
6376145/114=55931.0965 
```
#Run maf calculation and figure out the 
use base enviroment!!!1

```
python ~/bscratch/Bd21_3_mutant/natural_lines/scripts/VCF_MAF.py filtered_treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno_mafgt0.0044.recode.vcf >filtered_treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno_mafgt0.0044.recode.maf


vcftools --vcf filtered_treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno_mafgt0.0044.recode.vcf --remove-indels  --recode --recode-INFO-all --out /global/u2/l/llei2019/cscratch/B_hybridum/Ruben_synteny/onlySNP_filtered_treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno_mafgt0.0044

grep -v "#" onlySNP_filtered_treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno_mafgt0.0044.recode.vcf|wc -l
5676383
(base) 

The proportion of SNPs of all varaints!!! 
5676383/6376145=0.8903 

vcftools --vcf onlySNP_filtered_treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno_mafgt0.0044.recode.vcf --TsTv-summary --stdout
MODEL   COUNT
AC      425630
AG      2014683
AT      321906
CG      471513
CT      2016472
GT      426179
Ts      4031155
Tv      1645228
(base) 
4031155/1645228=2.4502 
```

#Run my script to calculate the SFS? https://github.com/lilei1/Utilites/blob/master/script/VCF_MAF.py

```
python ~/bscratch/Bd21_3_mutant/natural_lines/scripts/VCF_MAF.py onlySNP_filtered_treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno_mafgt0.0044.recode.vcf >onlySNP_filtered_treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno_mafgt0.0044.maf
```

```
module load R
R

> wbdc_maf <- read.table(file="~/bscratch/Bd21_3_mutant/natural_lines/data/onlySNP_filtered_treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno_mafgt0.0044.maf", sep="\t", header = T)
> head(wbdc_maf)
  Chrom  Pos sample_NB Major Minor        MAF
1   Bd1 3632       102     A     G 0.03921569
2   Bd1 3768        99     C     T 0.05050505
3   Bd1 3776        98     A     C 0.06122449
4   Bd1 3874        99     G     A 0.01010101
5   Bd1 3880        98     T     C 0.23469388
6   Bd1 3884        98     A     G 0.04081633
> hist(wbdc_maf$MAF,breaks = 50, main="Distribution of MAF in all 114 distachyon accessions",xlab="MAF")
> pdf(file = "~/bscratch/Bd21_3_mutant/natural_lines/data/onlySNP_filtered_treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno_mafgt0.0044.pdf",width = 20,height = 20)
> hist(wbdc_maf$MAF,breaks = 50, main="Distribution of MAF in all 114 distachyon accessions",xlab="MAF",cex.axis=1.5, xlim=c(0,0.5),ylim=c(0,1000000))
> dev.off()
null device 
          1 
114*0.3=34.2 
This is for plot the [SFS](), and it seems good for SFS! So I just stick with this filtering criteria!!!
```

### 3 So now I need to split the variants into common and rare varaints:

- common one

- rare one >=2 accession have the variants!!!

1/114=0.0088 
2/114=0.0175 
<= 0.0175, then those variants canbe classified as rare, other wise will be classified as common


```
perl ~/bscratch/Bd21_3_mutant/natural_lines/scripts/classify_variants.pl filtered_treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno_mafgt0.0044.recode.maf filtered_treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno.vcf.recode.vcf rare_variants.vcf common_variants.vcf

sbatch run_classify_variants.job 
Submitted batch job 45131630
(base) 
```

### 4 split the common and rare variants into SNPs and deletions

```
vcftools --vcf rare_variants.vcf --remove-indels  --recode --recode-INFO-all --out  ~/bscratch/Bd21_3_mutant/natural_lines/data/rare_variants_SNPs


After filtering, kept 1166434 out of a possible 1312189 Sites
1166434/1312189=0.8889 


vcftools --vcf common_variants.vcf --remove-indels  --recode --recode-INFO-all --out ~/bscratch/Bd21_3_mutant/natural_lines/data/common_variants_SNPs
 4509949 out of a possible 5063956 Sites

4509949/5063956=0.8906 

vcftools --vcf rare_variants.vcf --keep-only-indels  --recode --recode-INFO-all --out ~/bscratch/Bd21_3_mutant/natural_lines/data/rare_variants_indels
After filtering, kept 145,755 out of a possible 1,312,189 Sites

vcftools --vcf common_variants.vcf --keep-only-indels  --recode --recode-INFO-all --out ~/bscratch/Bd21_3_mutant/natural_lines/data/common_variants_indels

After filtering, kept 554007 out of a possible 5063956 Sites

554007/5063956=0.1094 
1-0.1094=0.8906 
```

##Since we only care about the deletion, so I need to filter out the insertions!!!

```
bcftools filter -i "strlen(REF)>strlen(ALT)" rare_variants_indels.recode.vcf >rare_variants_indels_del.vcf
 grep -v "#" rare_variants_indels_del.vcf|wc -l
101,491

grep -v "#" rare_variants_SNPs.recode.vcf|wc -l
1,166,434



bcftools filter -i "strlen(REF)>strlen(ALT)" common_variants_indels.recode.vcf >common_variants_indels_del.vcf

grep -v "#" common_variants_indels_del.vcf|wc -l
342,432
grep -v "#" common_variants_SNPs.recode.vcf|wc -l
4,509,949


101491/(1166434+101491)=0.08 

1,166,434/(1166434+101491)=0.92 

342,432/(342,432+4,509,949)=0.0706 
```

#calculate the length of the deletions
```
perl ~/bscratch/Bd21_3_mutant/natural_lines/scripts/count_del_length.pl rare_variants_indels_del.vcf >rare_variants_indels_del_len.txt

perl ~/bscratch/Bd21_3_mutant/natural_lines/scripts/count_del_length.pl common_variants_indels_del.vcf >common_variants_indels_del_len.txt


#Then plot the dle size distributions with local R scripts!!!!!!

#extract the annotation information 
```
 perl ~/bscratch/Bd21_3_mutant/natural_lines/scripts/extract_anno_vcf.pl rare_variants_SNPs.recode.vcf >rare_variants_SNPs_anno.txt


perl ~/bscratch/Bd21_3_mutant/natural_lines/scripts/extract_anno_vcf.pl common_variants_SNPs.recode.vcf >common_variants_SNPs_anno.txt

perl ~/bscratch/Bd21_3_mutant/natural_lines/scripts/extract_anno_vcf.pl rare_variants_indels_del.vcf >rare_variants_dels_anno.txt

perl ~/bscratch/Bd21_3_mutant/natural_lines/scripts/extract_anno_vcf.pl common_variants_indels_del.vcf >common_variants_dels_anno.txt

```

```
./count_mutation_type.pl ~/Projects/Brachy_mutant/filtered_calls/combined/Indel_FN_combined_plates_filtered_mutant_lines_1-18column_deloutlier_orgnell_p9_1_2_3_4_6_10_11_12_5_13_16_pt1_2_3_0_aa_dSNPmasked.csv >~/Projects/Brachy_mutant/filtered_calls/combined/Indel_FN_frac.csv



perl ~/bscratch/Bd21_3_mutant/natural_lines/scripts/count_mutation_types.pl rare_variants_SNPs_anno.txt >rare_variants_SNPs_anno_frac.txt

perl ~/bscratch/Bd21_3_mutant/natural_lines/scripts/count_mutation_types.pl common_variants_SNPs_anno.txt >common_variants_SNPs_anno_frac.txt

perl ~/bscratch/Bd21_3_mutant/natural_lines/scripts/count_mutation_types.pl rare_variants_dels_anno.txt >rare_variants_dels_anno_frac.txt

perl ~/bscratch/Bd21_3_mutant/natural_lines/scripts/count_mutation_types.pl common_variants_dels_anno.txt >common_variants_dels_anno_frac.txt
```

### 4 I need to check if the SNPs from the mutation populations  existing the natural lines!!!

```
sbatch --array=0 run_align_BAD_Mutation_natural_00.sub
Submitted batch job 45353304
(base) 
```

```
#soemthing wrong with BAD_mUTATIONS!!!

python /global/projectb/scratch/llei2019/software/BAD_Mutations/BAD_Mutations.py -v DEBUG align -c /global/projectb/scratch/llei2019/software/BAD_Mutations/BAD_Mutations_Config.txt -f /global/projectb/scratch/llei2019/Bd21_3_mutant/BAD_Mutations/fasta/BdiBd21-3_1G0006400.fasta -o /global/u2/l/llei2019/bscratch/Bd21_3_mutant/BAD_Mutations/align/out/MSA_00 2> /global/u2/l/llei2019/bscratch/Bd21_3_mutant/BAD_Mutations/align/log/natural_00/BdiBd21-3_1G0006400_Alignment.log

#Check which SNPs are not in the file!!!!

 LiLei@LiLei-M57:~/Projects/Brachy_mutant/filtered_calls/combined/Brachy_mutant/scripts$ ./match_mutation_natural_variation.pl ~/Projects/Brachy_mutant/filtered_calls/combined/Natural_lines/filtered_treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno_mafgt0.0044.recode.maf ~/Projects/Brachy_mutant/filtered_calls/combined/combined_plates_filtered_mutant_lines_1-18column_deloutlier_orgnell_p9_1_2_3_4_6_10_11_12_5_13_16_pt1_2_3_0_aa_dSNPmasked.csv >~/Projects/Brachy_mutant/filtered_calls/combined/combined_plates_filtered_mutant_lines_1-18column_deloutlier_orgnell_p9_1_2_3_4_6_10_11_12_5_13_16_pt1_2_3_0_aa_dSNPmasked_natural.csv

grep "Yes" combined_plates_filtered_mutant_lines_1-18column_deloutlier_orgnell_p9_1_2_3_4_6_10_11_12_5_13_16_pt1_2_3_0_aa_dSNPmasked_natural.csv|wc -l
   32924

32924/1945141=0.0169 
1945141-32924=1912217  
6376146-32924=6343222 


1945141 combined_plates_filtered_mutant_lines_1-18column_deloutlier_orgnell_p9_1_2_3_4_6_10_11_12_5_13_16_pt1_2_3_0_aa_dSNPmasked_natural.csv

grep "Yes" combined_plates_filtered_mutant_lines_1-18column_deloutlier_orgnell_p9_1_2_3_4_6_10_11_12_5_13_16_pt1_2_3_0_aa_dSNPmasked_natural.csv| grep "HIGH"|wc -l
      48

grep "Yes" combined_plates_filtered_mutant_lines_1-18column_deloutlier_orgnell_p9_1_2_3_4_6_10_11_12_5_13_16_pt1_2_3_0_aa_dSNPmasked_natural.csv|grep "Deleterious"|wc -l
     105

48+105=153 

153/65590=0.0023 

65590-153=65437 

153/32,924=0.0046 


llei2019@cori14 15:57:24 /global/u2/l/llei2019/plantbox/bscratch/llei2019/Bd21_3_mutant/natural_lines/data 
$ zgrep "#CHROM" genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno.vcf.gz|tr "\t" "\n" >samples
```