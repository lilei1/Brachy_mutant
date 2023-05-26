#!/bin/bash

for i in $(cat /global/projectb/scratch/llei2019/Bd21_3_mutant/natural_lines/data/sample_list)
do	echo -e "$i\t$(awk -v pat="$i" -F '\t' '{if ($8 ~ pat) print}' /global/projectb/scratch/llei2019/Bd21_3_mutant/natural_lines/data/onlySNP_filtered_treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno_mafgt0.0044.recode.count|wc -l)\t $(awk -v pat="$i" -F '\t' '{if ($9 ~ pat) print}' /global/projectb/scratch/llei2019/Bd21_3_mutant/natural_lines/data/onlySNP_filtered_treatmissing_biallilic_filtered_passs_genotype_gvcfs.f1.bf=g10-G3-Q40-QD5.anno_mafgt0.0044.recode.count|wc -l)"
done