Objective: This is for look for the context motif surrounding the induced mutations or natural variations.

Note: this one is running in the MSI and collaborate with Peter Morrell in UMN.

## NaN samples:

### - Install the mutation motif

```
conda env remove -n mut_motif
module load python/3.8.3_anaconda2020.07_mamba
conda create -n mut_motif -c plotly python=3.8 plotly plotly-orca rpy2 
conda install -n mut_motif scipy scikit-learn
conda install -n mut_motif attrs=18.2

conda activate mut_motif
python -m pip install git+https://github.com/HuttleyLab/MutationMotif.git@develop#egg=mutation_motif

```

Then I got errors:
```
ERROR: pip's dependency resolver does not currently take into account all the packages that are installed. This behaviour is the source of the following dependency conflicts.
ldpop 1.0.0 requires future, which is not installed.
pyrho 0.1.6 requires pytest>=3.0.7, which is not installed.
pyrho 0.1.6 requires tables>=3.3.0, which is not installed.
tskit 0.4.1 requires jsonschema>=3.0.0, which is not installed.

```

#### - So I have to install other stuff

```
pip install future
pip install pytest-3.0.7
pip install pytest
pip install tables
pip install jsonschema
python -m pip install git+https://github.com/HuttleyLab/MutationMotif.git@develop#egg=mutation_motif

#There is a bug, I reported to the author and they fixed the bugs! I unstall the program and reinstalled 

python -m pip uninstall mutation_motif

python -m pip install git+https://github.com/HuttleyLab/MutationMotif.git@develop#egg=mutation_motif

#then I log out and re login
```
#### - Intsall vcftools:
```
git pull https://github.com/vcftools/vcftools.git
cd vcftools-vcftools-2543f81/
./configure --prefix=/panfs/jay/groups/9/morrellp/llei/software/vcftools-vcftools-2543f81
make
make install
#only keep biallilic SNPs, PASS, and only chromosomes (no scaffords)
#some error happened, I need to filter out all of the SNPs in the scaffold and so does the genome file
```

```
module load bcftools 
sbatch --mem=80gb --nodes=1 --mail-user=llei@umn.edu -p ram256g,ram1t -t 12:00:00 --wrap="bcftools view -f PASS -m2 -M2 -v snps -R /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/chr_only.bed /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/plate.0_24.gatk.hf.sc.vcf.gz -Oz -o /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/filter_plate.0_24.gatk.hf.sc.vcf.gz"
sbatch: Setting account: morrellp
Submitted batch job 153191623
bcftools index filter_plate.0_24.gatk.hf.sc.vcf.gz
```

#### - Then only extract the NaN
```
sbatch --mem=80gb --nodes=1 --mail-user=llei@umn.edu -p ram256g,ram1t -t 8:00:00 --wrap="vcftools --gzvcf /home/morrellp/llei/context_test/Brachy/mutant/filter_plate.0_24.gatk.hf.sc.vcf.gz --keep NaN_acc.txt --recode --recode-INFO-all --out NaN_filter_plate.0_24.gatk.hf.sc"
```

```
module load python3/3.8.3_anaconda2020.07_mamba
conda create prefix=/panfs/jay/groups/9/morrellp/llei/conda_envconda 
conda activate
install -c bioconda seqkit
seqkit grep -n -f chr_id.txt BdistachyonBd21_3_460_v1.0.fa >only_Bd_BdistachyonBd21_3_460_v1.0.fa
```

#### - compress the filtered vcf file:
```
sbatch --mem=80gb --nodes=1 --mail-user=llei@umn.edu -p ram256g,ram1t -t 5:00:00 --wrap="bcftools view /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/NaN_filter_plate.0_24.gatk.hf.sc.recode.vcf -Oz -o /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/NaN_filter_plate.0_24.gatk.hf.sc.recode.vcf.gz"
sbatch: Setting account: morrellp
Submitted batch job 153194513
```
#### - index the vcf.gz
```
bcftools index NaN_filter_plate.0_24.gatk.hf.sc.recode.vcf.gz
```

#### - test

```
#test for simple analysis:

/home/morrellp/llei/.conda/envs/mut_motif/bin/mutation_analysis nbr -1 /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt -o NaN.winFlank15bp/simple_analysis

#test for strand symmetry

/home/morrellp/llei/.conda/envs/mut_motif/bin/mutation_analysis nbr -1 /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt -o NaN.winFlank15bp/strand_symmetry_analysis --strand_symmetry

```

#### - formal run with [prep_counts_table-mut_snps.sh]()

```
sbatch prep_counts_table-mut_snps.sh
```

#### - formal run with [context_analysis-mut_snps.sh]() 

```
./context_analysis-mut_snps.sh 
```

#### then it print out something like this:

```
Academic tradition requires you to cite works you base your article on.
If you use programs that use GNU Parallel to process data for an article in a
scientific publication, please cite:

  Tange, O. (2021, August 22). GNU Parallel 20210822 ('Kabul').
  Zenodo. https://doi.org/10.5281/zenodo.5233953

This helps funding further development; AND IT WON'T COST YOU A CENT.
If you pay 10000 EUR you should feel free to use GNU Parallel without citing.

More about funding GNU Parallel and the citation notice:
https://www.gnu.org/software/parallel/parallel_design.html#Citation-notice

To silence this citation notice: run 'parallel --citation' once.

Come on: You have run parallel 34 times. Isn't it about time 
you run 'parallel --citation' once to silence the citation notice?

simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis NaN.winFlank15bp NaN.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis NaN.winFlank15bp NaN.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis NaN.winFlank15bp NaN.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis NaN.winFlank15bp NaN.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis NaN.winFlank15bp NaN.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis NaN.winFlank15bp NaN.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis NaN.winFlank15bp NaN.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis NaN.winFlank15bp NaN.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis NaN.winFlank15bp NaN.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis NaN.winFlank15bp NaN.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis NaN.winFlank15bp NaN.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis NaN.winFlank15bp NaN.SNPs
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis/AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt for your results
`1_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `1_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`1.pdf' -> `1_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `2_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2.pdf' -> `2_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `3_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3.pdf' -> `3_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `4_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4.pdf' -> `4_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `summary_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary.pdf' -> `summary_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`1_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `1_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`1_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `1_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`1.json' -> `1_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`2_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `2_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`2.json' -> `2_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`3_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `3_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`3.json' -> `3_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`4_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `4_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`4.json' -> `4_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`summary_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt' -> `summary_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt_NaN.SNPs.txt'
`summary.txt' -> `summary_AtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis/AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt for your results
`1_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `1_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`1.pdf' -> `1_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `2_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2.pdf' -> `2_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `3_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3.pdf' -> `3_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `4_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4.pdf' -> `4_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `summary_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary.pdf' -> `summary_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`1_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `1_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`1.json' -> `1_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`2_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `2_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`2.json' -> `2_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`3_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `3_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`3.json' -> `3_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`4_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `4_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`4.json' -> `4_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`summary_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt' -> `summary_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt_NaN.SNPs.txt'
`summary.txt' -> `summary_AtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis/CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt for your results
`1_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `1_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`1.pdf' -> `1_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `2_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2.pdf' -> `2_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `3_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3.pdf' -> `3_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `4_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4.pdf' -> `4_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `summary_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary.pdf' -> `summary_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`1_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `1_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`1.json' -> `1_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`2_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `2_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`2.json' -> `2_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`3_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `3_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`3.json' -> `3_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`4_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `4_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`4.json' -> `4_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`summary_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt' -> `summary_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt_NaN.SNPs.txt'
`summary.txt' -> `summary_CtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis/TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`1_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `1_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2.pdf' -> `2_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `2_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3.pdf' -> `3_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `3_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4.pdf' -> `4_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `4_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary.pdf' -> `summary_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `summary_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`1.json' -> `1_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`1_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `1_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`2.json' -> `2_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`2_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `2_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`3.json' -> `3_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`3_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `3_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`4.json' -> `4_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`4_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `4_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`summary_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt' -> `summary_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt_NaN.SNPs.txt'
`summary.txt' -> `summary_TtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis/GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt for your results
`1_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `1_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`1.pdf' -> `1_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `2_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2.pdf' -> `2_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `3_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3.pdf' -> `3_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `4_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4.pdf' -> `4_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `summary_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary.pdf' -> `summary_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`1_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `1_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`1.json' -> `1_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`2_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `2_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`2.json' -> `2_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`3_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `3_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`3.json' -> `3_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`4_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `4_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`4.json' -> `4_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`summary_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt' -> `summary_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt_NaN.SNPs.txt'
`summary.txt' -> `summary_GtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis/GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt for your results
`1_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `1_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`1.pdf' -> `1_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `2_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2.pdf' -> `2_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `3_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3.pdf' -> `3_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `4_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4.pdf' -> `4_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `summary_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary.pdf' -> `summary_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`1_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `1_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`1.json' -> `1_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`2_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `2_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`2.json' -> `2_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`3_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `3_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`3.json' -> `3_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`4_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `4_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`4.json' -> `4_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`summary_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt' -> `summary_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt_NaN.SNPs.txt'
`summary.txt' -> `summary_GtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis/CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt for your results
`1_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `1_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`1.pdf' -> `1_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `2_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2.pdf' -> `2_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `3_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3.pdf' -> `3_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `4_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `4_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4.pdf' -> `4_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `summary_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `summary_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary.pdf' -> `summary_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`1_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `1_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`1.json' -> `1_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`2_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `2_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`2.json' -> `2_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`3_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `3_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`3.json' -> `3_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`4_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `4_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`4.json' -> `4_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`summary_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt_NaN.SNPs.txt' -> `summary_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt_NaN.SNPs.txt_NaN.SNPs.txt'
`summary_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt' -> `summary_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt_NaN.SNPs.txt'
`summary.txt' -> `summary_CtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis/CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt for your results
`1_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `1_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`1.pdf' -> `1_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `2_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2.pdf' -> `2_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `3_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3.pdf' -> `3_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `4_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4.pdf' -> `4_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `summary_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary.pdf' -> `summary_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`1_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `1_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`1.json' -> `1_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`2_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `2_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`2.json' -> `2_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`3_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `3_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`3.json' -> `3_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`4_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `4_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`4.json' -> `4_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`summary_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt' -> `summary_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt_NaN.SNPs.txt'
`summary.txt' -> `summary_CtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis/AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt for your results
`1_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `1_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`1.pdf' -> `1_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `2_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2.pdf' -> `2_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `3_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3.pdf' -> `3_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `4_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4.pdf' -> `4_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `summary_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary.pdf' -> `summary_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt' -> `summary_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt_NaN.SNPs.txt'
`summary.txt' -> `summary_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt'
rename: 1_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json: rename to 1_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_AtoT_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json failed: File name too long
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis/GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt for your results
`1_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `1_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`1.pdf' -> `1_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `2_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2.pdf' -> `2_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `3_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3.pdf' -> `3_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `4_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4.pdf' -> `4_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `summary_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary.pdf' -> `summary_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`1_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `1_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`1.json' -> `1_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`2_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `2_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`2.json' -> `2_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`3_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `3_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`3.json' -> `3_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`4_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `4_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`4.json' -> `4_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`summary_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt' -> `summary_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt_NaN.SNPs.txt'
`summary.txt' -> `summary_GtoA_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis/TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`1_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `1_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2.pdf' -> `2_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `2_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3.pdf' -> `3_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `3_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4.pdf' -> `4_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `4_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary.pdf' -> `summary_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `summary_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`1.json' -> `1_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`1_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `1_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`2.json' -> `2_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`2_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `2_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`3.json' -> `3_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`3_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `3_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`4.json' -> `4_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`4_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `4_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`summary_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt' -> `summary_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt_NaN.SNPs.txt'
`summary.txt' -> `summary_TtoC_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/simple_analysis/TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`1_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `1_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2.pdf' -> `2_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`2_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `2_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3.pdf' -> `3_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`3_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `3_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4.pdf' -> `4_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`4_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `4_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary.pdf' -> `summary_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`summary_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf' -> `summary_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.pdf'
`1.json' -> `1_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`1_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `1_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`2.json' -> `2_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`2_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `2_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`3.json' -> `3_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`3_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `3_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`4.json' -> `4_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`4_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json' -> `4_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.json'
`summary_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt' -> `summary_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt_NaN.SNPs.txt'
`summary.txt' -> `summary_TtoG_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt_NaN.SNPs.txt'
Academic tradition requires you to cite works you base your article on.
If you use programs that use GNU Parallel to process data for an article in a
scientific publication, please cite:

  Tange, O. (2021, August 22). GNU Parallel 20210822 ('Kabul').
  Zenodo. https://doi.org/10.5281/zenodo.5233953

This helps funding further development; AND IT WON'T COST YOU A CENT.
If you pay 10000 EUR you should feel free to use GNU Parallel without citing.

More about funding GNU Parallel and the citation notice:
https://www.gnu.org/software/parallel/parallel_design.html#Citation-notice

To silence this citation notice: run 'parallel --citation' once.

Come on: You have run parallel 35 times. Isn't it about time 
you run 'parallel --citation' once to silence the citation notice?

test_strand_symmetry AtoC /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/combined_counts_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/strand_symmetry_analysis NaN.winFlank15bp NaN.SNPs
test_strand_symmetry AtoG /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/combined_counts_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/strand_symmetry_analysis NaN.winFlank15bp NaN.SNPs
test_strand_symmetry AtoT /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/combined_counts_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/strand_symmetry_analysis NaN.winFlank15bp NaN.SNPs
test_strand_symmetry CtoA /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/combined_counts_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/strand_symmetry_analysis NaN.winFlank15bp NaN.SNPs
test_strand_symmetry CtoG /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/combined_counts_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/strand_symmetry_analysis NaN.winFlank15bp NaN.SNPs
test_strand_symmetry CtoT /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/combined_counts_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/strand_symmetry_analysis NaN.winFlank15bp NaN.SNPs
test_strand_symmetry GtoA /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/combined_counts_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/strand_symmetry_analysis NaN.winFlank15bp NaN.SNPs
test_strand_symmetry GtoC /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/combined_counts_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/strand_symmetry_analysis NaN.winFlank15bp NaN.SNPs
test_strand_symmetry GtoT /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/combined_counts_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/strand_symmetry_analysis NaN.winFlank15bp NaN.SNPs
test_strand_symmetry TtoA /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/combined_counts_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/strand_symmetry_analysis NaN.winFlank15bp NaN.SNPs
test_strand_symmetry TtoC /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/combined_counts_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/strand_symmetry_analysis NaN.winFlank15bp NaN.SNPs
test_strand_symmetry TtoG /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/counts_tables/combined_counts_NaN_filter_plate.0_24.gatk.hf.sc.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/strand_symmetry_analysis NaN.winFlank15bp NaN.SNPs
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/strand_symmetry_analysis/CtoG for your results
`1.pdf' -> `1_CtoG_NaN.SNPs.pdf'
`2.pdf' -> `2_CtoG_NaN.SNPs.pdf'
`3.pdf' -> `3_CtoG_NaN.SNPs.pdf'
`4.pdf' -> `4_CtoG_NaN.SNPs.pdf'
`summary.pdf' -> `summary_CtoG_NaN.SNPs.pdf'
`1.json' -> `1_CtoG_NaN.SNPs.json'
`2.json' -> `2_CtoG_NaN.SNPs.json'
`3.json' -> `3_CtoG_NaN.SNPs.json'
`4.json' -> `4_CtoG_NaN.SNPs.json'
`summary.txt' -> `summary_CtoG_NaN.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/strand_symmetry_analysis/AtoC for your results
`1.pdf' -> `1_AtoC_NaN.SNPs.pdf'
`2.pdf' -> `2_AtoC_NaN.SNPs.pdf'
`3.pdf' -> `3_AtoC_NaN.SNPs.pdf'
`4.pdf' -> `4_AtoC_NaN.SNPs.pdf'
`summary.pdf' -> `summary_AtoC_NaN.SNPs.pdf'
`1.json' -> `1_AtoC_NaN.SNPs.json'
`2.json' -> `2_AtoC_NaN.SNPs.json'
`3.json' -> `3_AtoC_NaN.SNPs.json'
`4.json' -> `4_AtoC_NaN.SNPs.json'
`summary.txt' -> `summary_AtoC_NaN.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/strand_symmetry_analysis/CtoT for your results
`1.pdf' -> `1_CtoT_NaN.SNPs.pdf'
`2.pdf' -> `2_CtoT_NaN.SNPs.pdf'
`3.pdf' -> `3_CtoT_NaN.SNPs.pdf'
`4.pdf' -> `4_CtoT_NaN.SNPs.pdf'
`summary.pdf' -> `summary_CtoT_NaN.SNPs.pdf'
`1.json' -> `1_CtoT_NaN.SNPs.json'
`2.json' -> `2_CtoT_NaN.SNPs.json'
`3.json' -> `3_CtoT_NaN.SNPs.json'
`4.json' -> `4_CtoT_NaN.SNPs.json'
`summary.txt' -> `summary_CtoT_NaN.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/strand_symmetry_analysis/AtoT for your results
`1.pdf' -> `1_AtoT_NaN.SNPs.pdf'
`2.pdf' -> `2_AtoT_NaN.SNPs.pdf'
`3.pdf' -> `3_AtoT_NaN.SNPs.pdf'
`4.pdf' -> `4_AtoT_NaN.SNPs.pdf'
`summary.pdf' -> `summary_AtoT_NaN.SNPs.pdf'
`1.json' -> `1_AtoT_NaN.SNPs.json'
`2.json' -> `2_AtoT_NaN.SNPs.json'
`3.json' -> `3_AtoT_NaN.SNPs.json'
`4.json' -> `4_AtoT_NaN.SNPs.json'
`summary.txt' -> `summary_AtoT_NaN.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/strand_symmetry_analysis/AtoG for your results
`1.pdf' -> `1_AtoG_NaN.SNPs.pdf'
`2.pdf' -> `2_AtoG_NaN.SNPs.pdf'
`3.pdf' -> `3_AtoG_NaN.SNPs.pdf'
`4.pdf' -> `4_AtoG_NaN.SNPs.pdf'
`summary.pdf' -> `summary_AtoG_NaN.SNPs.pdf'
`1.json' -> `1_AtoG_NaN.SNPs.json'
`2.json' -> `2_AtoG_NaN.SNPs.json'
`3.json' -> `3_AtoG_NaN.SNPs.json'
`4.json' -> `4_AtoG_NaN.SNPs.json'
`summary.txt' -> `summary_AtoG_NaN.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/NaN_mutant/mutation_motif/combined_counts_NaN_filter_plate.0_24.SNPs/strand_symmetry_analysis/CtoA for your results
`1.pdf' -> `1_CtoA_NaN.SNPs.pdf'
`2.pdf' -> `2_CtoA_NaN.SNPs.pdf'
`3.pdf' -> `3_CtoA_NaN.SNPs.pdf'
`4.pdf' -> `4_CtoA_NaN.SNPs.pdf'
`summary.pdf' -> `summary_CtoA_NaN.SNPs.pdf'
`1.json' -> `1_CtoA_NaN.SNPs.json'
`2.json' -> `2_CtoA_NaN.SNPs.json'
`3.json' -> `3_CtoA_NaN.SNPs.json'
`4.json' -> `4_CtoA_NaN.SNPs.json'
`summary.txt' -> `summary_CtoA_NaN.SNPs.txt'
Start base=C  RE=0.000005  :  Dev=18.37  :  df=2  :  p=0.00010277509026485653
Start base=A  RE=0.000338  :  Dev=28.72  :  df=2  :  p=5.805150584340402e-07
Done spectra!
`spectra.pdf' -> `spectra_NaN.SNPs.pdf'
`spectra_analysis.json' -> `spectra_analysis_NaN.SNPs.json'
`spectra_summary.txt' -> `spectra_summary_NaN.SNPs.txt'
```

## Run EMS


#### - Then only extract the EMS
```
sbatch --mem=80gb --nodes=1 --mail-user=llei@umn.edu -p ram256g,ram1t -t 8:00:00 --wrap="vcftools --gzvcf /home/morrellp/llei/context_test/Brachy/mutant/filter_plate.0_24.gatk.hf.sc.vcf.gz --keep EMS_acc.txt --recode --recode-INFO-all --out EMS_filter_plate.0_24.gatk.hf.sc"
```
#### - We need to filter out the SNPs with monomorphic SNPs
49*2=98 
Since 1/98=0.0102  (if singleton in the file), we need to filter out the MAF < 0.0102 

```
sbatch --mem=80gb --nodes=1 --mail-user=llei@umn.edu -p ram256g,ram1t -t 4:00:00 --wrap="vcftools --vcf EMS_filter_plate.0_24.gatk.hf.sc.recode.vcf --maf 0.01 --recode --recode-INFO-all --out EMS_filter_plate.0_24.gatk.hf.sc_mafgt0.01"
sbatch: Setting account: morrellp
Submitted batch job 156788514
After filtering, kept 1768725 out of a possible 1982116 Sites
```

#### - compress the filtered vcf file:

```
sbatch --mem=80gb --nodes=1 --mail-user=llei@umn.edu -p ram256g,ram1t -t 5:00:00 --wrap="module load bcftools && bcftools view /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/EMS_filter_plate.0_24.gatk.hf.sc_mafgt0.01.recode.vcf -Oz -o /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/EMS_filter_plate.0_24.gatk.hf.sc_mafgt0.01.recode.vcf.gz"
sbatch: Setting account: morrellp
Submitted batch job 156789227
```

#### - index the vcf.gz

```
bcftools index EMS_filter_plate.0_24.gatk.hf.sc_mafgt0.01.recode.vcf.gz

```

#### - submit the job with [prep_counts_table-mut_snps.sh]()

```
sbatch prep_counts_table-mut_snps.sh
```

#### - edit the [prep_counts_table-mut_snps_EMS.sh]()

#### - I need to install bedops

```
wget https://github.com/bedops/bedops/releases/download/v2.4.41/bedops_linux_x86_64-v2.4.41.tar.bz2

tar jxvf bedops_linux_x86_64-v2.4.41.tar.bz2
vi ~/.bash_profile
source ~/.bash_profile
mv bin/ bedops

```
!!! finally window size = 15 bp works!!!!!!!

#### - I need to install vcflib!!!!

```
 conda install -c bioconda vcflib
```

```
count table: /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables
 
cd /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables
 
realpath *to*.txt | sort -uV > separate_counts_file_list.txt
```

#### - edi the context_analysis-mut_snps_EMS.sh

```
./context_analysis-mut_snps_EMS.sh 
WARNING: $PATH does not agree with $PATH_modshare counter. The following directories' usage counters were adjusted to match. Note that this may mean that module unloading may not work correctly.
 /panfs/roc/groups/9/morrellp/llei/softwares/RAxML-7.2.8-ALPHA/ /panfs/roc/groups/9/morrellp/llei/.aspera/connect/bin/
Academic tradition requires you to cite works you base your article on.
If you use programs that use GNU Parallel to process data for an article in a
scientific publication, please cite:

  Tange, O. (2021, August 22). GNU Parallel 20210822 ('Kabul').
  Zenodo. https://doi.org/10.5281/zenodo.5233953

This helps funding further development; AND IT WON'T COST YOU A CENT.
If you pay 10000 EUR you should feel free to use GNU Parallel without citing.

More about funding GNU Parallel and the citation notice:
https://www.gnu.org/software/parallel/parallel_design.html#Citation-notice

To silence this citation notice: run 'parallel --citation' once.

Come on: You have run parallel 36 times. Isn't it about time 
you run 'parallel --citation' once to silence the citation notice?

simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/AtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis EMS.winFlank15bp EMS.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/AtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis EMS.winFlank15bp EMS.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/AtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis EMS.winFlank15bp EMS.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/CtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis EMS.winFlank15bp EMS.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/CtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis EMS.winFlank15bp EMS.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/CtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis EMS.winFlank15bp EMS.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/GtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis EMS.winFlank15bp EMS.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/GtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis EMS.winFlank15bp EMS.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/GtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis EMS.winFlank15bp EMS.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/TtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis EMS.winFlank15bp EMS.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/TtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis EMS.winFlank15bp EMS.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/TtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis EMS.winFlank15bp EMS.SNPs
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis/GtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_GtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`2.pdf' -> `2_GtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`3.pdf' -> `3_GtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`4.pdf' -> `4_GtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`summary.pdf' -> `summary_GtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`1.json' -> `1_GtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`2.json' -> `2_GtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`3.json' -> `3_GtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`4.json' -> `4_GtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`summary.txt' -> `summary_GtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis/AtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_AtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`2.pdf' -> `2_AtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`3.pdf' -> `3_AtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`4.pdf' -> `4_AtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`summary.pdf' -> `summary_AtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`1.json' -> `1_AtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`2.json' -> `2_AtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`3.json' -> `3_AtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`4.json' -> `4_AtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`summary.txt' -> `summary_AtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis/CtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_CtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`2.pdf' -> `2_CtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`3.pdf' -> `3_CtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`4.pdf' -> `4_CtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`summary.pdf' -> `summary_CtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`1.json' -> `1_CtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`2.json' -> `2_CtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`3.json' -> `3_CtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`4.json' -> `4_CtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`summary.txt' -> `summary_CtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis/AtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_AtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`2.pdf' -> `2_AtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`3.pdf' -> `3_AtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`4.pdf' -> `4_AtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`summary.pdf' -> `summary_AtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`1.json' -> `1_AtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`2.json' -> `2_AtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`3.json' -> `3_AtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`4.json' -> `4_AtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`summary.txt' -> `summary_AtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis/AtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_AtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`2.pdf' -> `2_AtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`3.pdf' -> `3_AtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`4.pdf' -> `4_AtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`summary.pdf' -> `summary_AtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`1.json' -> `1_AtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`2.json' -> `2_AtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`3.json' -> `3_AtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`4.json' -> `4_AtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`summary.txt' -> `summary_AtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis/CtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_CtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`2.pdf' -> `2_CtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`3.pdf' -> `3_CtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`4.pdf' -> `4_CtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`summary.pdf' -> `summary_CtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`1.json' -> `1_CtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`2.json' -> `2_CtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`3.json' -> `3_CtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`4.json' -> `4_CtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`summary.txt' -> `summary_CtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis/CtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_CtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`2.pdf' -> `2_CtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`3.pdf' -> `3_CtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`4.pdf' -> `4_CtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`summary.pdf' -> `summary_CtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`1.json' -> `1_CtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`2.json' -> `2_CtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`3.json' -> `3_CtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`4.json' -> `4_CtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`summary.txt' -> `summary_CtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis/GtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_GtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`2.pdf' -> `2_GtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`3.pdf' -> `3_GtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`4.pdf' -> `4_GtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`summary.pdf' -> `summary_GtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`1.json' -> `1_GtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`2.json' -> `2_GtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`3.json' -> `3_GtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`4.json' -> `4_GtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`summary.txt' -> `summary_GtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis/GtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_GtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`2.pdf' -> `2_GtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`3.pdf' -> `3_GtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`4.pdf' -> `4_GtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`summary.pdf' -> `summary_GtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`1.json' -> `1_GtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`2.json' -> `2_GtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`3.json' -> `3_GtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`4.json' -> `4_GtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`summary.txt' -> `summary_GtoT_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis/TtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_TtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`2.pdf' -> `2_TtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`3.pdf' -> `3_TtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`4.pdf' -> `4_TtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`summary.pdf' -> `summary_TtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`1.json' -> `1_TtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`2.json' -> `2_TtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`3.json' -> `3_TtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`4.json' -> `4_TtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`summary.txt' -> `summary_TtoA_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis/TtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_TtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`2.pdf' -> `2_TtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`3.pdf' -> `3_TtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`4.pdf' -> `4_TtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`summary.pdf' -> `summary_TtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`1.json' -> `1_TtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`2.json' -> `2_TtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`3.json' -> `3_TtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`4.json' -> `4_TtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`summary.txt' -> `summary_TtoC_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/simple_analysis/TtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_TtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`2.pdf' -> `2_TtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`3.pdf' -> `3_TtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`4.pdf' -> `4_TtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`summary.pdf' -> `summary_TtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.pdf'
`1.json' -> `1_TtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`2.json' -> `2_TtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`3.json' -> `3_TtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`4.json' -> `4_TtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.json'
`summary.txt' -> `summary_TtoG_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt_EMS.SNPs.txt'
Academic tradition requires you to cite works you base your article on.
If you use programs that use GNU Parallel to process data for an article in a
scientific publication, please cite:

  Tange, O. (2021, August 22). GNU Parallel 20210822 ('Kabul').
  Zenodo. https://doi.org/10.5281/zenodo.5233953

This helps funding further development; AND IT WON'T COST YOU A CENT.
If you pay 10000 EUR you should feel free to use GNU Parallel without citing.

More about funding GNU Parallel and the citation notice:
https://www.gnu.org/software/parallel/parallel_design.html#Citation-notice

To silence this citation notice: run 'parallel --citation' once.

Come on: You have run parallel 37 times. Isn't it about time 
you run 'parallel --citation' once to silence the citation notice?

test_strand_symmetry AtoC /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/combined_counts_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/strand_symmetry_analysis EMS.winFlank15bp EMS.SNPs
test_strand_symmetry AtoG /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/combined_counts_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/strand_symmetry_analysis EMS.winFlank15bp EMS.SNPs
test_strand_symmetry AtoT /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/combined_counts_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/strand_symmetry_analysis EMS.winFlank15bp EMS.SNPs
test_strand_symmetry CtoA /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/combined_counts_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/strand_symmetry_analysis EMS.winFlank15bp EMS.SNPs
test_strand_symmetry CtoG /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/combined_counts_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/strand_symmetry_analysis EMS.winFlank15bp EMS.SNPs
test_strand_symmetry CtoT /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/combined_counts_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/strand_symmetry_analysis EMS.winFlank15bp EMS.SNPs
test_strand_symmetry GtoA /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/combined_counts_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/strand_symmetry_analysis EMS.winFlank15bp EMS.SNPs
test_strand_symmetry GtoC /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/combined_counts_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/strand_symmetry_analysis EMS.winFlank15bp EMS.SNPs
test_strand_symmetry GtoT /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/combined_counts_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/strand_symmetry_analysis EMS.winFlank15bp EMS.SNPs
test_strand_symmetry TtoA /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/combined_counts_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/strand_symmetry_analysis EMS.winFlank15bp EMS.SNPs
test_strand_symmetry TtoC /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/combined_counts_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/strand_symmetry_analysis EMS.winFlank15bp EMS.SNPs
test_strand_symmetry TtoG /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables/combined_counts_EMS_filter_plate.0_24.gatk.hf.sc.mafgt0.01.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/strand_symmetry_analysis EMS.winFlank15bp EMS.SNPs
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/strand_symmetry_analysis/CtoT for your results
`1.pdf' -> `1_CtoT_EMS.SNPs.pdf'
`2.pdf' -> `2_CtoT_EMS.SNPs.pdf'
`3.pdf' -> `3_CtoT_EMS.SNPs.pdf'
`4.pdf' -> `4_CtoT_EMS.SNPs.pdf'
`summary.pdf' -> `summary_CtoT_EMS.SNPs.pdf'
`1.json' -> `1_CtoT_EMS.SNPs.json'
`2.json' -> `2_CtoT_EMS.SNPs.json'
`3.json' -> `3_CtoT_EMS.SNPs.json'
`4.json' -> `4_CtoT_EMS.SNPs.json'
`summary.txt' -> `summary_CtoT_EMS.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/strand_symmetry_analysis/CtoG for your results
`1.pdf' -> `1_CtoG_EMS.SNPs.pdf'
`2.pdf' -> `2_CtoG_EMS.SNPs.pdf'
`3.pdf' -> `3_CtoG_EMS.SNPs.pdf'
`4.pdf' -> `4_CtoG_EMS.SNPs.pdf'
`summary.pdf' -> `summary_CtoG_EMS.SNPs.pdf'
`1.json' -> `1_CtoG_EMS.SNPs.json'
`2.json' -> `2_CtoG_EMS.SNPs.json'
`3.json' -> `3_CtoG_EMS.SNPs.json'
`4.json' -> `4_CtoG_EMS.SNPs.json'
`summary.txt' -> `summary_CtoG_EMS.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/strand_symmetry_analysis/AtoG for your results
`1.pdf' -> `1_AtoG_EMS.SNPs.pdf'
`2.pdf' -> `2_AtoG_EMS.SNPs.pdf'
`3.pdf' -> `3_AtoG_EMS.SNPs.pdf'
`4.pdf' -> `4_AtoG_EMS.SNPs.pdf'
`summary.pdf' -> `summary_AtoG_EMS.SNPs.pdf'
`1.json' -> `1_AtoG_EMS.SNPs.json'
`2.json' -> `2_AtoG_EMS.SNPs.json'
`3.json' -> `3_AtoG_EMS.SNPs.json'
`4.json' -> `4_AtoG_EMS.SNPs.json'
`summary.txt' -> `summary_AtoG_EMS.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/strand_symmetry_analysis/CtoA for your results
`1.pdf' -> `1_CtoA_EMS.SNPs.pdf'
`2.pdf' -> `2_CtoA_EMS.SNPs.pdf'
`3.pdf' -> `3_CtoA_EMS.SNPs.pdf'
`4.pdf' -> `4_CtoA_EMS.SNPs.pdf'
`summary.pdf' -> `summary_CtoA_EMS.SNPs.pdf'
`1.json' -> `1_CtoA_EMS.SNPs.json'
`2.json' -> `2_CtoA_EMS.SNPs.json'
`3.json' -> `3_CtoA_EMS.SNPs.json'
`4.json' -> `4_CtoA_EMS.SNPs.json'
`summary.txt' -> `summary_CtoA_EMS.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/strand_symmetry_analysis/AtoT for your results
`1.pdf' -> `1_AtoT_EMS.SNPs.pdf'
`2.pdf' -> `2_AtoT_EMS.SNPs.pdf'
`3.pdf' -> `3_AtoT_EMS.SNPs.pdf'
`4.pdf' -> `4_AtoT_EMS.SNPs.pdf'
`summary.pdf' -> `summary_AtoT_EMS.SNPs.pdf'
`1.json' -> `1_AtoT_EMS.SNPs.json'
`2.json' -> `2_AtoT_EMS.SNPs.json'
`3.json' -> `3_AtoT_EMS.SNPs.json'
`4.json' -> `4_AtoT_EMS.SNPs.json'
`summary.txt' -> `summary_AtoT_EMS.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/mutation_motif/combined_counts_EMS_filter_plate.0_24.mafgt0.01.SNPs/strand_symmetry_analysis/AtoC for your results
`1.pdf' -> `1_AtoC_EMS.SNPs.pdf'
`2.pdf' -> `2_AtoC_EMS.SNPs.pdf'
`3.pdf' -> `3_AtoC_EMS.SNPs.pdf'
`4.pdf' -> `4_AtoC_EMS.SNPs.pdf'
`summary.pdf' -> `summary_AtoC_EMS.SNPs.pdf'
`1.json' -> `1_AtoC_EMS.SNPs.json'
`2.json' -> `2_AtoC_EMS.SNPs.json'
`3.json' -> `3_AtoC_EMS.SNPs.json'
`4.json' -> `4_AtoC_EMS.SNPs.json'
`summary.txt' -> `summary_AtoC_EMS.SNPs.txt'
Start base=A  RE=0.000169  :  Dev=12.82  :  df=2  :  p=0.0016472560557268525
Start base=C  RE=0.000004  :  Dev=12.70  :  df=2  :  p=0.0017504646377557336
Done spectra!
`spectra.pdf' -> `spectra_EMS.SNPs.pdf'
`spectra_analysis.json' -> `spectra_analysis_EMS.SNPs.json'
`spectra_summary.txt' -> `spectra_summary_EMS.SNPs.txt'

```

## Run FN data

#### - Only extract the EMS
```
sbatch --mem=80gb --nodes=1 --mail-user=llei@umn.edu -p ram256g,ram1t -t 8:00:00 --wrap="vcftools --gzvcf /home/morrellp/llei/context_test/Brachy/mutant/filter_plate.0_24.gatk.hf.sc.vcf.gz --keep FN_acc.txt --recode --recode-INFO-all --out FN_filter_plate.0_24.gatk.hf.sc"
sbatch: Setting account: morrellp
Submitted batch job 156803444
```

#### - We need to filter out the SNPs with monomorphic SNPs

```
40*2=80 
Since 1/80=0.0125  (if singleton in the file), we need to filter out the MAF < 0.0125 
sbatch --mem=80gb --nodes=1 --mail-user=llei@umn.edu -p ram256g,ram1t -t 4:00:00 --wrap="vcftools --vcf FN_filter_plate.0_24.gatk.hf.sc.recode.vcf --maf 0.01 --recode --recode-INFO-all --out FN_filter_plate.0_24.gatk.hf.sc_mafgt0.01"
sbatch: Setting account: morrellp
Submitted batch job 156803720


After filtering, kept 1,857,958 out of a possible 1982116 Sites

```

#### - compress the filtered vcf file:
```
sbatch --mem=80gb --nodes=1 --mail-user=llei@umn.edu -p ram256g,ram1t -t 5:00:00 --wrap="module load bcftools && bcftools view /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/FN_filter_plate.0_24.gatk.hf.sc_mafgt0.01.recode.vcf -Oz -o /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/FN_filter_plate.0_24.gatk.hf.sc_mafgt0.01.recode.vcf.gz"
sbatch: Setting account: morrellp
Submitted batch job 156803771
 ```

#### - index the vcf.gz
```
bcftools index FN_filter_plate.0_24.gatk.hf.sc_mafgt0.01.recode.vcf.gz
sbatch prep_counts_table-mut_snps_FN.sh
```



#### - edit the prep_counts_table-mut_snps_EMS.sh

```
sbatch prep_counts_table-mut_snps_EMS.sh
```

```
count table: /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables
 
cd /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/EMS_mutant/counts_tables
 
realpath *to*.txt | sort -uV > separate_counts_file_list.txt
```

#### - edi the context_analysis-mut_snps_EMS.sh 

```
./context_analysis-mut_snps_EMS.sh 
```


## Run natural 

```
module load bcftools
```

#### - compress

```
sbatch --mem=80gb --nodes=1 --mail-user=llei@umn.edu -p ram256g,ram1t -t 1:00:00 --wrap="module load bcftools && bcftools view /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/common_variants_SNPs.recode.vcf -Oz -o /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/common_variants_SNPs.recode.vcf.gz"
sbatch: Setting account: morrellp
Submitted batch job 156796542

```

```
bcftools index common_variants_SNPs.recode.vcf.gz
```
#### - filter
```
sbatch --mem=80gb --nodes=1 --mail-user=llei@umn.edu -p ram256g,ram1t -t 12:00:00 --wrap="module load bcftools &&  bcftools view -f PASS -m2 -M2 -v snps -R /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/chr_only.bed /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/common_variants_SNPs.recode.vcf.gz -Oz -o /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/filter_common_variants_SNPs.recode.vcf.gz"
sbatch: Setting account: morrellp
Submitted batch job 156797072
```

```
bcftools index filter_common_variants_SNPs.recode.vcf.gz
```
### - Rare:

#### - compress
```
sbatch --mem=80gb --nodes=1 --mail-user=llei@umn.edu -p ram256g,ram1t -t 1:00:00 --wrap="module load bcftools && bcftools view /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/rare_variants_SNPs.recode.vcf -Oz -o /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/rare_variants_SNPs.recode.vcf.gz"
sbatch: Setting account: morrellp
Submitted batch job 156796212
```
```
bcftools index  rare_variants_SNPs.recode.vcf.gz
```

#### - filter
```
sbatch --mem=80gb --nodes=1 --mail-user=llei@umn.edu -p ram256g,ram1t -t 12:00:00 --wrap="module load bcftools &&  bcftools view -f PASS -m2 -M2 -v snps -R /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/chr_only.bed /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/rare_variants_SNPs.recode.vcf.gz -Oz -o /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/filter_rare_variants_SNPs.recode.vcf.gz"
sbatch: Setting account: morrellp
Submitted batch job 156796773
```
```
bcftools index filter_rare_variants_SNPs.recode.vcf.gz
```
#### edit the [prep_counts_table-mut_snps_rare.sh]()

```
 sbatch prep_counts_table-mut_snps_rare.sh
```

```
realpath *to*.txt | sort -uV > separate_counts_file_list.txt
```

### edit [context_analysis-mut_snps_rare.sh]()

```
./context_analysis-mut_snps_rare.sh 
WARNING: $PATH does not agree with $PATH_modshare counter. The following directories' usage counters were adjusted to match. Note that this may mean that module unloading may not work correctly.
 /panfs/roc/groups/9/morrellp/llei/softwares/RAxML-7.2.8-ALPHA/ /panfs/roc/groups/9/morrellp/llei/.aspera/connect/bin/
Academic tradition requires you to cite works you base your article on.
If you use programs that use GNU Parallel to process data for an article in a
scientific publication, please cite:

  Tange, O. (2021, August 22). GNU Parallel 20210822 ('Kabul').
  Zenodo. https://doi.org/10.5281/zenodo.5233953

This helps funding further development; AND IT WON'T COST YOU A CENT.
If you pay 10000 EUR you should feel free to use GNU Parallel without citing.

More about funding GNU Parallel and the citation notice:
https://www.gnu.org/software/parallel/parallel_design.html#Citation-notice

To silence this citation notice: run 'parallel --citation' once.

Come on: You have run parallel 38 times. Isn't it about time 
you run 'parallel --citation' once to silence the citation notice?

simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/AtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis rare_natural.winFlank15bp rare_natural.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/AtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis rare_natural.winFlank15bp rare_natural.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/AtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis rare_natural.winFlank15bp rare_natural.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/CtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis rare_natural.winFlank15bp rare_natural.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/CtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis rare_natural.winFlank15bp rare_natural.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/CtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis rare_natural.winFlank15bp rare_natural.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/GtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis rare_natural.winFlank15bp rare_natural.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/GtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis rare_natural.winFlank15bp rare_natural.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/GtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis rare_natural.winFlank15bp rare_natural.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/TtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis rare_natural.winFlank15bp rare_natural.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/TtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis rare_natural.winFlank15bp rare_natural.SNPs
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/TtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis rare_natural.winFlank15bp rare_natural.SNPs
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis/GtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_GtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`2.pdf' -> `2_GtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`3.pdf' -> `3_GtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`4.pdf' -> `4_GtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`summary.pdf' -> `summary_GtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`1.json' -> `1_GtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`2.json' -> `2_GtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`3.json' -> `3_GtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`4.json' -> `4_GtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`summary.txt' -> `summary_GtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis/TtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_TtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`2.pdf' -> `2_TtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`3.pdf' -> `3_TtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`4.pdf' -> `4_TtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`summary.pdf' -> `summary_TtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`1.json' -> `1_TtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`2.json' -> `2_TtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`3.json' -> `3_TtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`4.json' -> `4_TtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`summary.txt' -> `summary_TtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis/TtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_TtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`2.pdf' -> `2_TtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`3.pdf' -> `3_TtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`4.pdf' -> `4_TtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`summary.pdf' -> `summary_TtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`1.json' -> `1_TtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`2.json' -> `2_TtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`3.json' -> `3_TtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`4.json' -> `4_TtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`summary.txt' -> `summary_TtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis/AtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_AtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`2.pdf' -> `2_AtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`3.pdf' -> `3_AtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`4.pdf' -> `4_AtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`summary.pdf' -> `summary_AtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`1.json' -> `1_AtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`2.json' -> `2_AtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`3.json' -> `3_AtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`4.json' -> `4_AtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`summary.txt' -> `summary_AtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis/AtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_AtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`2.pdf' -> `2_AtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`3.pdf' -> `3_AtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`4.pdf' -> `4_AtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`summary.pdf' -> `summary_AtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`1.json' -> `1_AtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`2.json' -> `2_AtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`3.json' -> `3_AtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`4.json' -> `4_AtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`summary.txt' -> `summary_AtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis/CtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_CtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`2.pdf' -> `2_CtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`3.pdf' -> `3_CtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`4.pdf' -> `4_CtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`summary.pdf' -> `summary_CtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`1.json' -> `1_CtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`2.json' -> `2_CtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`3.json' -> `3_CtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`4.json' -> `4_CtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`summary.txt' -> `summary_CtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis/AtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_AtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`2.pdf' -> `2_AtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`3.pdf' -> `3_AtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`4.pdf' -> `4_AtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`summary.pdf' -> `summary_AtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`1.json' -> `1_AtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`2.json' -> `2_AtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`3.json' -> `3_AtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`4.json' -> `4_AtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`summary.txt' -> `summary_AtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis/CtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_CtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`2.pdf' -> `2_CtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`3.pdf' -> `3_CtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`4.pdf' -> `4_CtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`summary.pdf' -> `summary_CtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`1.json' -> `1_CtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`2.json' -> `2_CtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`3.json' -> `3_CtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`4.json' -> `4_CtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`summary.txt' -> `summary_CtoG_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis/CtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_CtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`2.pdf' -> `2_CtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`3.pdf' -> `3_CtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`4.pdf' -> `4_CtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`summary.pdf' -> `summary_CtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`1.json' -> `1_CtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`2.json' -> `2_CtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`3.json' -> `3_CtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`4.json' -> `4_CtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`summary.txt' -> `summary_CtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis/TtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_TtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`2.pdf' -> `2_TtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`3.pdf' -> `3_TtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`4.pdf' -> `4_TtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`summary.pdf' -> `summary_TtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`1.json' -> `1_TtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`2.json' -> `2_TtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`3.json' -> `3_TtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`4.json' -> `4_TtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`summary.txt' -> `summary_TtoC_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis/GtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_GtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`2.pdf' -> `2_GtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`3.pdf' -> `3_GtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`4.pdf' -> `4_GtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`summary.pdf' -> `summary_GtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`1.json' -> `1_GtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`2.json' -> `2_GtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`3.json' -> `3_GtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`4.json' -> `4_GtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`summary.txt' -> `summary_GtoA_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/simple_analysis/GtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_GtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`2.pdf' -> `2_GtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`3.pdf' -> `3_GtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`4.pdf' -> `4_GtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`summary.pdf' -> `summary_GtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.pdf'
`1.json' -> `1_GtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`2.json' -> `2_GtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`3.json' -> `3_GtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`4.json' -> `4_GtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.json'
`summary.txt' -> `summary_GtoT_filter_rare_variants_SNPs.recode.winFlank15bp.txt_rare_natural.SNPs.txt'
Academic tradition requires you to cite works you base your article on.
If you use programs that use GNU Parallel to process data for an article in a
scientific publication, please cite:

  Tange, O. (2021, August 22). GNU Parallel 20210822 ('Kabul').
  Zenodo. https://doi.org/10.5281/zenodo.5233953

This helps funding further development; AND IT WON'T COST YOU A CENT.
If you pay 10000 EUR you should feel free to use GNU Parallel without citing.

More about funding GNU Parallel and the citation notice:
https://www.gnu.org/software/parallel/parallel_design.html#Citation-notice

To silence this citation notice: run 'parallel --citation' once.

Come on: You have run parallel 39 times. Isn't it about time 
you run 'parallel --citation' once to silence the citation notice?

test_strand_symmetry AtoC /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/combined_counts_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/strand_symmetry_analysis rare_natural.winFlank15bp rare_natural.SNPs
test_strand_symmetry AtoG /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/combined_counts_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/strand_symmetry_analysis rare_natural.winFlank15bp rare_natural.SNPs
test_strand_symmetry AtoT /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/combined_counts_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/strand_symmetry_analysis rare_natural.winFlank15bp rare_natural.SNPs
test_strand_symmetry CtoA /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/combined_counts_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/strand_symmetry_analysis rare_natural.winFlank15bp rare_natural.SNPs
test_strand_symmetry CtoG /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/combined_counts_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/strand_symmetry_analysis rare_natural.winFlank15bp rare_natural.SNPs
test_strand_symmetry CtoT /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/combined_counts_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/strand_symmetry_analysis rare_natural.winFlank15bp rare_natural.SNPs
test_strand_symmetry GtoA /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/combined_counts_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/strand_symmetry_analysis rare_natural.winFlank15bp rare_natural.SNPs
test_strand_symmetry GtoC /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/combined_counts_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/strand_symmetry_analysis rare_natural.winFlank15bp rare_natural.SNPs
test_strand_symmetry GtoT /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/combined_counts_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/strand_symmetry_analysis rare_natural.winFlank15bp rare_natural.SNPs
test_strand_symmetry TtoA /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/combined_counts_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/strand_symmetry_analysis rare_natural.winFlank15bp rare_natural.SNPs
test_strand_symmetry TtoC /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/combined_counts_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/strand_symmetry_analysis rare_natural.winFlank15bp rare_natural.SNPs
test_strand_symmetry TtoG /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/counts_tables/combined_counts_filter_rare_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/strand_symmetry_analysis rare_natural.winFlank15bp rare_natural.SNPs
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/strand_symmetry_analysis/AtoC for your results
`1.pdf' -> `1_AtoC_rare_natural.SNPs.pdf'
`2.pdf' -> `2_AtoC_rare_natural.SNPs.pdf'
`3.pdf' -> `3_AtoC_rare_natural.SNPs.pdf'
`4.pdf' -> `4_AtoC_rare_natural.SNPs.pdf'
`summary.pdf' -> `summary_AtoC_rare_natural.SNPs.pdf'
`1.json' -> `1_AtoC_rare_natural.SNPs.json'
`2.json' -> `2_AtoC_rare_natural.SNPs.json'
`3.json' -> `3_AtoC_rare_natural.SNPs.json'
`4.json' -> `4_AtoC_rare_natural.SNPs.json'
`summary.txt' -> `summary_AtoC_rare_natural.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/strand_symmetry_analysis/AtoG for your results
`1.pdf' -> `1_AtoG_rare_natural.SNPs.pdf'
`2.pdf' -> `2_AtoG_rare_natural.SNPs.pdf'
`3.pdf' -> `3_AtoG_rare_natural.SNPs.pdf'
`4.pdf' -> `4_AtoG_rare_natural.SNPs.pdf'
`summary.pdf' -> `summary_AtoG_rare_natural.SNPs.pdf'
`1.json' -> `1_AtoG_rare_natural.SNPs.json'
`2.json' -> `2_AtoG_rare_natural.SNPs.json'
`3.json' -> `3_AtoG_rare_natural.SNPs.json'
`4.json' -> `4_AtoG_rare_natural.SNPs.json'
`summary.txt' -> `summary_AtoG_rare_natural.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/strand_symmetry_analysis/CtoA for your results
`1.pdf' -> `1_CtoA_rare_natural.SNPs.pdf'
`2.pdf' -> `2_CtoA_rare_natural.SNPs.pdf'
`3.pdf' -> `3_CtoA_rare_natural.SNPs.pdf'
`4.pdf' -> `4_CtoA_rare_natural.SNPs.pdf'
`summary.pdf' -> `summary_CtoA_rare_natural.SNPs.pdf'
`1.json' -> `1_CtoA_rare_natural.SNPs.json'
`2.json' -> `2_CtoA_rare_natural.SNPs.json'
`3.json' -> `3_CtoA_rare_natural.SNPs.json'
`4.json' -> `4_CtoA_rare_natural.SNPs.json'
`summary.txt' -> `summary_CtoA_rare_natural.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/strand_symmetry_analysis/CtoT for your results
`1.pdf' -> `1_CtoT_rare_natural.SNPs.pdf'
`2.pdf' -> `2_CtoT_rare_natural.SNPs.pdf'
`3.pdf' -> `3_CtoT_rare_natural.SNPs.pdf'
`4.pdf' -> `4_CtoT_rare_natural.SNPs.pdf'
`summary.pdf' -> `summary_CtoT_rare_natural.SNPs.pdf'
`1.json' -> `1_CtoT_rare_natural.SNPs.json'
`2.json' -> `2_CtoT_rare_natural.SNPs.json'
`3.json' -> `3_CtoT_rare_natural.SNPs.json'
`4.json' -> `4_CtoT_rare_natural.SNPs.json'
`summary.txt' -> `summary_CtoT_rare_natural.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/strand_symmetry_analysis/AtoT for your results
`1.pdf' -> `1_AtoT_rare_natural.SNPs.pdf'
`2.pdf' -> `2_AtoT_rare_natural.SNPs.pdf'
`3.pdf' -> `3_AtoT_rare_natural.SNPs.pdf'
`4.pdf' -> `4_AtoT_rare_natural.SNPs.pdf'
`summary.pdf' -> `summary_AtoT_rare_natural.SNPs.pdf'
`1.json' -> `1_AtoT_rare_natural.SNPs.json'
`2.json' -> `2_AtoT_rare_natural.SNPs.json'
`3.json' -> `3_AtoT_rare_natural.SNPs.json'
`4.json' -> `4_AtoT_rare_natural.SNPs.json'
`summary.txt' -> `summary_AtoT_rare_natural.SNPs.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/rare_natural/mutation_motif/combined_counts_rare_filter.SNPs/strand_symmetry_analysis/CtoG for your results
`1.pdf' -> `1_CtoG_rare_natural.SNPs.pdf'
`2.pdf' -> `2_CtoG_rare_natural.SNPs.pdf'
`3.pdf' -> `3_CtoG_rare_natural.SNPs.pdf'
`4.pdf' -> `4_CtoG_rare_natural.SNPs.pdf'
`summary.pdf' -> `summary_CtoG_rare_natural.SNPs.pdf'
`1.json' -> `1_CtoG_rare_natural.SNPs.json'
`2.json' -> `2_CtoG_rare_natural.SNPs.json'
`3.json' -> `3_CtoG_rare_natural.SNPs.json'
`4.json' -> `4_CtoG_rare_natural.SNPs.json'
`summary.txt' -> `summary_CtoG_rare_natural.SNPs.txt'
Start base=A  RE=0.000001  :  Dev=1.02  :  df=2  :  p=0.601268990723816
Start base=C  RE=0.000000  :  Dev=0.13  :  df=2  :  p=0.9353581390568536
Done spectra!
`spectra.pdf' -> `spectra_rare_natural.SNPs.pdf'
`spectra_analysis.json' -> `spectra_analysis_rare_natural.SNPs.json'
`spectra_summary.txt' -> `spectra_summary_rare_natural.SNPs.txt'
(mut_motif) llei@ln0006 [~/context_test/Brachy/scripts] % 



./context_analysis-mut_snps_com.sh
./context_analysis-mut_snps_com.sh
WARNING: $PATH does not agree with $PATH_modshare counter. The following directories' usage counters were adjusted to match. Note that this may mean that module unloading may not work correctly.
 /panfs/roc/groups/9/morrellp/llei/softwares/RAxML-7.2.8-ALPHA/ /panfs/roc/groups/9/morrellp/llei/.aspera/connect/bin/
Academic tradition requires you to cite works you base your article on.
If you use programs that use GNU Parallel to process data for an article in a
scientific publication, please cite:

  Tange, O. (2021, August 22). GNU Parallel 20210822 ('Kabul').
  Zenodo. https://doi.org/10.5281/zenodo.5233953

This helps funding further development; AND IT WON'T COST YOU A CENT.
If you pay 10000 EUR you should feel free to use GNU Parallel without citing.

More about funding GNU Parallel and the citation notice:
https://www.gnu.org/software/parallel/parallel_design.html#Citation-notice

To silence this citation notice: run 'parallel --citation' once.

Come on: You have run parallel 40 times. Isn't it about time 
you run 'parallel --citation' once to silence the citation notice?

simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/AtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis com.natural.winFlank15bp com.natural
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/AtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis com.natural.winFlank15bp com.natural
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/AtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis com.natural.winFlank15bp com.natural
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/CtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis com.natural.winFlank15bp com.natural
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/CtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis com.natural.winFlank15bp com.natural
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/CtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis com.natural.winFlank15bp com.natural
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/GtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis com.natural.winFlank15bp com.natural
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/GtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis com.natural.winFlank15bp com.natural
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/GtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis com.natural.winFlank15bp com.natural
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/TtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis com.natural.winFlank15bp com.natural
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/TtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis com.natural.winFlank15bp com.natural
simple_analysis /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/TtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis com.natural.winFlank15bp com.natural
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis/GtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_GtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`2.pdf' -> `2_GtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`3.pdf' -> `3_GtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`4.pdf' -> `4_GtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`summary.pdf' -> `summary_GtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`1.json' -> `1_GtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`2.json' -> `2_GtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`3.json' -> `3_GtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`4.json' -> `4_GtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`summary.txt' -> `summary_GtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis/AtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_AtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`2.pdf' -> `2_AtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`3.pdf' -> `3_AtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`4.pdf' -> `4_AtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`summary.pdf' -> `summary_AtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`1.json' -> `1_AtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`2.json' -> `2_AtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`3.json' -> `3_AtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`4.json' -> `4_AtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`summary.txt' -> `summary_AtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis/AtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_AtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`2.pdf' -> `2_AtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`3.pdf' -> `3_AtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`4.pdf' -> `4_AtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`summary.pdf' -> `summary_AtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`1.json' -> `1_AtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`2.json' -> `2_AtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`3.json' -> `3_AtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`4.json' -> `4_AtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`summary.txt' -> `summary_AtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis/AtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_AtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`2.pdf' -> `2_AtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`3.pdf' -> `3_AtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`4.pdf' -> `4_AtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`summary.pdf' -> `summary_AtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`1.json' -> `1_AtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`2.json' -> `2_AtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`3.json' -> `3_AtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`4.json' -> `4_AtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`summary.txt' -> `summary_AtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis/CtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_CtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`2.pdf' -> `2_CtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`3.pdf' -> `3_CtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`4.pdf' -> `4_CtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`summary.pdf' -> `summary_CtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`1.json' -> `1_CtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`2.json' -> `2_CtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`3.json' -> `3_CtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`4.json' -> `4_CtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`summary.txt' -> `summary_CtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis/CtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_CtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`2.pdf' -> `2_CtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`3.pdf' -> `3_CtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`4.pdf' -> `4_CtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`summary.pdf' -> `summary_CtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`1.json' -> `1_CtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`2.json' -> `2_CtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`3.json' -> `3_CtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`4.json' -> `4_CtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`summary.txt' -> `summary_CtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis/GtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_GtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`2.pdf' -> `2_GtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`3.pdf' -> `3_GtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`4.pdf' -> `4_GtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`summary.pdf' -> `summary_GtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`1.json' -> `1_GtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`2.json' -> `2_GtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`3.json' -> `3_GtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`4.json' -> `4_GtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`summary.txt' -> `summary_GtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis/GtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_GtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`2.pdf' -> `2_GtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`3.pdf' -> `3_GtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`4.pdf' -> `4_GtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`summary.pdf' -> `summary_GtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`1.json' -> `1_GtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`2.json' -> `2_GtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`3.json' -> `3_GtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`4.json' -> `4_GtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`summary.txt' -> `summary_GtoT_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis/TtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_TtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`2.pdf' -> `2_TtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`3.pdf' -> `3_TtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`4.pdf' -> `4_TtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`summary.pdf' -> `summary_TtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`1.json' -> `1_TtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`2.json' -> `2_TtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`3.json' -> `3_TtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`4.json' -> `4_TtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`summary.txt' -> `summary_TtoC_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis/CtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_CtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`2.pdf' -> `2_CtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`3.pdf' -> `3_CtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`4.pdf' -> `4_CtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`summary.pdf' -> `summary_CtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`1.json' -> `1_CtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`2.json' -> `2_CtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`3.json' -> `3_CtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`4.json' -> `4_CtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`summary.txt' -> `summary_CtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis/TtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_TtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`2.pdf' -> `2_TtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`3.pdf' -> `3_TtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`4.pdf' -> `4_TtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`summary.pdf' -> `summary_TtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`1.json' -> `1_TtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`2.json' -> `2_TtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`3.json' -> `3_TtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`4.json' -> `4_TtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`summary.txt' -> `summary_TtoG_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/simple_analysis/TtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt for your results
`1.pdf' -> `1_TtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`2.pdf' -> `2_TtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`3.pdf' -> `3_TtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`4.pdf' -> `4_TtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`summary.pdf' -> `summary_TtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.pdf'
`1.json' -> `1_TtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`2.json' -> `2_TtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`3.json' -> `3_TtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`4.json' -> `4_TtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.json'
`summary.txt' -> `summary_TtoA_filter_common_variants_SNPs.recode.winFlank15bp.txt_com.natural.txt'
Academic tradition requires you to cite works you base your article on.
If you use programs that use GNU Parallel to process data for an article in a
scientific publication, please cite:

  Tange, O. (2021, August 22). GNU Parallel 20210822 ('Kabul').
  Zenodo. https://doi.org/10.5281/zenodo.5233953

This helps funding further development; AND IT WON'T COST YOU A CENT.
If you pay 10000 EUR you should feel free to use GNU Parallel without citing.

More about funding GNU Parallel and the citation notice:
https://www.gnu.org/software/parallel/parallel_design.html#Citation-notice

To silence this citation notice: run 'parallel --citation' once.

Come on: You have run parallel 41 times. Isn't it about time 
you run 'parallel --citation' once to silence the citation notice?

test_strand_symmetry AtoC /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/combined_counts_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/strand_symmetry_analysis com.natural.winFlank15bp com.natural
test_strand_symmetry AtoG /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/combined_counts_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/strand_symmetry_analysis com.natural.winFlank15bp com.natural
test_strand_symmetry AtoT /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/combined_counts_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/strand_symmetry_analysis com.natural.winFlank15bp com.natural
test_strand_symmetry CtoA /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/combined_counts_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/strand_symmetry_analysis com.natural.winFlank15bp com.natural
test_strand_symmetry CtoG /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/combined_counts_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/strand_symmetry_analysis com.natural.winFlank15bp com.natural
test_strand_symmetry CtoT /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/combined_counts_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/strand_symmetry_analysis com.natural.winFlank15bp com.natural
test_strand_symmetry GtoA /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/combined_counts_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/strand_symmetry_analysis com.natural.winFlank15bp com.natural
test_strand_symmetry GtoC /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/combined_counts_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/strand_symmetry_analysis com.natural.winFlank15bp com.natural
test_strand_symmetry GtoT /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/combined_counts_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/strand_symmetry_analysis com.natural.winFlank15bp com.natural
test_strand_symmetry TtoA /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/combined_counts_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/strand_symmetry_analysis com.natural.winFlank15bp com.natural
test_strand_symmetry TtoC /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/combined_counts_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/strand_symmetry_analysis com.natural.winFlank15bp com.natural
test_strand_symmetry TtoG /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/counts_tables/combined_counts_filter_common_variants_SNPs.recode.winFlank15bp.txt /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/strand_symmetry_analysis com.natural.winFlank15bp com.natural
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/strand_symmetry_analysis/AtoT for your results
`1.pdf' -> `1_AtoT_com.natural.pdf'
`2.pdf' -> `2_AtoT_com.natural.pdf'
`3.pdf' -> `3_AtoT_com.natural.pdf'
`4.pdf' -> `4_AtoT_com.natural.pdf'
`summary.pdf' -> `summary_AtoT_com.natural.pdf'
`1.json' -> `1_AtoT_com.natural.json'
`2.json' -> `2_AtoT_com.natural.json'
`3.json' -> `3_AtoT_com.natural.json'
`4.json' -> `4_AtoT_com.natural.json'
`summary.txt' -> `summary_AtoT_com.natural.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/strand_symmetry_analysis/CtoA for your results
`1.pdf' -> `1_CtoA_com.natural.pdf'
`2.pdf' -> `2_CtoA_com.natural.pdf'
`3.pdf' -> `3_CtoA_com.natural.pdf'
`4.pdf' -> `4_CtoA_com.natural.pdf'
`summary.pdf' -> `summary_CtoA_com.natural.pdf'
`1.json' -> `1_CtoA_com.natural.json'
`2.json' -> `2_CtoA_com.natural.json'
`3.json' -> `3_CtoA_com.natural.json'
`4.json' -> `4_CtoA_com.natural.json'
`summary.txt' -> `summary_CtoA_com.natural.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/strand_symmetry_analysis/CtoT for your results
`1.pdf' -> `1_CtoT_com.natural.pdf'
`2.pdf' -> `2_CtoT_com.natural.pdf'
`3.pdf' -> `3_CtoT_com.natural.pdf'
`4.pdf' -> `4_CtoT_com.natural.pdf'
`summary.pdf' -> `summary_CtoT_com.natural.pdf'
`1.json' -> `1_CtoT_com.natural.json'
`2.json' -> `2_CtoT_com.natural.json'
`3.json' -> `3_CtoT_com.natural.json'
`4.json' -> `4_CtoT_com.natural.json'
`summary.txt' -> `summary_CtoT_com.natural.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/strand_symmetry_analysis/AtoC for your results
`1.pdf' -> `1_AtoC_com.natural.pdf'
`2.pdf' -> `2_AtoC_com.natural.pdf'
`3.pdf' -> `3_AtoC_com.natural.pdf'
`4.pdf' -> `4_AtoC_com.natural.pdf'
`summary.pdf' -> `summary_AtoC_com.natural.pdf'
`1.json' -> `1_AtoC_com.natural.json'
`2.json' -> `2_AtoC_com.natural.json'
`3.json' -> `3_AtoC_com.natural.json'
`4.json' -> `4_AtoC_com.natural.json'
`summary.txt' -> `summary_AtoC_com.natural.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/strand_symmetry_analysis/CtoG for your results
`1.pdf' -> `1_CtoG_com.natural.pdf'
`2.pdf' -> `2_CtoG_com.natural.pdf'
`3.pdf' -> `3_CtoG_com.natural.pdf'
`4.pdf' -> `4_CtoG_com.natural.pdf'
`summary.pdf' -> `summary_CtoG_com.natural.pdf'
`1.json' -> `1_CtoG_com.natural.json'
`2.json' -> `2_CtoG_com.natural.json'
`3.json' -> `3_CtoG_com.natural.json'
`4.json' -> `4_CtoG_com.natural.json'
`summary.txt' -> `summary_CtoG_com.natural.txt'
Doing single position analysis
Doing two positions analysis
Doing three positions analysis
Doing four positions analysis
Done! Check /panfs/jay/groups/9/morrellp/llei/context_test/Brachy/mutant/results/com_natural/mutation_motif/combined_counts_com_natural.SNPs/strand_symmetry_analysis/AtoG for your results
`1.pdf' -> `1_AtoG_com.natural.pdf'
`2.pdf' -> `2_AtoG_com.natural.pdf'
`3.pdf' -> `3_AtoG_com.natural.pdf'
`4.pdf' -> `4_AtoG_com.natural.pdf'
`summary.pdf' -> `summary_AtoG_com.natural.pdf'
`1.json' -> `1_AtoG_com.natural.json'
`2.json' -> `2_AtoG_com.natural.json'
`3.json' -> `3_AtoG_com.natural.json'
`4.json' -> `4_AtoG_com.natural.json'
`summary.txt' -> `summary_AtoG_com.natural.txt'
Start base=C  RE=0.000001  :  Dev=4.97  :  df=2  :  p=0.08323929271509731
Start base=A  RE=0.000001  :  Dev=2.97  :  df=2  :  p=0.22658983427793933
Done spectra!
`spectra.pdf' -> `spectra_com.natural.pdf'
`spectra_analysis.json' -> `spectra_analysis_com.natural.json'
`spectra_summary.txt' -> `spectra_summary_com.natural.txt'

```

#### - count the motifs
```
(mut_motif) llei@ln0006 [~/context_test/Brachy/scripts] % 

module load emboss/6.6.0

compseq -sequence only_Bd_BdistachyonBd21_3_460_v1.0.fa -word 2 -outfile dinucleotide_only_Bd_BdistachyonBd21_3_460_v1.0.comp

compseq -sequence only_Bd_BdistachyonBd21_3_460_v1.0.fa -word 3 -outfile trinucleotide_only_Bd_BdistachyonBd21_3_460_v1.0.comp

compseq -sequence only_Bd_BdistachyonBd21_3_460_v1.0.fa -word 4 -outfile fournucleotide_only_Bd_BdistachyonBd21_3_460_v1.0.comp

```