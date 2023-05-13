#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mem=8gb
#SBATCH --tmp=6gb
#SBATCH -t 5:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=llei@umn.edu
#SBATCH -p small,ram256g,ram1t
#SBATCH -o %j.out
#SBATCH -e %j.err

set -e
set -o pipefail

# Dependencies
module load bcftools
module load parallel/20210822
module load python3/3.8.3_anaconda2020.07_mamba
module load bedtools/2.29.2
# Conda environment for mutation motif software and bedops has also installed there
source activate /panfs/jay/groups/9/morrellp/llei/.conda/envs/mut_motif/
# Load shared functions
source /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/scripts/prep_counts_functions.sh

# User provided input arguments
VCF="/home/morrellp/llei/context_test/Brachy/mutant/FN_filter_plate.0_24.gatk.hf.sc_mafgt0.01.recode.vcf.gz"
# Reference fasta file
REF_FASTA="/home/morrellp/llei/context_test/Brachy/mutant/only_Bd_BdistachyonBd21_3_460_v1.0.fa"
REF_FAI="/home/morrellp/llei/context_test/Brachy/mutant/only_Bd_BdistachyonBd21_3_460_v1.0.fa.fai"
# Size around SNV to expand window in bp (min, 1)
#   Note: Integer will be added in each direction
#   Tip: If you run aln_to_counts and get the error: "ValueError: not all sequences have same length"
#       keep reducing the WIN_FLANK_SIZE until that error goes away
WIN_FLANK_SIZE="15"
# The number of bases per side to include. The default is 100, but I schrink the window size until 15 works
FLANK_SIZE="2"
# Where should we output our files?
OUT_DIR="/panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/FN_mutant"
# Temporary directory for intermediate files
TEMP_DIR="/scratch.global/llei/temp_mutation_motif"

#----------------------
# Create output directories and subdirectories
mkdir -p ${OUT_DIR} ${OUT_DIR}/counts_tables
mkdir -p ${TEMP_DIR} ${TEMP_DIR}/split_vcf ${TEMP_DIR}/split_bed ${TEMP_DIR}/split_fasta

# Prepare output prefix of VCF file
if [[ "${VCF}" == *"gz"* ]]; then
    # We are working with gzipped VCF file
    out_prefix=$(basename ${VCF} .vcf.gz)
else
    # We are working with uncompressed vcf
    out_prefix=$(basename ${VCF} .vcf)
fi

# Split VCF file based on mutation motif categories for the aln_to_counts option:
#   --direction [AtoC|AtoG|AtoT|CtoA|CtoG|CtoT|GtoA|GtoC|GtoT|TtoA|TtoC|TtoG]
bcftools view -i 'REF="A" & ALT="C"' ${VCF} -O v -o ${TEMP_DIR}/split_vcf/AtoC_${out_prefix}.vcf
bcftools view -i 'REF="A" & ALT="G"' ${VCF} -O v -o ${TEMP_DIR}/split_vcf/AtoG_${out_prefix}.vcf
bcftools view -i 'REF="A" & ALT="T"' ${VCF} -O v -o ${TEMP_DIR}/split_vcf/AtoT_${out_prefix}.vcf
bcftools view -i 'REF="C" & ALT="A"' ${VCF} -O v -o ${TEMP_DIR}/split_vcf/CtoA_${out_prefix}.vcf
bcftools view -i 'REF="C" & ALT="G"' ${VCF} -O v -o ${TEMP_DIR}/split_vcf/CtoG_${out_prefix}.vcf
bcftools view -i 'REF="C" & ALT="T"' ${VCF} -O v -o ${TEMP_DIR}/split_vcf/CtoT_${out_prefix}.vcf
bcftools view -i 'REF="G" & ALT="A"' ${VCF} -O v -o ${TEMP_DIR}/split_vcf/GtoA_${out_prefix}.vcf
bcftools view -i 'REF="G" & ALT="C"' ${VCF} -O v -o ${TEMP_DIR}/split_vcf/GtoC_${out_prefix}.vcf
bcftools view -i 'REF="G" & ALT="T"' ${VCF} -O v -o ${TEMP_DIR}/split_vcf/GtoT_${out_prefix}.vcf
bcftools view -i 'REF="T" & ALT="A"' ${VCF} -O v -o ${TEMP_DIR}/split_vcf/TtoA_${out_prefix}.vcf
bcftools view -i 'REF="T" & ALT="C"' ${VCF} -O v -o ${TEMP_DIR}/split_vcf/TtoC_${out_prefix}.vcf
bcftools view -i 'REF="T" & ALT="G"' ${VCF} -O v -o ${TEMP_DIR}/split_vcf/TtoG_${out_prefix}.vcf

# Prepare array of split VCF files
SPLIT_VCF_ARR=($(realpath ${TEMP_DIR}/split_vcf/*${out_prefix}*))

# Convert split vcf files to BED format and extend interval by WIN_FLANK_SIZE in each direction
parallel --verbose vcf_to_bed {} ${TEMP_DIR}/split_bed ${REF_FAI} ${WIN_FLANK_SIZE} ::: ${SPLIT_VCF_ARR[@]}
# Prepare array of extended interval BED files
SPLIT_BED_ARR=($(realpath ${TEMP_DIR}/split_bed/*.winFlank${WIN_FLANK_SIZE}bp.bed))

# Extract sequences from fasta as defined in BED
parallel --verbose bed_to_fasta {} ${REF_FASTA} ${TEMP_DIR}/split_fasta ::: ${SPLIT_BED_ARR[@]}
# Prepare array of FASTA files
SPLIT_FASTA_ARR=($(realpath ${TEMP_DIR}/split_fasta/*.winFlank${WIN_FLANK_SIZE}bp.fasta))

# Prepare counts table format
parallel --verbose run_aln_to_counts {} ${OUT_DIR}/counts_tables ${FLANK_SIZE} ${out_prefix} ${WIN_FLANK_SIZE} ::: ${SPLIT_FASTA_ARR[@]}

# Combine separate counts table into single file that is suitable for spectra analysis
all_counts \
    --counts_pattern "${OUT_DIR}/counts_tables/*to*${out_prefix}.winFlank${WIN_FLANK_SIZE}bp.txt*" \
    --output_path ${OUT_DIR}/counts_tables \
    --strand_symmetric \
    --force_overwrite
# Rename combined counts output file
mv ${OUT_DIR}/counts_tables/combined_counts.txt ${OUT_DIR}/counts_tables/combined_counts_${out_prefix}.winFlank${WIN_FLANK_SIZE}bp.txt
mv ${OUT_DIR}/counts_tables/combined_counts.log ${OUT_DIR}/counts_tables/combined_counts_${out_prefix}.winFlank${WIN_FLANK_SIZE}bp.log
