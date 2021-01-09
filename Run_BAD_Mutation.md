# Aim: This analysis is to predict which SNPs are deleterious with BAD_Mutations
Currently we just used file 
`/global/cscratch1/sd/llei2019/Bdist_mutant/purify_nonsyn.ANNOVARBd21_3_annovar.SNP_unified_all_varaints.table`

## The processes I did:

### 1. Extract all of the genes hit by all of the nonsyn. SNPs, 

```
# Count how many genes
cut -f 5  purify_nonsyn.ANNOVARBd21_3_annovar.SNP_unified_all_varaints.table|sort -u |wc -l
34,419

cut -f 5  purify_nonsyn.ANNOVARBd21_3_annovar.SNP_unified_all_varaints.table|sort -u >purify_nonsyn_gene.list
```

### 2. Split the whole genome primary cds fasta file into individual file with the [fasta_splitter](https://github.com/lilei1/Brachy_mutant/blob/master/scripts/fasta_splitter.pl)

```
 perl /global/projectb/scratch/llei2019/Bd21_3_mutant/scriptsfasta_splitter.pl /global/u2/l/llei2019/cscratch/Bd21_3/v1.1/annotation/BdistachyonBd21_3_460_v1.1.cds_primaryTranscriptOnly.fa
```
 All of the fasta files can be avaible here: `/global/projectb/scratch/llei2019/Bd21_3_mutant/BAD_Mutations/fasta`
 Then create a targeted fasta file list based on `purify_nonsyn_gene.list`, the file list can be seen `/global/projectb/scratch/llei2019/Bd21_3_mutant/BAD_Mutations/align/file_list/nonsyn_gene_fasta_file.list`
 
 
### 3. Set up the configure file

```
module load python/3.7-anaconda-2019.10
source activate bad_mutations

cd /global/projectb/scratch/llei2019/software/BAD_Mutations

python BAD_Mutations.py -v DEBUG \
                     setup \
                     -b /global/projectb/scratch/llei2019/Bd21_3_mutant/BAD_Mutations_invt_Data \
                     -d /global/projectb/scratch/llei2019/Bd21_3_mutant/BAD_Mutations_Deps \
                     -t 'Bdistachyon' \
                     -e 0.05 \
                     -c BAD_Mutations_Config.txt 2> Setup.log
```

### 4. Extract the files from database

```
python BAD_Mutations.py -v DEBUG fetch -c /global/projectb/scratch/llei2019/software/BAD_Mutations/BAD_Mutations_Config.txt -u 'lilei@lbl.gov' -p 'Shaomingqin99@' 2> /global/projectb/scratch/llei2019/Bd21_3_mutant/BAD_Mutations/Fetch.log
```

### 5. Align for each sequences

```
#TEST
python BAD_Mutations.py -v DEBUG align -c /global/projectb/scratch/llei2019/software/BAD_Mutations/BAD_Mutations_Config.txt -f /global/projectb/scratch/llei2019/Bd21_3_mutant/BAD_Mutations/test/BdiBd21_3.1G0016800.1.fasta -o . 2> BdiBd21_3.1G0016800.1.log

#job
Jacob will adapt the [run_align_BAD_Mutation.sub] (https://github.com/lilei1/Brachy_mutant/blob/master/jobs/run_align_BAD_Mutation.sub)
Virginia, Jacob, and I will submit job array for each batch.

```

### 6. Predict for each variants

```
#test
python BAD_Mutations.py predict \
>     -c /global/projectb/scratch/llei2019/software/BAD_Mutations/BAD_Mutations_Config.txt \
>     -f /global/projectb/scratch/llei2019/Bd21_3_mutant/BAD_Mutations/test/BdiBd21_3.1G0016800.1.fasta \
>     -a /global/projectb/scratch/llei2019/software/BAD_Mutations/BdiBd21_3.1G0016800.1_MSA.fasta \
>     -r /global/projectb/scratch/llei2019/software/BAD_Mutations/BdiBd21_3.1G0016800.1.tree \
>     -s /global/projectb/scratch/llei2019/software/BAD_Mutations/BdiBd21_3.1G0016800.1.sub \
>     -o /global/projectb/scratch/llei2019/Bd21_3_mutant/BAD_Mutations/test/
===2021-01-04 17:19:09,645 - LRT_Predict===
INFO    Input file /global/projectb/scratch/llei2019/software/BAD_Mutations/BdiBd21_3.1G0016800.1.sub contains 2 positions to predict.
===2021-01-04 17:19:09,699 - LRT_Prediction===
INFO    Input file /global/projectb/scratch/llei2019/software/BAD_Mutations/BdiBd21_3.1G0016800.1.sub contains 2 positions to predict.
===2021-01-04 18:37:09,048 - LRT_Predict===
INFO    Prediction in /global/projectb/scratch/llei2019/Bd21_3_mutant/BAD_Mutations/test/BdiBd21_3.1G0016800.1_Predictions.txt
(/global/cscratch1/sd/llei2019/conda_envs/bad_mutations)

#Job
```

### 7. Compile

```
#Test
 python BAD_Mutations.py -v DEBUG compile -P /global/projectb/scratch/llei2019/Bd21_3_mutant/BAD_Mutations/test/prediction -S /global/cscratch1/sd/llei2019/Bdist_mutant/purify_nonsyn.ANNOVARBd21_3_annovar.SNP_unified_all_varaints.table

#Notice: 
`/global/cscratch1/sd/llei2019/Bdist_mutant/purify_nonsyn.ANNOVARBd21_3_annovar.SNP_unified_all_varaints.table` is generated from the Annovar's output (See the begininng) 

```