#!/bin/bash

for i in $(cat /global/projectb/scratch/llei2019/Bd21_3_mutant/natural_lines/data/sample_list)
do	echo -e "$i\t$(awk -v pat="$i" -F '\t' '{if ($8 ~ pat) print}' /global/projectb/scratch/llei2019/Bd21_3_mutant/natural_lines/data/all_dSNPs_masked.count|wc -l)\t $(awk -v pat="$i" -F '\t' '{if ($9 ~ pat) print}' /global/projectb/scratch/llei2019/Bd21_3_mutant/natural_lines/data/all_dSNPs_masked.count|wc -l)"
done