Objective: This is for running the BAD_Mutation for natural accessions

### steps:
#### 1. Format the file as a table for annovar like!!!

The vcf file including all of the information can be see here:
`/global/projectb/scratch/llei2019/Bd21_3_mutant/natural_lines/data/onlySNP_filtered_treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno_mafgt0.0044.recode.vcf`

```
perl ~/bscratch/Bd21_3_mutant/natural_lines/scripts/extract_anno_vcf.pl onlySNP_filtered_treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno_mafgt0.0044.recode.vcf >onlySNP_filtered_treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno_mafgt0.0044_anno.txt
```

#### 2. Format the file as annovar table!!!

```
perl ~/bscratch/Bd21_3_mutant/natural_lines/scripts/format_annovar_table.pl onlySNP_filtered_treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno_mafgt0.0044_anno.txt >all_nonsyn_anno.table

#259,242 nonsyn SNPs!!!

wc -l nonsyn_natural__annovar.gene.list
28,057 gene with at least one nonsyn!!
(base) 
/global/projectb/scratch/llei2019/Bd21_3_mutant/natural_lines/data/all_nonsyn_anno.table

```

#### 3. creat the sub file!!!

```
 bash /global/u2/l/llei2019/bscratch/Bd21_3_mutant/BAD_Mutations/scripts/creat_subs_file.sh /global/projectb/scratch/llei2019/Bd21_3_mutant/natural_lines/data/nonsyn_natural_annovar.gene.list /global/projectb/scratch/llei2019/Bd21_3_mutant/natural_lines/data/all_nonsyn_anno.table /global/u2/l/llei2019/bscratch/Bd21_3_mutant/BAD_Mutations/natural_sub

ls /global/u2/l/llei2019/bscratch/Bd21_3_mutant/BAD_Mutations/fasta|wc -l
36649
(base) 
```

#MSA file:!!!
`/global/u2/l/llei2019/bscratch/Bd21_3_mutant/BAD_Mutations/MSA`

```
$ ls |wc -l
34263
(base) 
find $PWD -type f -name "*.fasta" >/global/u2/l/llei2019/bscratch/Bd21_3_mutant/BAD_Mutations/finished_MSA.list

#Tree file!!!
find $PWD -type f -name "*.tree" >/global/u2/l/llei2019/bscratch/Bd21_3_mutant/BAD_Mutations/finished_tree.list
```

#Then write a script to find the missed genes with MSA and tree!!!

```
llei2019@cori13 15:27:29 ~/bscratch/Bd21_3_mutant/natural_lines/data 
$ perl ~/bscratch/Bd21_3_mutant/natural_lines/scripts/find_genes_noMSA_tree.pl /global/u2/l/llei2019/bscratch/Bd21_3_mutant/BAD_Mutations/finished_MSA.list nonsyn_natural_annovar.gene.list >no_MSA_tree_genes
#1135 genes


sbatch --array=0 run_align_BAD_Mutation_natural_00.sub

#I create a file and put all of the fasta file together!!!



global/u2/l/llei2019/bscratch/Bd21_3_mutant/BAD_Mutations/subs 
$ ls |wc -l
34420
(base) 


Tree file:
MSA file:
sub file:
fasta file:

/global/u2/l/llei2019/bscratch/Bd21_3_mutant/BAD_Mutations/prediction/tree_file_list/add_tree_file_list_2231


###
llei2019@cori13 18:52:02 /global/u2/l/llei2019/bscratch/Bd21_3_mutant/BAD_Mutations/prediction/jobs 
$ sbatch --array=0-999 add_prediction.01.job
Submitted batch job 43613789
(base) 
llei2019@cori13 18:52:10 /global/u2/l/llei2019/bscratch/Bd21_3_mutant/BAD_Mutations/prediction/jobs 
$ sbatch --array=0-999 add_prediction.02.job
Submitted batch job 43613794
(base) 
llei2019@cori13 18:52:15 /global/u2/l/llei2019/bscratch/Bd21_3_mutant/BAD_Mutations/prediction/jobs 
$  sbatch --array=0-230 add_prediction.03.job
Submitted batch job 43613798
(base) 
```

