# Tutorial for calculate the gene density, TE density, and variants density, recombination rate; and then make a circle plot!

### Step1 calculate the gene density on cori via conda enviroment

Here I used the script and conda enviroment Virginia wrote and installed for her thesis. all of those calculation were performed on nersc cori.

```
source activate /global/projectb/sandbox/plant/hybridum/software/bigtop
```
The input files are listed as below and the gff file were downloaded from Phytozome 13 and the Bd21-3.chrom.sizes file were done with the vcf header to pull out the length of the chromesome and scaffolds.

```
genome: Bd21_3
gfffile: /global/projectb/scratch/llei2019/Bd21_3_mutant/circos/gene_density/phytozome/BdistachyonBd21/v1.2/annotation/BdistachyonBd21_3_537_v1.2.gene_exons.gff3
chromsizesfile: /global/projectb/scratch/llei2019/Bd21_3_mutant/circos/gene_density/Bd21-3.chrom.sizes
windowSize: 250000
```
```
cd /global/projectb/scratch/llei2019/Bd21_3_mutant/circos/gene_density

source activate /global/projectb/sandbox/plant/hybridum/software/grrr

Rscript /global/projectb/scratch/llei2019/Bd21_3_mutant/Brachy_mutant/scripts/gene_density/getGeneDensity.R Bd21_3 /global/projectb/scratch/llei2019/Bd21_3_mutant/circos/gene_density/phytozome/BdistachyonBd21/v1.2/annotation/BdistachyonBd21_3_537_v1.2.gene_exons.gff3 /global/projectb/scratch/llei2019/Bd21_3_mutant/circos/gene_density/Bd21-3.chrom.sizes 250000

```

### Step2: Calculate the TE density

Here I used the script and conda enviroment Virginia wrote and installed for her thesis. all of those calculation were performed on nersc cori. She also annotated the TE from Bd21-3 with her pipeline!

#calculate the TE density!!!
This TE is created by Vriginia!!!

`/global/projectb/scratch/llei2019/Bd21_3_mutant/circos/TE_density/allfragments.classified`

```
cd /global/projectb/scratch/llei2019/Bd21_3_mutant/circos/TE_density
cp /global/projectb/scratch/vstartag/TEannotation/results_for_eugene/new/Bd21_3/allfragments.classified .

source activate /global/projectb/sandbox/plant/hybridum/software/grrr

Rscript /global/projectb/scratch/llei2019/Bd21_3_mutant/Brachy_mutant/scripts/TE_density/getTEdensity.R Bd21_3 /global/projectb/scratch/llei2019/Bd21_3_mutant/circos/TE_density/allfragments.classified /global/projectb/scratch/llei2019/Bd21_3_mutant/circos/gene_density/Bd21-3.chrom.sizes 250000

```

### Step3: Calculate the variants density

The variants position is get from the final variants file from google drive (https://drive.google.com/drive/u/1/folders/1iWty1gvd3sq7fjTbTKjc6EaZoWMMLBv5)
The file named as `combined_plates_filtered_mutant_lines_1-18column_deloutlier_orgnell_p9_1_2_3_4_6_10_11_12_5_13_16_pt1_2_3_0_aa_dSNPmasked_natural.csv`

- Creat the variants position file
```
(base) LiLei@LiLei-M57:~/Projects/Brachy_mutant/filtered_calls/combined$ 


cut -d "," -f 3,4 combined_plates_filtered_mutant_lines_1-18column_deloutlier_orgnell_p9_1_2_3_4_6_10_11_12_5_13_16_pt1_2_3_0_aa_dSNPmasked_natural.csv >all_variants

sort -k1,1 -k2,2n all_variants|uniq >sorted_uniq_all_variants
wc -l sorted_uniq_all_variants
1884779 sorted_uniq_all_variants

```

- Adapted the file into the correct format

```
#add the id column in the beginning column
awk -F'\t' '{$1=++i FS $1;}1' OFS='\t' sorted_uniq_all_variants >added_start_sorted_uniq_all_variants

#add another column to create something like  bed file
awk '{ print $0, (NR > 1) ? $3-1 : "Start" }' added_start_sorted_uniq_all_variants>pos_added_start_sorted_uniq_all_variants

# adjust the format as bed file but also add the strand orientation with "+"

perl -ane 'print "$F[0] \t$F[1]\t$F[3]\t$F[2]\t\+\n"' < pos_added_start_sorted_uniq_all_variants

```

