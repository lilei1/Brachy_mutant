#!/bin/bash

# Shared functions for preparing counts tables
# Define functions
function vcf_to_bed() {
    local vcf="$1"
    local out_dir="$2"
    local ref_fai="$3"
    local win_flank_size="$4"
    # Convert VCF to BED format using vcflib's vcf2bed.py
    if [[ "${vcf}" == *"gz"* ]]; then
        # We are working with gzipped VCF file
        out_prefix=$(basename ${vcf} .vcf.gz)
        zcat ${vcf} | vcf2bed.py > ${out_dir}/${out_prefix}.bed
    else
        # We are working with uncompressed vcf
        out_prefix=$(basename ${vcf} .vcf)
        cat ${vcf} | vcf2bed.py > ${out_dir}/${out_prefix}.bed
    fi
    # Add flanking interval in each direction
    bedtools slop -i ${out_dir}/${out_prefix}.bed -g ${ref_fai} -b ${win_flank_size} > ${out_dir}/${out_prefix}.winFlank${win_flank_size}bp.bed
}

export -f vcf_to_bed

function bed_to_fasta() {
    local bed_file="$1"
    local ref_fasta="$2"
    local out_dir="$3"
    # Prepare output file prefix
    out_prefix=$(basename ${bed_file} .bed)
    # Extract sequences from fasta as defined in BED
    bedtools getfasta -fi ${ref_fasta} -bed ${bed_file} -fo ${out_dir}/${out_prefix}.fasta
}

export -f bed_to_fasta

function run_aln_to_counts() {
    local fasta_file="$1"
    local out_dir="$2"
    local flank_size="$3"
    local out_prefix="$4"
    local win_flank_size="$5"
    # Prepare direction
    curr_direction=$(basename ${fasta_file} _${out_prefix}.winFlank${win_flank_size}bp.fasta)
    # Prepare counts table format required by mutation motif
    aln_to_counts --align_path "${fasta_file}" \
        --output_path "${out_dir}" \
        --flank_size "${flank_size}" \
        --direction "${curr_direction}" \
        --force_overwrite
}

export -f run_aln_to_counts
