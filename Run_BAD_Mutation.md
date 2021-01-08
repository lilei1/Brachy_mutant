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

### 2. Split the whole genome primary cds fasta file into individual file with the fasta
