#!/bin/bash
#SBATCH --qos=genepool
#SBATCH --time=10:00:00
#SBATCH --nodes=1
#SBATCH --account=plant
#SBATCH --job-name=merge_bam
#SBATCH --output=merge_bam.out
#SBATCH --error=merge_bam.err

set -e
set -u
set -o pipefail

#   This script takes reheader murinum BAM parts 0-15 and merges them using samtools
#       and was intended to be submitted as a job on MSI

#   User provided arguments
BAM_LIST=/global/cscratch1/sd/llei2019/Bdist_mutant/ancerstral_infer/out/reheader_bam/stacei_reheader_bam_list_0.035.txt

OUT_DIR=/global/cscratch1/sd/llei2019/Bdist_mutant/ancerstral_infer/out/merged_bam
OUT_FILE=stacei_0.035.bam

#   Check if outdirectory exists
mkdir -p "${OUT_DIR}"
#   Merge bam files
samtools merge -b "${BAM_LIST}" "${OUT_DIR}"/"${OUT_FILE}"
