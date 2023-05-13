#!/bin/bash

# Functions used across multiple scripts
# Define functions
function simple_analysis() {
    local counts_file="$1"
    local out_dir="$2"
    local counts_bn="$3"
    local plot_file_bn="$4"
    # Prepare output prefix (should be something like AtoT, etc.)
    out_prefix=$(basename ${counts_file} _${counts_bn}.txt)
    # Make output subdirectory
    mkdir -p ${out_dir}/${out_prefix}
    mutation_analysis nbr -1 ${counts_file} -o ${out_dir}/${out_prefix}
    # Rename output files so they are more meaningful and easier to collate later
    # Default output names are: 1.pdf, 2.pdf, 3.pdf, etc.
    cd ${out_dir}/${out_prefix}
    rename -v ".pdf" "_${out_prefix}_${plot_file_bn}.pdf" *.pdf
    rename -v ".json" "_${out_prefix}_${plot_file_bn}.json" *.json
    rename -v ".txt" "_${out_prefix}_${plot_file_bn}.txt" *.txt
}

export -f simple_analysis

function test_strand_symmetry() {
    local curr_direction="$1"
    local counts_file="$2"
    local out_dir="$3"
    local counts_bn="$4"
    local plot_file_bn="$5"
    # Pull current mutation direction and put in separate file
    head -n 1 ${counts_file} > ${out_dir}/strand_symmetry_counts/${curr_direction}_${counts_bn}.txt
    grep -w "${curr_direction}" ${counts_file} >> ${out_dir}/strand_symmetry_counts/${curr_direction}_${counts_bn}.txt
    # Test for strand symmetry (asymmetry) only if file has content
    if [[ $(wc -l <${out_dir}/strand_symmetry_counts/${curr_direction}_${counts_bn}.txt) -ge 2 ]]; then
        # Make output subdirectory
        mkdir -p ${out_dir}/${curr_direction}
        # Run analysis
        mutation_analysis nbr -1 ${out_dir}/strand_symmetry_counts/${curr_direction}_${counts_bn}.txt -o ${out_dir}/${curr_direction} --strand_symmetry
        # Rename output files so they are more meaningful and easier to collate later
        # Default output names are: 1.pdf, 2.pdf, 3.pdf, etc.
        cd ${out_dir}/${curr_direction}
        rename -v ".pdf" "_${curr_direction}_${plot_file_bn}.pdf" *.pdf
        rename -v ".json" "_${curr_direction}_${plot_file_bn}.json" *.json
        rename -v ".txt" "_${curr_direction}_${plot_file_bn}.txt" *.txt
    fi
}

export -f test_strand_symmetry

function full_spectra_analysis() {
    local combined_counts_file="$1"
    local out_dir="$2"
    local plot_file_bn="$3"
    mutation_analysis spectra -1 ${combined_counts_file} -o ${out_dir} --strand_symmetry
    # Rename output files so they are more meaningful and easier to collate later
    cd ${out_dir}
    rename -v ".pdf" "_${plot_file_bn}.pdf" *.pdf
    rename -v ".json" "_${plot_file_bn}.json" *.json
    rename -v ".txt" "_${plot_file_bn}.txt" *.txt
}

export -f full_spectra_analysis
