#!/bin/bash
#   Written by Li Lei, 20160426, st.paul
#   Shell script to create the subs files
#   20170803, adapted from https://github.com/lilei1/BAD_mutation_Ath/blob/master/creat_subs_file.sh
# usage: ./creat_subs_file.sh file_gene file_aa_pos path
set -e
set -u
set -o pipefail
#filename=at.both.snp.tsv
file_gene="$1"
file_aa_pos="$2"
outdir="$3"

for geneid in $(cat "${file_gene}")
    do
	grep "${geneid}" "${file_aa_pos}" |sort -k 3,3n |cut -f 12|uniq|awk '{printf("%s\tSNP_%.0f\n", $0, 1*(NR-1))}' > "${outdir}"/"${geneid}".subs
    done
